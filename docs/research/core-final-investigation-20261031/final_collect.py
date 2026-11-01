"""Frozen final native and full-observation comparison across all six stages."""
import datetime
import gzip
import json
import os
import platform
import sys
from pathlib import Path
from common import check_precollection, digest, precollection_digest, require_equal, retain, run

ARMS = ['original', 'decode', 'typed', 'moved', 'stream', 'view']
CASES = [(128, 0), (512, 0), (2048, 0), (8192, 0), (128, 2), (512, 2)]
REPETITIONS = 7
FULL = [('ordinary', {}),
        ('commands-references', {'history': 2, 'commands': 2, 'relations': True, 'global': 'filtered'}),
        ('history-update', {'history': 8, 'commands': 2, 'operation': 'update'})]


def order(index, repetition):
    offset = (index + repetition) % len(ARMS)
    selected = ARMS[offset:] + ARMS[:offset]
    return selected if index % 2 == 0 else list(reversed(selected))


def case_name(n, commands):
    return f'n{n}-c{commands}'


def program(bins, arm, role):
    # Equal-length executed names avoid varying argv[0] allocation sizes by arm.
    return bins / f'exec{ARMS.index(arm):02d}-{role}'


def inventory(rows, fields, expected):
    actual = [tuple(r[field] for field in fields) for r in rows]
    if len(actual) != len(set(actual)) or set(actual) != set(expected):
        raise ValueError('missing or duplicate declared case')


def validate_native(row, n, commands):
    assert row['n'] == n and row['commands'] == commands and row['diagnostics'] is False
    for name in ['evaluate_ns', 'commit_ns', 'serialization_ns', 'record_bytes', 'event_bytes']:
        assert type(row[name]) is int and row[name] >= 0


def validate_full(row, raw, case):
    assert row['mode'] == 'production-like' and row['execution_outcome'] == 'ALLOW'
    assert row['final_position'] == case['history'] + case['steps']
    data = json.loads(raw)
    for name in ['subject', 'records', 'bundles', 'commits', 'committed_results', 'head', 'versions', 'reads', 'commands', 'replay']:
        assert name in data
    assert data['subject']['case'] == case
    assert set(data['replay']) == {'data', 'behavior', 'references'}
    assert all(report['ok'] for report in data['replay'].values())
    assert len(data['records']) == case['steps'] + 2
    assert len(data['bundles']) == len(data['committed_results']) == case['steps']
    assert len(data['commits']) == case['history'] + case['steps']
    assert len(data['reads']) == 1


def main():
    check_precollection()
    bins, inputs, out = map(Path, sys.argv[1:])
    out.mkdir(exist_ok=False)
    for arm in ARMS:
        for role in ['native', 'full']:
            assert digest(program(bins, arm, role).read_bytes()) == digest((bins / f'{arm}-{role}').read_bytes())
    (out / 'native').mkdir(); (out / 'full').mkdir()
    environment = dict(utc=datetime.datetime.now(datetime.timezone.utc).isoformat(), platform=platform.platform(),
                       precollection_sha256=precollection_digest(),
                       python=sys.version, controller_affinity=sorted(os.sched_getaffinity(0)), child_cpu=7,
                       address_space_limit_bytes=8 * 1024**3, timeout_seconds=180,
                       declared_native=252, declared_full=18,
                       binaries={p.name: digest(p.read_bytes()) for p in sorted(bins.iterdir()) if p.is_file()},
                       inputs={p.name: digest(p.read_bytes()) for p in sorted(inputs.iterdir()) if p.is_file()})
    (out / 'environment.json').write_text(json.dumps(environment, indent=2) + '\n')
    rows, full, artifacts = [], [], []
    with (out / 'samples.jsonl').open('w') as stream:
        for index, (n, commands) in enumerate(CASES):
            name = case_name(n, commands)
            expected_record = (inputs / f'{name}.decision.json').read_bytes()
            expected_event = (inputs / f'{name}.event.json').read_bytes()
            for repetition in range(REPETITIONS):
                for arm in order(index, repetition):
                    scratch = out / f'raw-{len(rows):05d}'
                    row, process_ms = run([str(program(bins, arm, 'native')), str(n), str(commands),
                                           str(inputs / f'{name}.decision.json'), str(scratch)], out / 'attempts.jsonl')
                    validate_native(row, n, commands)
                    record = Path(row['decision_path']).read_bytes(); event = Path(row['event_path']).read_bytes()
                    require_equal(expected_record, record); require_equal(expected_event, event)
                    assert row['record_bytes'] == len(record) and row['event_bytes'] == len(event)
                    data = json.loads(event)
                    assert data['event']['bundle']['record'] == json.loads(record)
                    assert data['head']['last_record'] == data['committed']['record_id']
                    assert data['head']['state_ref'] == data['committed']['result_state']
                    if repetition == 0:
                        for suffix, raw in [('decision', record), ('event', event)]:
                            meta = retain(out / 'native' / f'{name}-{arm}.{suffix}.json.gz', raw)
                            meta['path'] = f"native/{meta['path']}"; artifacts.append(meta)
                    Path(row.pop('decision_path')).unlink(); Path(row.pop('event_path')).unlink(); scratch.rmdir()
                    row.update(arm=arm, repetition=repetition, process_ms=process_ms,
                               record_sha256=digest(record), event_sha256=digest(event),
                               evaluate_commit_ns=row['evaluate_ns'] + row['commit_ns'],
                               consumer_ns=row['evaluate_ns'] + row['commit_ns'] + row['serialization_ns'])
                    rows.append(row); stream.write(json.dumps(row) + '\n'); stream.flush()
                    print(json.dumps({k: row[k] for k in ['n', 'commands', 'arm', 'repetition', 'commit_ns']}), flush=True)
    inventory(rows, ['n', 'commands', 'repetition', 'arm'],
              [(n, c, r, a) for n, c in CASES for r in range(REPETITIONS) for a in ARMS])
    old = Path(__file__).resolve().parent.parent / 'core-bundle-ownership-20261031/evidence'
    with (out / 'full-samples.jsonl').open('w') as stream:
        for index, (label, overrides) in enumerate(FULL):
            case = dict(case_id=label, n=8, history=0, steps=2, batch=1, rules=1, padding=0, filter_terms=1,
                        operation='create', commands=0, relations=False, **{'global': 'count'})
            case.update(overrides)
            expected = gzip.decompress((old / f'{label}-baseline.json.gz').read_bytes())
            for arm in order(index, 0):
                path = out / f'raw-full-{len(full):05d}.json'
                result, process_ms = run([str(program(bins, arm, 'full')), json.dumps(case)], out / 'attempts.jsonl',
                                         dict(os.environ, CORE031_OBSERVATION=str(path)))
                raw = path.read_bytes(); validate_full(result, raw, case); require_equal(expected, raw)
                meta = retain(out / 'full' / f'{label}-{arm}.json.gz', raw)
                meta['path'] = f"full/{meta['path']}"; artifacts.append(meta); path.unlink()
                row = dict(case=case, arm=arm, result=result, process_ms=process_ms, observation_sha256=digest(raw))
                full.append(row); stream.write(json.dumps(row) + '\n'); stream.flush()
    assert len(full) == len({(r['case']['case_id'], r['arm']) for r in full}) == 18
    assert {(r['case']['case_id'], r['arm']) for r in full} == {(label, a) for label, _ in FULL for a in ARMS}
    (out / 'assessment.json').write_text(json.dumps(dict(status='Complete', native=len(rows), full=len(full),
        successful_attempts=270, normative_bytes_equal=True, artifacts=artifacts), indent=2) + '\n')


if __name__ == '__main__':
    existed = len(sys.argv) == 4 and Path(sys.argv[3]).exists()
    try:
        main()
    except BaseException as error:
        if len(sys.argv) == 4 and not existed and Path(sys.argv[3]).is_dir():
            (Path(sys.argv[3]) / 'failure.json').write_text(json.dumps(dict(
                status='Failed' if isinstance(error, Exception) else 'Interrupted', error=repr(error),
                declared_native=252, declared_full=18), indent=2) + '\n')
        raise
