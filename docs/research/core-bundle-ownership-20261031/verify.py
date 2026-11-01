"""Verify preserved identities, full matrices, every retained output and summaries."""
import gzip
import json
from pathlib import Path
from analyze import analyze
from collect import ARMS, CASES, POPULATIONS, validate_full, validate_phase, wanted
from common import digest, require_inventory

HERE = Path(__file__).resolve().parent


def load(name):
    return json.loads((HERE / name).read_text())


def lines(name):
    return [json.loads(line) for line in (HERE / name).read_text().splitlines()]


def verify():
    frozen = load('precollection.json')
    for name, expected in frozen['inputs'].items():
        assert digest((HERE / name).read_bytes()) == expected, name
    builds = load('builds.json')
    for name, expected in builds['binaries'].items():
        assert digest((Path(builds['binary_directory']) / name).read_bytes()) == expected, name
    core = Path(builds['checkout'])
    for name, expected in builds['candidate_source'].items():
        assert digest((core / name).read_bytes()) == expected, name
    for name, expected in builds['locks'].items():
        assert digest((core / name).read_bytes()) == expected, name
    prior_manifests = {}
    for name in ['core-continuation-20261029', 'core-typed-record-20261031', 'core-residual-profile-20261031']:
        folder = HERE.parent / name
        prior = json.loads((folder / 'artifact-sha256.json').read_text())
        for file, expected in prior.items():
            assert digest((folder / file).read_bytes()) == expected, (name, file)
        prior_manifests[name] = digest((folder / 'artifact-sha256.json').read_bytes())
    prior = HERE.parent / 'core-residual-profile-20261031/evidence'
    expected = {n: gzip.decompress((prior / f'phase-normal-{n}.json.gz').read_bytes()) for n in POPULATIONS}
    environment = load('evidence/environment.json')
    assert environment['binaries'] == builds['binaries']
    assert environment['inputs'] == {str(n): digest(raw) for n, raw in expected.items()}
    samples = lines('evidence/samples.jsonl')
    full = lines('evidence/full-samples.jsonl')
    attempts = lines('evidence/attempts.jsonl')
    assert not (HERE / 'evidence/failure.json').exists()
    require_inventory(samples, wanted())
    expected_order = [(n, repetition, arm) for index, n in enumerate(POPULATIONS)
                      for repetition in range(7)
                      for arm in (ARMS if (index + repetition) % 2 == 0 else list(reversed(ARMS)))]
    assert [(r['n'], r['repetition'], r['arm']) for r in samples] == expected_order
    assert len(attempts) == len(samples) + len(full) == 62
    assert {(r['case']['case_id'], r['arm']) for r in full} == {(label, arm) for label, _ in CASES for arm in ARMS}
    assert len(full) == 6
    assert [(r['case']['case_id'], r['arm']) for r in full] == [
        (label, arm) for index, (label, _) in enumerate(CASES)
        for arm in (ARMS if index % 2 == 0 else list(reversed(ARMS)))]
    for row, attempt in zip(samples, attempts[:56]):
        assert attempt['status'] == 'Completed' and attempt['exit_code'] == 0
        raw = json.loads(attempt['stdout'])
        validate_phase(raw, row['n'])
        assert Path(attempt['argv'][0]).name == f"{row['arm']}-profile"
        assert attempt['argv'][1:4] == [str(row['n']), '1', 'original']
        assert row['record_sha256'] == digest(expected[row['n']]) and row['record_bytes'] == len(expected[row['n']])
        for key in ['evaluate_ms', 'commit_ms', 'record_serialization_ms', 'record_bytes']:
            assert row[key] == raw[key]
        assert row['evaluate_plus_commit_ms'] == row['evaluate_ms'] + row['commit_ms']
        assert row['evaluated_serialized_ms'] == row['evaluate_ms'] + row['commit_ms'] + row['record_serialization_ms']
    for row, attempt in zip(full, attempts[56:]):
        assert attempt['status'] == 'Completed' and attempt['exit_code'] == 0
        assert json.loads(attempt['stdout']) == row['result']
        assert Path(attempt['argv'][0]).name == f"{row['arm']}-full-path"
        assert json.loads(attempt['argv'][1]) == row['case']
        assert Path(attempt['observation_path_env']).name == f"raw-{row['case']['case_id']}-{row['arm']}.json"
        raw = gzip.decompress((HERE / 'evidence' / f"{row['case']['case_id']}-{row['arm']}.json.gz").read_bytes())
        validate_full(row['result'], raw, row['case'])
        assert digest(raw) == row['observation_sha256']
    assessment = load('evidence/assessment.json')
    assert assessment['status'] == 'Complete' and assessment['normative_bytes_equal']
    expected_names = {f'{arm}-{n}.record.json.gz' for arm in ARMS for n in POPULATIONS}
    expected_names |= {f'{label}-{arm}.json.gz' for label, _ in CASES for arm in ARMS}
    assert len(assessment['artifacts']) == 14
    assert {a['path'] for a in assessment['artifacts']} == expected_names
    for artifact in assessment['artifacts']:
        path = HERE / 'evidence' / artifact['path']
        raw = gzip.decompress(path.read_bytes())
        assert len(raw) == artifact['bytes'] and digest(raw) == artifact['sha256']
        assert path.stat().st_size == artifact['gzip_bytes']
        if '.record.' in artifact['path']:
            n = int(artifact['path'].split('-')[1].split('.')[0])
            assert raw == expected[n]
    for label, _ in CASES:
        assert gzip.decompress((HERE / 'evidence' / f'{label}-baseline.json.gz').read_bytes()) == gzip.decompress((HERE / 'evidence' / f'{label}-moved.json.gz').read_bytes())
    assert not list((HERE / 'evidence').glob('raw-*'))
    assert analyze() == load('analysis.json')
    return dict(status='Passed', frozen_inputs=len(frozen['inputs']), live_binaries=4,
                timed_samples=56, full_samples=6, successful_attempts=62,
                exact_artifact_inventory=14, byte_equal=True, analysis_recomputed=True,
                previous_manifests_unchanged=prior_manifests)


if __name__ == '__main__':
    print(json.dumps(verify(), indent=2))
