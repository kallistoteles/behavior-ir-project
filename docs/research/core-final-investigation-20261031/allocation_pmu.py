"""Allocation-only user-PMU experiment; receipts retain all child and auxiliary output."""
import datetime
import gzip
import json
import math
import os
import re
import resource
import signal
import statistics
import subprocess
import sys
import time
from pathlib import Path
import common

HERE=Path(__file__).resolve().parent
PERF=Path('/nix/store/12ns24zpsfih98b0q7k44n5ys86l789i-perf-linux-7.2.7/bin/perf')
TASKSET=Path('/run/current-system/sw/bin/taskset')
BINS=Path('/tmp/core-final-pmu-binaries-20261101')
INPUTS=Path('/tmp/core-final-inputs-20261031')
ARMS=['original','decode','typed','view']
CASES=[(512,0,['decode','typed','view']),(128,2,['original','view'])]


def selected_environment():
    names={'LD_PRELOAD','LD_LIBRARY_PATH','LD_AUDIT','GLIBC_TUNABLES'}
    names.update(name for name in os.environ if name.startswith('MALLOC_') or name.startswith('PERF_'))
    values={name:os.environ.get(name) for name in sorted(names)}
    values['PERF_CONFIG']='/dev/null'
    return values


def controller_limits():
    os.sched_setaffinity(0,{6})
    resource.setrlimit(resource.RLIMIT_AS,(8*1024**3,8*1024**3))


def execute(argv,receipts,kind):
    start=time.perf_counter(); process=None
    row=dict(argv=argv,kind=kind,utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),status='Started',stdout='',stderr='')
    try:
        process=subprocess.Popen(argv,text=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE,
                                 env=dict(os.environ,LC_ALL='C',PERF_CONFIG='/dev/null'),start_new_session=True,preexec_fn=controller_limits)
        try: stdout,stderr=process.communicate(timeout=180)
        except BaseException as error:
            try: os.killpg(process.pid,signal.SIGKILL)
            except ProcessLookupError: pass
            stdout,stderr=process.communicate()
            row.update(stdout=stdout,stderr=stderr,exit_code=process.returncode,
                       status='Timeout' if isinstance(error,subprocess.TimeoutExpired) else 'Interrupted')
            raise
        row.update(stdout=stdout,stderr=stderr,exit_code=process.returncode,process_ms=(time.perf_counter()-start)*1000)
        if process.returncode: raise subprocess.CalledProcessError(process.returncode,argv,stdout,stderr)
        row['status']='Completed'
        return row
    except BaseException as error:
        if row['status']=='Started': row['status']='Failed' if isinstance(error,Exception) else 'Interrupted'
        row['error']=repr(error)
        raise
    finally:
        if 'process_ms' not in row: row['process_ms']=(time.perf_counter()-start)*1000
        with receipts.open('a') as stream: stream.write(json.dumps(row)+'\n')


def counters(raw):
    result={}
    for line in raw.splitlines():
        if not line.strip() or line.startswith('#'): continue
        fields=line.split(',')
        if len(fields)<5 or fields[2] not in ['cycles:u','instructions:u']: continue
        count=float(fields[0]); runtime=float(fields[3]); percent=float(fields[4])
        assert fields[2] not in result and all(math.isfinite(v) for v in [count,runtime,percent])
        assert count>0 and runtime>0 and 99<=percent<=100
        result[fields[2]]=dict(count=count,runtime=runtime,running_percent=percent,raw_fields=fields)
    assert set(result)=={'cycles:u','instructions:u'}
    return result


def one(folder,index,n,c,arm,mode,kind):
    prefix=folder/f'raw-{index:05d}'
    ctl=Path(f'{prefix}.ctl');ack=Path(f'{prefix}.ack');actual=Path(f'{prefix}.json')
    os.mkfifo(ctl);os.mkfifo(ack)
    perf_file=Path(f'{prefix}.stat.csv' if kind=='stat' else f'{prefix}.perf.data')
    argv=[str(PERF),kind,'--delay=-1',f'--control=fifo:{ctl},{ack}','-o',str(perf_file)]
    if kind=='stat': argv+=['--no-big-num','-x',',','-e','cycles:u,instructions:u']
    else: argv+=['-F','997','-e','cycles:u']
    expected_path=INPUTS/f'n{n}-c{c}.decision.json'
    argv+=['--',str(TASKSET),'-c','7',str(BINS/f'exec{ARMS.index(arm):02d}'),str(n),str(c),mode,str(ctl),str(ack),str(expected_path),str(actual)]
    receipt=execute(argv,folder/'attempts.jsonl',kind)
    result=json.loads(receipt['stdout'])
    assert (result['n'],result['commands'],result['mode'],result['diagnostics'],result['ack_bytes'])==(n,c,mode,'allocation-pmu',5)
    for key in ['window_ns','write_ns','record_bytes','capacity_before','capacity_after']:
        assert type(result[key]) is int and result[key]>=0
    expected=expected_path.read_bytes();raw=actual.read_bytes();common.require_equal(expected,raw)
    assert result['record_bytes']==len(raw) and result['capacity_before']==result['capacity_after']>=len(raw)
    artifact=folder/f'{index:05d}.decision.json.gz';common.retain(artifact,raw)
    actual.unlink();ctl.unlink();ack.unlink()
    if kind=='stat': result['counters']=counters(perf_file.read_text())
    result.update(arm=arm,kind=kind,index=index,process_ms=receipt['process_ms'],record_sha256=common.digest(raw),
                  perf_path=perf_file.name,perf_sha256=common.digest(perf_file.read_bytes()),artifact=artifact.name)
    return result


def matrix(kind):
    rows=[]
    for i,(n,c,arms) in enumerate(CASES):
        for r in range(7):
            modes=['alloc','empty'] if kind=='stat' else ['alloc']
            if r%2: modes=list(reversed(modes))
            for mode in modes:
                offset=(i+r)%len(arms);selected=arms[offset:]+arms[:offset]
                if i%2: selected=list(reversed(selected))
                rows += [(n,c,r,a,mode,kind) for a in selected]
    return rows


def check_sources():
    common.check_precollection()
    built=json.loads((HERE/'pmu-builds.json').read_text());assert built['status']=='Complete'
    for arm,metadata in built['arms'].items():
        assert common.digest(Path(metadata['binary']).read_bytes())==metadata['sha256']
        assert common.digest((HERE/metadata['archive']).read_bytes())==metadata['archive_sha256']
    return built


def calibrate():
    check_sources();folder=HERE/'pmu-calibration';folder.mkdir(exist_ok=False)
    rows=[one(folder,i,128,0,'view',mode,'stat') for i,mode in enumerate(['empty','alloc'])]
    rows.append(one(folder,2,512,0,'decode','alloc','record'))
    auxiliary(folder,rows)
    (folder/'assessment.json').write_text(json.dumps(dict(status='Passed',rows=rows),indent=2)+'\n')
    print(json.dumps(rows,indent=2))


def freeze():
    check_sources();assert not (HERE/'pmu-precollection.json').exists()
    assert json.loads((HERE/'pmu-calibration/assessment.json').read_text())['status']=='Passed'
    names=['allocation_pmu.py','allocation_pmu_probe.rs','allocation_pmu_verify.py','capture_pmu_context.py',
           'pmu-binary-context.json','pmu-collector-review.md','allocation-pmu-method.md','allocation-pmu-design.md',
           'build_pmu.py','pmu-builds.json','pmu-clippy.log','pmu-controls.log','pmu_controls.py','factors-verification.json']
    names += [str(p.relative_to(HERE)) for p in (HERE/'pmu-calibration').iterdir() if p.is_file()]
    names += [p.name for p in HERE.glob('pmu-*-source.tar.gz')]
    names += [p.name for p in HERE.glob('pmu-*-build.log')]
    names += [p.name for p in HERE.glob('pmu-*-main.asm')]
    lib=Path('/nix/store/lm3pknxi0ipypy3lxh1wmm8wvvavdwrn-glibc-2.42-84/lib/libc.so.6')
    frozen=dict(utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),primary_freeze_sha256=common.precollection_digest(),
                factor_freeze_sha256=common.digest((HERE/'factor-precollection.json').read_bytes()),
                inputs={n:common.digest((HERE/n).read_bytes()) for n in sorted(set(names))},
                perf_path=str(PERF),perf_sha256=common.digest(PERF.read_bytes()),
                taskset_path=str(TASKSET),taskset_sha256=common.digest(TASKSET.read_bytes()),
                libc_path=str(lib),libc_sha256=common.digest(lib.read_bytes()),
                selected_environment=selected_environment(),
                stat_matrix=matrix('stat'),conditional_record_matrix=matrix('record'))
    (HERE/'pmu-precollection.json').write_text(json.dumps(frozen,indent=2)+'\n')
    print('Frozen70stat windows and conditional35IP-sampling windows.')


def check_freeze():
    check_sources();frozen=json.loads((HERE/'pmu-precollection.json').read_text())
    assert frozen['primary_freeze_sha256']==common.precollection_digest()
    assert frozen['factor_freeze_sha256']==common.digest((HERE/'factor-precollection.json').read_bytes())
    assert frozen['selected_environment']==selected_environment()
    for name,sha in frozen['inputs'].items(): assert common.digest((HERE/name).read_bytes())==sha,name
    for key in ['perf','libc','taskset']:
        assert common.digest(Path(frozen[f'{key}_path']).read_bytes())==frozen[f'{key}_sha256']
    assert frozen['stat_matrix']==[list(r) for r in matrix('stat')]
    assert frozen['conditional_record_matrix']==[list(r) for r in matrix('record')]
    return frozen


def condition(rows):
    med=lambda n,c,a:statistics.median(r['window_ns'] for r in rows if (r['n'],r['commands'],r['arm'],r['mode'])==(n,c,a,'alloc'))
    legacy=med(512,0,'decode')>2*med(512,0,'view') and med(512,0,'decode')>500000
    v2=med(128,2,'view')>2*med(128,2,'original') and med(128,2,'view')>100000
    return dict(legacy_gap_reproduced=legacy,v2_gap_reproduced=v2,collect_record=legacy and v2)


def collect():
    frozen=check_freeze();folder=HERE/'pmu';folder.mkdir(exist_ok=False)
    (folder/'environment.json').write_text(json.dumps(dict(utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
        freeze_sha256=common.digest((HERE/'pmu-precollection.json').read_bytes()),controller_cpu=6,child_cpu=7,
        address_space_limit_bytes=8*1024**3,timeout_seconds=180,selected_environment=selected_environment(),
        perf_version=subprocess.check_output([str(PERF),'--version'],text=True)),indent=2)+'\n')
    rows=[]
    with (folder/'samples.jsonl').open('w') as stream:
        for n,c,r,arm,mode,kind in matrix('stat'):
            row=one(folder,len(rows),n,c,arm,mode,kind);row['repetition']=r;rows.append(row)
            stream.write(json.dumps(row)+'\n');stream.flush()
        decision=condition(rows);(folder/'record-condition.json').write_text(json.dumps(decision,indent=2)+'\n')
        print(json.dumps(decision),flush=True)
        if decision['collect_record']:
            for n,c,r,arm,mode,kind in matrix('record'):
                row=one(folder,len(rows),n,c,arm,mode,kind);row['repetition']=r;rows.append(row)
                stream.write(json.dumps(row)+'\n');stream.flush()
    # Symbol-IP reports are auxiliary commands after all measured children stop.
    auxiliary(folder,rows)
    check_freeze()
    (folder/'assessment.json').write_text(json.dumps(dict(status='Complete',measured_attempts=len(rows),stat_attempts=70,
        record_attempts=len(rows)-70,normative_bytes_equal=True,record_condition=decision),indent=2)+'\n')


def auxiliary(folder,rows):
    for row in rows:
        if row['kind']!='record':continue
        path=folder/row['perf_path']
        for label,argv in [('script',[str(PERF),'script','--show-lost-events','-i',str(path),'-F','period,ip,sym,dso']),
                           ('buildids',[str(PERF),'buildid-list','-i',str(path)]),
                           ('raw',[str(PERF),'script','-D','-i',str(path)]),
                           ('report',[str(PERF),'report','--stdio','--no-children','--show-nr-samples','--show-total-period','--percent-limit','0','--sort','dso,symbol','-i',str(path)])]:
            receipt=execute(argv,folder/'aux-attempts.jsonl',label)
            (folder/f'{row["index"]:05d}.{label}.txt').write_text(receipt['stdout'])


if __name__=='__main__':
    mode=sys.argv[1]
    if mode=='calibrate':calibrate()
    elif mode=='freeze':freeze()
    elif mode=='collect':
        out=HERE/'pmu';existed=out.exists()
        try:collect()
        except BaseException as error:
            if not existed and out.is_dir():
                (out/'failure.json').write_text(json.dumps(dict(status='Failed' if isinstance(error,Exception) else 'Interrupted',error=repr(error)))+'\n')
            raise
    else:raise ValueError(mode)
