"""Separately frozen matched Display-capacity and read-only-touch experiment."""
import datetime
import gzip
import json
import math
import statistics
import sys
from pathlib import Path
import analyze
import common
import final_collect as native
import serial_collect as serial

HERE = Path(__file__).resolve().parent
BINS = Path('/tmp/core-final-binaries-20261031')
INPUTS = Path('/tmp/core-final-inputs-20261031')
OUT = HERE / 'factors'
CASES = [(128, 0, ['decode', 'typed', 'view']), (512, 0, ['decode', 'typed', 'view']),
         (128, 2, ['original', 'view']), (512, 2, ['original', 'view'])]
SINKS = ['display', 'display128', 'display-full', 'writer-full']
TOUCHES = ['sham', 'touch']


def rotate(values, index, repetition):
    offset = (index + repetition) % len(values)
    selected = values[offset:] + values[:offset]
    return selected if index % 2 == 0 else list(reversed(selected))


def matrix():
    return [(n, c, r, s, t, a) for i, (n, c, arms) in enumerate(CASES) for r in range(7)
            for s in rotate(SINKS, i, r) for t in rotate(TOUCHES, i + SINKS.index(s), r)
            for a in rotate(arms, i + SINKS.index(s) + TOUCHES.index(t), r)]


def validate(row, n, commands, sink, touch, length):
    # The frozen first-stage validator owns the common round/capacity schema.
    # Check the actual command count before adapting that validator's c0 input.
    assert row['commands'] == commands
    serial.validate({**row, 'commands': 0}, n, sink, touch, length)
    assert type(row['parse_ns']) is int and row['parse_ns'] >= 0
    if touch == 'touch':
        assert type(row['touch_checksum']) is int and row['touch_checksum'] != 0


def check_freeze():
    common.check_precollection()
    frozen = json.loads((HERE / 'factor-precollection.json').read_text())
    assert frozen['primary_freeze_sha256'] == common.precollection_digest()
    assert frozen['matrix'] == [list(row) for row in matrix()]
    for name, expected in frozen['inputs'].items():
        assert common.digest((HERE / name).read_bytes()) == expected, name
    return frozen


def freeze():
    assert not (HERE / 'factor-precollection.json').exists() and not OUT.exists()
    common.check_precollection()
    files = ['factor_followup.py', 'factor_controls.py', 'factor-method.md', 'factor-review.md', 'factor-controls.log', 'primary-verification.json',
             'native-analysis.json', 'sinks-analysis.json', 'anchors-analysis.json']
    frozen = dict(utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
                  primary_freeze_sha256=common.precollection_digest(),
                  inputs={name: common.digest((HERE / name).read_bytes()) for name in files},
                  matrix=matrix(), attempts=len(matrix()), artifacts=80,
                  sources_and_binaries='Unchanged frozen primary executables; no additional build or runtime edit')
    (HERE / 'factor-precollection.json').write_text(json.dumps(frozen, indent=2) + '\n')
    print(f'Frozen {len(matrix())} follow-up processes before collection.')


def collect():
    check_freeze(); OUT.mkdir(exist_ok=False)
    (OUT / 'environment.json').write_text(json.dumps(dict(
        utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
        factor_precollection_sha256=common.digest((HERE / 'factor-precollection.json').read_bytes()),
        primary_precollection_sha256=common.precollection_digest(), child_cpu=7,
        address_space_limit_bytes=8 * 1024**3, timeout_seconds=180, declared_attempts=560,
        binaries={a: common.digest(native.program(BINS, a, 'serial').read_bytes())
                  for a in ['original', 'decode', 'typed', 'view']},
        inputs={f'n{n}-c{c}': common.digest((INPUTS / f'n{n}-c{c}.decision.json').read_bytes()) for n,c,_ in CASES}
    ), indent=2) + '\n')
    artifacts = []; rows = []
    with (OUT / 'samples.jsonl').open('w') as stream:
        for index, (n, c, repetition, sink, touch, arm) in enumerate(matrix()):
            expected_path = INPUTS / f'n{n}-c{c}.decision.json'; expected = expected_path.read_bytes()
            raw_path = OUT / f'raw-{index:05d}.json'
            result, process_ms = common.run([str(native.program(BINS, arm, 'serial')), str(n), str(c), sink, touch,
                                             str(expected_path), str(raw_path)], OUT / 'attempts.jsonl')
            validate(result, n, c, sink, touch, len(expected))
            raw = raw_path.read_bytes(); common.require_equal(expected, raw)
            if repetition == 0:
                artifacts.append(common.retain(OUT / f'n{n}-c{c}-{sink}-{touch}-{arm}.json.gz', raw))
            raw_path.unlink()
            row = dict(**result, arm=arm, repetition=repetition, process_ms=process_ms,
                       record_sha256=common.digest(raw))
            rows.append(row); stream.write(json.dumps(row) + '\n'); stream.flush()
            if index % 20 == 19: print(json.dumps(dict(completed=index+1, declared=560)), flush=True)
    assert len(rows) == 560 and len(artifacts) == 80
    (OUT / 'assessment.json').write_text(json.dumps(dict(status='Complete', attempts=560,
        normative_bytes_equal=True, artifacts=artifacts), indent=2) + '\n')


def analysis():
    processes = []
    for row in analyze.rows(OUT):
        item = {k: row[k] for k in ['n', 'commands', 'sink', 'intervention', 'arm', 'repetition', 'process_ms']}
        item.update(evaluate_commit_ms=(row['evaluate_ns'] + row['commit_ns']) / 1e6,
                    touch_ms=row['touch_ns'] / 1e6,
                    o1_plus_touch_ms=(row['touch_ns'] + row['rounds'][0]['total_ns']) / 1e6,
                    first_consumer_ms=(row['evaluate_ns'] + row['commit_ns'] + row['touch_ns'] + row['rounds'][0]['total_ns']) / 1e6)
        for obj, prefix in [('original', 'o'), ('parsed', 'p')]:
            rounds = [r for r in row['rounds'] if r['object'] == obj]
            for phase in ['setup', 'write', 'total']:
                item[f'{prefix}1_{phase}_ms'] = rounds[0][f'{phase}_ns'] / 1e6
                item[f'{prefix}_repeat_{phase}_ms'] = statistics.median(r[f'{phase}_ns'] / 1e6 for r in rounds[1:])
        processes.append(item)
    summaries = []; sink_pairs = []; touch_pairs = []
    for n, c, arms in CASES:
        selected = [r for r in processes if (r['n'], r['commands']) == (n,c)]
        comparisons = [('view', arms[0])]
        if 'typed' in arms: comparisons += [('typed', 'decode'), ('view', 'typed')]
        summaries += analyze.grouped(selected, ['n','commands','sink','intervention'], arms, comparisons)
        for arm in arms:
            for touch in TOUCHES:
                for candidate, reference in [('display-full','display128'), ('display-full','display'), ('writer-full','display-full')]:
                    group = [{**r, 'arm':r['sink']} for r in selected if r['arm']==arm and r['intervention']==touch and r['sink'] in [candidate,reference]]
                    comparison = analyze.grouped(group, ['n','commands','intervention'], [reference,candidate], [(candidate,reference)])[0]['comparisons'][f'{candidate}_vs_{reference}']
                    sink_pairs.append(dict(n=n,commands=c,arm=arm,intervention=touch,candidate=candidate,reference=reference,**comparison))
            for sink in SINKS:
                group = [{**r,'arm':r['intervention']} for r in selected if r['arm']==arm and r['sink']==sink]
                comparison = analyze.grouped(group,['n','commands','sink'],TOUCHES,[('touch','sham')])[0]['comparisons']['touch_vs_sham']
                touch_pairs.append(dict(n=n,commands=c,arm=arm,sink=sink,**comparison))
    return dict(summary=summaries,sink_contrasts=sink_pairs,touch_contrasts=touch_pairs,process_summaries=processes)


def verify():
    import verify as primary
    frozen = check_freeze()
    env = json.loads((OUT / 'environment.json').read_text())
    assert env['factor_precollection_sha256'] == common.digest((HERE / 'factor-precollection.json').read_bytes())
    assert datetime.datetime.fromisoformat(env['utc']) >= datetime.datetime.fromisoformat(frozen['utc'])
    assert env['primary_precollection_sha256'] == common.precollection_digest()
    assert (env['child_cpu'],env['address_space_limit_bytes'],env['timeout_seconds'],env['declared_attempts']) == (7,8*1024**3,180,560)
    assert env['binaries'] == {a:common.digest(native.program(BINS,a,'serial').read_bytes()) for a in ['original','decode','typed','view']}
    assert env['inputs'] == {f'n{n}-c{c}':common.digest((INPUTS/f'n{n}-c{c}.decision.json').read_bytes()) for n,c,_ in CASES}
    rows=analyze.rows(OUT); attempts=primary.lines(OUT/'attempts.jsonl')
    assert [(r['n'],r['commands'],r['repetition'],r['sink'],r['intervention'],r['arm']) for r in rows] == matrix()
    assert len(rows)==len(attempts)==560
    for index,(row,attempt) in enumerate(zip(rows,attempts)):
        result=primary.check_attempt(attempt)
        assert datetime.datetime.fromisoformat(attempt['utc']) >= datetime.datetime.fromisoformat(frozen['utc'])
        n,c=row['n'],row['commands']; expected_path=INPUTS/f'n{n}-c{c}.decision.json'; expected=expected_path.read_bytes()
        assert attempt['argv']==[str(native.program(BINS,row['arm'],'serial')),str(n),str(c),row['sink'],row['intervention'],str(expected_path),str(OUT/f'raw-{index:05d}.json')]
        validate(result,n,c,row['sink'],row['intervention'],len(expected))
        for key,value in result.items(): assert row[key]==value,key
        assert row['process_ms']==attempt['process_ms'] and math.isfinite(row['process_ms'])
        assert row['record_sha256']==common.digest(expected)
        if row['repetition']==0:
            assert gzip.decompress((OUT/f'n{n}-c{c}-{row["sink"]}-{row["intervention"]}-{row["arm"]}.json.gz').read_bytes())==expected
    assessment=json.loads((OUT/'assessment.json').read_text())
    assert assessment['status']=='Complete' and assessment['attempts']==560 and assessment['normative_bytes_equal'] and not (OUT/'failure.json').exists()
    names={f'n{n}-c{c}-{s}-{t}-{a}.json.gz' for n,c,arms in CASES for s in SINKS for t in TOUCHES for a in arms}
    primary.check_artifacts(OUT,assessment,names)
    primary.close(analysis(),json.loads((HERE/'factors-analysis.json').read_text()))
    return dict(status='Passed',attempts=560,rounds=4480,artifacts=80)


if __name__ == '__main__':
    mode=sys.argv[1]
    if mode=='freeze': freeze()
    elif mode=='collect':
        existed=OUT.exists()
        try: collect()
        except BaseException as error:
            if not existed and OUT.is_dir():
                (OUT/'failure.json').write_text(json.dumps(dict(status='Failed' if isinstance(error,Exception) else 'Interrupted',error=repr(error)))+'\n')
            raise
    elif mode=='analyze': (HERE/'factors-analysis.json').write_text(json.dumps(analysis(),indent=2)+'\n')
    elif mode=='verify': print(json.dumps(verify(),indent=2))
    else: raise ValueError(mode)
