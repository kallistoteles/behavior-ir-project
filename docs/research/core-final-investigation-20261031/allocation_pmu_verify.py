"""Independently recompute the complete allocation-window receipts and summaries."""
import collections
import datetime
import gzip
import json
import math
import re
import statistics
import tarfile
from pathlib import Path
import allocation_pmu as pmu
import common

HERE=Path(__file__).resolve().parent


def load(path):return json.loads(path.read_text())
def lines(path):return [json.loads(line) for line in path.read_text().splitlines()]


def sample(line):
    match=re.fullmatch(r'\s*(\d+)\s+([0-9a-fA-F]+)\s+(.+)\s+\((.+)\)\s*',line)
    if not match:return None
    period,ip,symbol,dso=match.groups()
    return dict(period=int(period),ip=ip,symbol=symbol.strip(),dso=dso)


def source_checks():
    built=pmu.check_sources();assert set(built['arms'])==set(pmu.ARMS)
    for arm,metadata in built['arms'].items():
        assert metadata['binary']==str(pmu.BINS/f'exec{pmu.ARMS.index(arm):02d}')
        with tarfile.open(HERE/metadata['archive']) as archive:
            regular=[m for m in archive.getmembers() if m.isfile()]
            assert len(regular)==len(archive.getmembers())==len(metadata['source'])
            assert {m.name for m in regular}==set(metadata['source'])
            for member in regular:
                assert common.digest(archive.extractfile(member).read())==metadata['source'][member.name]
        assert metadata['source']['crates/behavior-store/examples/allocation_pmu_probe.rs']==common.digest((HERE/'allocation_pmu_probe.rs').read_bytes())
    reference=load(HERE/'reference-builds.json')['arms']
    for arm in ['original','decode','typed']:
        source=built['arms'][arm]['source']
        assert source['crates/behavior-core/src/record.rs']==reference[arm]['record_sha256']
        assert source['crates/behavior-store/src/store.rs']==reference['original']['store_sha256']
    primary=load(HERE/'view-builds.json')
    for path,sha in primary['source'].items():assert built['arms']['view']['source'][path]==sha,path
    return built


def summarize(rows,folder):
    groups=[]
    for kind in ['stat','record']:
        for n,c,arms in pmu.CASES:
            for mode in (['alloc','empty'] if kind=='stat' else ['alloc']):
                cell=dict(kind=kind,n=n,commands=c,mode=mode,arms={})
                for arm in arms:
                    group=[r for r in rows if (r['kind'],r['n'],r['commands'],r['mode'],r['arm'])==(kind,n,c,mode,arm)]
                    if not group:continue
                    assert [r['repetition'] for r in group]==list(range(7))
                    values=dict(window_ms=statistics.median(r['window_ns']/1e6 for r in group),
                                write_ms=statistics.median(r['write_ns']/1e6 for r in group))
                    if kind=='stat':
                        values['counters']={event:dict(median_count=statistics.median(r['counters'][event]['count'] for r in group),
                            minimum_running_percent=min(r['counters'][event]['running_percent'] for r in group)) for event in ['cycles:u','instructions:u']}
                    else:
                        symbols=collections.defaultdict(lambda:dict(samples=0,period=0));unknown=[];warnings=[];reported=[]
                        for row in group:
                            raw=(folder/f'{row["index"]:05d}.script.txt').read_text()
                            for line in raw.splitlines():
                                if not line.strip():continue
                                parsed=sample(line)
                                if parsed is None:unknown.append(dict(index=row['index'],line=line));continue
                                key=f'{parsed["dso"]}::{parsed["symbol"]}'
                                symbols[key]['samples']+=1;symbols[key]['period']+=parsed['period']
                            report=(folder/f'{row["index"]:05d}.report.txt').read_text()
                            count=re.search(r'^# Samples:\s+(\d+)\s',report,re.M)
                            reported.append(dict(index=row['index'],reported_samples=int(count.group(1)) if count else None))
                            for line in report.splitlines():
                                if re.search(r'lost|throttl',line,re.I):warnings.append(dict(index=row['index'],line=line))
                            dump=(folder/f'{row["index"]:05d}.raw.txt').read_text()
                            warnings += [dict(index=row['index'],line=line) for line in dump.splitlines()
                                         if re.search(r'PERF_RECORD_(LOST|THROTTLE|UNTHROTTLE)',line)]
                        values['sample_symbols']=dict(sorted(symbols.items(),key=lambda p:-p[1]['period']))
                        values['unparsed_sample_lines']=unknown;values['loss_and_throttle_metadata']=warnings
                        values['parsed_sample_count']=sum(v['samples'] for v in symbols.values())
                        values['parsed_total_sample_period']=sum(v['period'] for v in symbols.values())
                        values['report_sample_counts']=reported
                    cell['arms'][arm]=values
                if cell['arms']:groups.append(cell)
    return dict(groups=groups,stat_diagnostic_gaps=pmu.condition([r for r in rows if r['kind']=='stat']),
                sampling_diagnostic_gaps=pmu.condition([r for r in rows if r['kind']=='record']) if any(r['kind']=='record' for r in rows) else None,
                limits='New diagnostic context; no subtraction of empty-window medians. Samples localize executed user IPs, not exclusive wall-time causation.')


def verify():
    built=source_checks();frozen=pmu.check_freeze();folder=HERE/'pmu'
    env=load(folder/'environment.json')
    assert env['freeze_sha256']==common.digest((HERE/'pmu-precollection.json').read_bytes())
    assert (env['controller_cpu'],env['child_cpu'],env['address_space_limit_bytes'],env['timeout_seconds'])==(6,7,8*1024**3,180)
    assert env['selected_environment']==frozen['selected_environment']
    assert datetime.datetime.fromisoformat(env['utc'])>=datetime.datetime.fromisoformat(frozen['utc'])
    rows=lines(folder/'samples.jsonl');attempts=lines(folder/'attempts.jsonl')
    stat=rows[:70];decision=pmu.condition(stat);expected=pmu.matrix('stat')+(pmu.matrix('record') if decision['collect_record'] else [])
    assert len(rows)==len(attempts)==len(expected)
    assert [(r['n'],r['commands'],r['repetition'],r['arm'],r['mode'],r['kind']) for r in rows]==expected
    assert load(folder/'record-condition.json')==decision
    for index,(row,attempt) in enumerate(zip(rows,attempts)):
        assert attempt['status']=='Completed' and attempt['exit_code']==0 and attempt['kind']==row['kind']
        assert datetime.datetime.fromisoformat(attempt['utc'])>=datetime.datetime.fromisoformat(frozen['utc'])
        assert row['index']==index and row['process_ms']==attempt['process_ms'] and math.isfinite(row['process_ms']) and row['process_ms']>=0
        result=json.loads(attempt['stdout'])
        for key,value in result.items():assert row[key]==value,key
        assert result['diagnostics']=='allocation-pmu' and result['ack_bytes']==5
        for key in ['window_ns','write_ns','record_bytes','capacity_before','capacity_after']:
            assert type(result[key]) is int and result[key]>=0
        n,c,arm,mode,kind=row['n'],row['commands'],row['arm'],row['mode'],row['kind']
        prefix=folder/f'raw-{index:05d}';ctl=f'{prefix}.ctl';ack=f'{prefix}.ack';actual=f'{prefix}.json'
        argv=[str(pmu.PERF),kind,'--delay=-1',f'--control=fifo:{ctl},{ack}','-o',str(folder/row['perf_path'])]
        argv+=['--no-big-num','-x',',','-e','cycles:u,instructions:u'] if kind=='stat' else ['-F','997','-e','cycles:u']
        expected_path=pmu.INPUTS/f'n{n}-c{c}.decision.json'
        argv+=['--',str(pmu.TASKSET),'-c','7',str(pmu.BINS/f'exec{pmu.ARMS.index(arm):02d}'),str(n),str(c),mode,ctl,ack,str(expected_path),actual]
        assert attempt['argv']==argv
        assert row['perf_path']==(f'raw-{index:05d}.stat.csv' if kind=='stat' else f'raw-{index:05d}.perf.data')
        assert common.digest((folder/row['perf_path']).read_bytes())==row['perf_sha256']
        assert row['artifact']==f'{index:05d}.decision.json.gz'
        raw=gzip.decompress((folder/row['artifact']).read_bytes());assert raw==expected_path.read_bytes()
        assert len(raw)==row['record_bytes'] and common.digest(raw)==row['record_sha256']
        assert row['capacity_before']==row['capacity_after']>=len(raw)
        if kind=='stat':assert row['counters']==pmu.counters((folder/row['perf_path']).read_text())
        assert not Path(ctl).exists() and not Path(ack).exists() and not Path(actual).exists()
    assert {p.name for p in folder.glob('*.decision.json.gz')}=={r['artifact'] for r in rows}
    aux=lines(folder/'aux-attempts.jsonl') if decision['collect_record'] else []
    records=[r for r in rows if r['kind']=='record'];assert len(aux)==len(records)*4
    for record,triplet in zip(records,[aux[i:i+4] for i in range(0,len(aux),4)]):
        path=folder/record['perf_path']
        commands=[[str(pmu.PERF),'script','--show-lost-events','-i',str(path),'-F','period,ip,sym,dso'],
                  [str(pmu.PERF),'buildid-list','-i',str(path)],
                  [str(pmu.PERF),'script','-D','-i',str(path)],
                  [str(pmu.PERF),'report','--stdio','--no-children','--show-nr-samples','--show-total-period','--percent-limit','0','--sort','dso,symbol','-i',str(path)]]
        for label,attempt,argv in zip(['script','buildids','raw','report'],triplet,commands):
            assert attempt['status']=='Completed' and attempt['exit_code']==0 and attempt['kind']==label
            assert (folder/f'{record["index"]:05d}.{label}.txt').read_text()==attempt['stdout']
            assert attempt['argv']==argv
        dump=(folder/f'{record["index"]:05d}.raw.txt').read_text()
        assert frozen['libc_path'] in dump
        ids=(folder/f'{record["index"]:05d}.buildids.txt').read_text()
        if frozen['libc_path'] in ids:
            context=load(HERE/'pmu-binary-context.json')['libc'];assert context['build_id'] in ids
    assessment=load(folder/'assessment.json')
    assert assessment==dict(status='Complete',measured_attempts=len(rows),stat_attempts=70,record_attempts=len(records),
                            normative_bytes_equal=True,record_condition=decision)
    assert not (folder/'failure.json').exists()
    analysis=summarize(rows,folder)
    (HERE/'pmu-analysis.json').write_text(json.dumps(analysis,indent=2)+'\n')
    return dict(status='Passed',measured_attempts=len(rows),stat_attempts=70,record_attempts=len(records),
                auxiliary_commands=len(aux),complete_outputs=len(rows),source_archives=len(built['arms']),record_condition=decision)


if __name__=='__main__':print(json.dumps(verify(),indent=2))
