"""Two-arm complete-byte comparison; all attempts retained by common.run."""
import datetime
import gzip
import json
import os
import platform
import sys
from pathlib import Path
from common import digest, require_equal, require_inventory, retain, run

ARMS = ['baseline', 'moved']
POPULATIONS = [128, 512, 2048, 8192]
REPETITIONS = 7
CASES = [
    ('ordinary', {}),
    ('commands-references', {'history': 2, 'commands': 2, 'relations': True, 'global': 'filtered'}),
    ('history-update', {'history': 8, 'commands': 2, 'operation': 'update'}),
]


def wanted():
    return [(n, r, a) for n in POPULATIONS for r in range(REPETITIONS) for a in ARMS]


def validate_phase(row, n):
    assert (row['n'], row['variant'], row['repetition']) == (n, 'original', 0)
    assert row['mode'] == 'uninstrumented'
    assert all(row[p] is None for p in ['evaluate', 'commit', 'serialization'])
    assert all(isinstance(row[k], (int, float)) and row[k] >= 0
               for k in ['evaluate_ms', 'commit_ms', 'record_serialization_ms'])


def validate_full(result, raw, case):
    assert result['mode'] == 'production-like' and result['execution_outcome'] == 'ALLOW'
    assert result['final_position'] == case['history'] + case['steps']
    observation = json.loads(raw)
    for key in ['subject', 'records', 'bundles', 'commits', 'committed_results', 'head', 'versions', 'reads', 'commands', 'replay']:
        assert key in observation, key
    assert observation['subject']['case'] == case
    assert set(observation['replay']) == {'data', 'behavior', 'references'}
    assert all(r['ok'] for r in observation['replay'].values())
    assert len(observation['records']) == case['steps'] + 2
    assert len(observation['bundles']) == len(observation['committed_results']) == case['steps']
    assert len(observation['commits']) == case['history'] + case['steps']
    assert len(observation['reads']) == 1


def main():
    bins, out = map(Path, sys.argv[1:])
    out.mkdir(exist_ok=False)
    expected_names = {f'{a}-{kind}' for a in ARMS for kind in ['profile', 'full-path']}
    assert {p.name for p in bins.iterdir() if p.is_file()} == expected_names
    prior = Path(__file__).resolve().parent.parent / 'core-residual-profile-20261031/evidence'
    expected = {n: gzip.decompress((prior / f'phase-normal-{n}.json.gz').read_bytes()) for n in POPULATIONS}
    metadata = dict(utc=datetime.datetime.now(datetime.timezone.utc).isoformat(), platform=platform.platform(),
                    python=sys.version, controller_affinity=sorted(os.sched_getaffinity(0)), child_cpu=7,
                    address_space_limit_bytes=8 * 1024**3, timeout_seconds=180, repetitions=REPETITIONS,
                    expected_timed_samples=len(wanted()), expected_full_samples=6,
                    binaries={p.name: digest(p.read_bytes()) for p in sorted(bins.iterdir()) if p.is_file()},
                    inputs={str(n): digest(raw) for n, raw in expected.items()})
    (out / 'environment.json').write_text(json.dumps(metadata, indent=2) + '\n')
    rows, artifacts, full_rows = [], [], []
    with (out / 'samples.jsonl').open('w') as stream:
        for population_index, n in enumerate(POPULATIONS):
            for repetition in range(REPETITIONS):
                arms = ARMS if (population_index + repetition) % 2 == 0 else list(reversed(ARMS))
                for arm in arms:
                    scratch = out / f'raw-{arm}-{n}-{repetition}'
                    row, process_ms = run([str(bins / f'{arm}-profile'), str(n), '1', 'original', str(scratch)], out / 'attempts.jsonl')
                    validate_phase(row, n)
                    raw = Path(row['record_path']).read_bytes()
                    require_equal(expected[n], raw)
                    assert row['record_bytes'] == len(raw)
                    if repetition == 0:
                        artifacts.append(retain(out / f'{arm}-{n}.record.json.gz', raw))
                    Path(row.pop('record_path')).unlink()
                    scratch.rmdir()
                    row.update(arm=arm, repetition=repetition, process_ms=process_ms,
                               record_sha256=digest(raw), evaluate_plus_commit_ms=row['evaluate_ms'] + row['commit_ms'],
                               evaluated_serialized_ms=row['evaluate_ms'] + row['commit_ms'] + row['record_serialization_ms'])
                    rows.append(row)
                    stream.write(json.dumps(row) + '\n')
                    stream.flush()
                    print(json.dumps({k: row[k] for k in ['n', 'arm', 'repetition', 'commit_ms']}), flush=True)
    require_inventory(rows, wanted())
    with (out / 'full-samples.jsonl').open('w') as stream:
        for index, (label, overrides) in enumerate(CASES):
            case = dict(case_id=label, n=8, history=0, steps=2, batch=1, rules=1, padding=0,
                        filter_terms=1, operation='create', commands=0, relations=False, **{'global': 'count'})
            case.update(overrides)
            reference = None
            for arm in (ARMS if index % 2 == 0 else list(reversed(ARMS))):
                path = out / f'raw-{label}-{arm}.json'
                result, process_ms = run([str(bins / f'{arm}-full-path'), json.dumps(case)], out / 'attempts.jsonl',
                                         dict(os.environ, CORE031_OBSERVATION=str(path)))
                raw = path.read_bytes()
                validate_full(result, raw, case)
                if reference is None:
                    reference = raw
                else:
                    require_equal(reference, raw)
                artifacts.append(retain(out / f'{label}-{arm}.json.gz', raw))
                path.unlink()
                row = dict(case=case, arm=arm, result=result, process_ms=process_ms, observation_sha256=digest(raw))
                full_rows.append(row)
                stream.write(json.dumps(row) + '\n')
                stream.flush()
    actual_full = [(r['case']['case_id'], r['arm']) for r in full_rows]
    assert len(actual_full) == len(set(actual_full)) == 6
    assert set(actual_full) == {(label, arm) for label, _ in CASES for arm in ARMS}
    result = dict(status='Complete', samples=len(rows), full_samples=len(full_rows), successful_attempts=62,
                  normative_bytes_equal=True, artifacts=artifacts)
    (out / 'assessment.json').write_text(json.dumps(result, indent=2) + '\n')


if __name__ == '__main__':
    existed = len(sys.argv) == 3 and Path(sys.argv[2]).exists()
    try:
        main()
    except BaseException as error:
        if len(sys.argv) == 3 and not existed and Path(sys.argv[2]).is_dir():
            (Path(sys.argv[2]) / 'failure.json').write_text(json.dumps(dict(
                status='Failed' if isinstance(error, Exception) else 'Interrupted', error=repr(error),
                declared_timed_samples=56, declared_full_samples=6), indent=2) + '\n')
        raise
