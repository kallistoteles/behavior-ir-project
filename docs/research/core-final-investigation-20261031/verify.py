"""Verify exact source/binary freezes, ordered attempts, outputs and descriptive results."""
import gzip
import json
import math
import datetime
import sys
import tarfile
from pathlib import Path
import analyze
import final_collect as native
import serial_collect as serial
import anchor_collect as anchor
from common import digest

HERE = Path(__file__).resolve().parent


def load(path):
    return json.loads(path.read_text())


def lines(path):
    return [json.loads(line) for line in path.read_text().splitlines()]


def close(a, b):
    if isinstance(a, dict):
        assert a.keys() == b.keys()
        for key in a: close(a[key], b[key])
    elif isinstance(a, list):
        assert len(a) == len(b)
        for x, y in zip(a, b): close(x, y)
    elif isinstance(a, float): assert abs(a - b) <= max(1e-9, abs(a) * 1e-12), (a, b)
    else: assert a == b, (a, b)


def verify_sources():
    frozen = load(HERE / 'measurement-precollection.json')
    for name, expected in frozen['inputs'].items(): assert digest((HERE / name).read_bytes()) == expected, name
    for path, expected in frozen['binaries'].items(): assert digest(Path(path).read_bytes()) == expected, path
    for path, expected in frozen['records'].items(): assert digest(Path(path).read_bytes()) == expected, path
    final = load(HERE / 'view-builds.json')
    root = Path(final['checkout'])
    for path, expected in final['source'].items(): assert digest((root / path).read_bytes()) == expected, path
    stream = load(HERE / 'stream-builds.json')
    with tarfile.open(HERE / 'stream-source.tar.gz') as archive:
        for path, expected in stream['source'].items(): assert digest(archive.extractfile(path).read()) == expected, path
    bins = Path('/tmp/core-final-binaries-20261031')
    reference = load(HERE / 'reference-builds.json')
    for manifest in [stream, final, *reference['arms'].values()]:
        for name, expected in manifest['binaries'].items():
            assert digest((bins / name).read_bytes()) == expected, name
    with tarfile.open(HERE / 'view-source.tar.gz') as archive:
        for path, expected in final['source'].items():
            assert digest(archive.extractfile(path).read()) == expected, path
    anchors = Path('/tmp/core-final-anchor-binaries-20261031')
    typed_builds = load(HERE.parent / 'core-typed-record-20261031/builds.json')
    moved_builds = load(HERE.parent / 'core-bundle-ownership-20261031/builds.json')
    anchor_hashes = [typed_builds['baseline_binaries']['baseline-profile'],
                     typed_builds['projected_binaries']['projected-profile'],
                     moved_builds['binaries']['moved-profile'], final['binaries']['view-legacy']]
    for index, expected in enumerate(anchor_hashes):
        assert digest((anchors / f'exec{index:02d}').read_bytes()) == expected
    old = {}
    for name in ['core-continuation-20261029', 'core-typed-record-20261031', 'core-residual-profile-20261031', 'core-bundle-ownership-20261031']:
        folder = HERE.parent / name
        manifest = load(folder / 'artifact-sha256.json')
        for path, expected in manifest.items(): assert digest((folder / path).read_bytes()) == expected, (name, path)
        old[name] = digest((folder / 'artifact-sha256.json').read_bytes())
    return dict(frozen_inputs=len(frozen['inputs']), frozen_binaries=len(frozen['binaries']), old_manifests=old)


def check_attempt(attempt):
    assert attempt['status'] == 'Completed' and attempt['exit_code'] == 0
    assert math.isfinite(attempt['process_ms']) and attempt['process_ms'] >= 0
    frozen = load(HERE / 'measurement-precollection.json')
    assert datetime.datetime.fromisoformat(attempt['utc']) >= datetime.datetime.fromisoformat(frozen['utc'])
    return json.loads(attempt['stdout'])


def check_environment(folder, bins, inputs, role):
    env = load(folder / 'environment.json')
    frozen = load(HERE / 'measurement-precollection.json')
    assert env['precollection_sha256'] == digest((HERE / 'measurement-precollection.json').read_bytes())
    assert env['child_cpu'] == 7 and env['address_space_limit_bytes'] == 8 * 1024**3 and env['timeout_seconds'] == 180
    assert datetime.datetime.fromisoformat(env['utc']) >= datetime.datetime.fromisoformat(frozen['utc'])
    if role == 'native':
        expected_bins = {p.name: frozen['binaries'][str(p)] for p in bins.iterdir() if p.is_file()}
        expected_records = {p.name: frozen['records'][str(p)] for p in inputs.iterdir() if p.is_file()}
        assert (env['declared_native'], env['declared_full']) == (252, 18)
    elif role == 'sinks':
        expected_bins = {f'{a}-serial': frozen['binaries'][str(bins / f'{a}-serial')] for a in serial.ARMS}
        expected_records = {str(n): frozen['records'][str(inputs / f'n{n}-c0.decision.json')] for n in serial.POPULATIONS}
        assert env['declared_attempts'] == 224
    else:
        expected_bins = {a: frozen['binaries'][str(bins / f'exec{i:02d}')] for i, a in enumerate(anchor.ARMS)}
        expected_records = {str(n): frozen['records'][str(inputs / f'n{n}-c0.decision.json')] for n in anchor.POPULATIONS}
        assert env['declared_attempts'] == 56
    assert env['binaries'] == expected_bins and env['inputs'] == expected_records


def check_reference_oracles(bins, inputs):
    metadata = load(HERE / 'reference-inputs.json')
    assert metadata['status'] == 'Complete'
    names = {f'{native.case_name(n,c)}.{suffix}.json' for n,c in native.CASES for suffix in ['decision','event']}
    assert set(metadata['input_hashes']) == names
    assert {a['path'] for a in metadata['artifacts']} == {f'{name}.gz' for name in names}
    for artifact in metadata['artifacts']:
        path = HERE / 'reference-inputs' / artifact['path']
        raw = gzip.decompress(path.read_bytes()); name = artifact['path'][:-3]
        assert path.stat().st_size == artifact['gzip_bytes'] and len(raw) == artifact['bytes']
        assert digest(raw) == artifact['sha256'] == metadata['input_hashes'][name]
        assert raw == (inputs / name).read_bytes()
    attempts = lines(HERE / 'reference-controls/attempts.jsonl')
    assert len(attempts) == 8
    for (n,c), attempt in zip(native.CASES, attempts[:6]):
        assert attempt['status'] == 'Completed' and attempt['exit_code'] == 0
        assert attempt['argv'] == [str(bins / 'original-native'), str(n), str(c), '-', str(HERE / 'reference-controls' / native.case_name(n,c))]
        result = json.loads(attempt['stdout']); native.validate_native(result,n,c)
        record = (inputs / f'{native.case_name(n,c)}.decision.json').read_bytes()
        event = (inputs / f'{native.case_name(n,c)}.event.json').read_bytes()
        assert result['record_bytes'] == len(record) and result['event_bytes'] == len(event)
        if c == 0:
            assert record == gzip.decompress((HERE.parent / f'core-residual-profile-20261031/evidence/phase-normal-{n}.json.gz').read_bytes())
    for attempt, program, reason in zip(attempts[6:], ['original-native','original-serial'],
                                      ['decision differs from frozen expected bytes', 'serialization bytes differ from frozen expected record']):
        assert attempt['argv'][0] == str(bins / program)
        assert attempt['status'] == 'Failed' and attempt['exit_code'] == 101 and reason in attempt['stderr']
    assert (HERE / 'reference-controls/wrong.json').read_bytes() == b'wrong'
    expected = (inputs / 'n128-c0.decision.json').read_bytes()
    assert (HERE / 'reference-controls/wrong-native/decision.json').read_bytes() == expected
    assert (HERE / 'reference-controls/wrong-serial.actual.json').read_bytes() == expected
    return dict(original_reference_controls=6, expected_wrong_oracle_failures=2, frozen_oracles=12)


def check_artifacts(folder, assessment, expected_names):
    artifacts = assessment['artifacts']
    assert len(artifacts) == len(expected_names)
    assert {a['path'] for a in artifacts} == expected_names
    for artifact in artifacts:
        path = folder / artifact['path']; raw = gzip.decompress(path.read_bytes())
        assert path.stat().st_size == artifact['gzip_bytes']
        assert len(raw) == artifact['bytes'] and digest(raw) == artifact['sha256']
    assert not list(folder.glob('raw-*'))


def native_data(folder, bins, inputs):
    check_environment(folder, bins, inputs, 'native')
    rows = lines(folder / 'samples.jsonl'); full = lines(folder / 'full-samples.jsonl'); attempts = lines(folder / 'attempts.jsonl')
    expected_order = [(n, c, r, a) for i, (n, c) in enumerate(native.CASES) for r in range(7) for a in native.order(i, r)]
    assert [(r['n'], r['commands'], r['repetition'], r['arm']) for r in rows] == expected_order
    assert len(attempts) == len(rows) + len(full) == 270
    for index, (row, attempt) in enumerate(zip(rows, attempts[:252])):
        assert row['process_ms'] == attempt['process_ms']
        raw = check_attempt(attempt); n = row['n']; c = row['commands']; name = native.case_name(n, c)
        native.validate_native(raw, n, c)
        assert Path(attempt['argv'][0]) == native.program(bins, row['arm'], 'native')
        assert attempt['argv'][1:3] == [str(n), str(c)]
        assert Path(attempt['argv'][3]) == inputs / f'{name}.decision.json'
        assert Path(attempt['argv'][4]).name == f'raw-{index:05d}'
        for key in ['evaluate_ns', 'commit_ns', 'serialization_ns', 'record_bytes', 'event_bytes']: assert row[key] == raw[key]
        assert row['evaluate_commit_ns'] == row['evaluate_ns'] + row['commit_ns']
        assert row['consumer_ns'] == row['evaluate_ns'] + row['commit_ns'] + row['serialization_ns']
        for suffix, field in [('decision', 'record_sha256'), ('event', 'event_sha256')]:
            expected = (inputs / f'{name}.{suffix}.json').read_bytes()
            assert row[field] == digest(expected)
            if row['repetition'] == 0:
                assert gzip.decompress((folder / 'native' / f'{name}-{row["arm"]}.{suffix}.json.gz').read_bytes()) == expected
    assert [(r['case']['case_id'], r['arm']) for r in full] == [(label, arm) for index, (label, _) in enumerate(native.FULL) for arm in native.order(index, 0)]
    for index, (row, attempt) in enumerate(zip(full, attempts[252:])):
        assert row['process_ms'] == attempt['process_ms']
        assert check_attempt(attempt) == row['result']
        assert Path(attempt['argv'][0]) == native.program(bins, row['arm'], 'full')
        assert json.loads(attempt['argv'][1]) == row['case']
        assert Path(attempt['observation_path_env']).name == f'raw-full-{index:05d}.json'
        name = row['case']['case_id']; raw = gzip.decompress((folder / 'full' / f'{name}-{row["arm"]}.json.gz').read_bytes())
        native.validate_full(row['result'], raw, row['case'])
        assert digest(raw) == row['observation_sha256']
        old = HERE.parent / 'core-bundle-ownership-20261031/evidence' / f'{name}-baseline.json.gz'
        assert raw == gzip.decompress(old.read_bytes())
    assessment = load(folder / 'assessment.json')
    assert assessment['status'] == 'Complete' and assessment['normative_bytes_equal']
    names = {f'native/{native.case_name(n,c)}-{a}.{suffix}.json.gz' for n, c in native.CASES for a in native.ARMS for suffix in ['decision', 'event']}
    names |= {f'full/{label}-{a}.json.gz' for label, _ in native.FULL for a in native.ARMS}
    check_artifacts(folder, assessment, names)
    close(analyze.native(folder), load(HERE / f'{folder.name}-analysis.json'))
    return dict(native=252, full=18, artifacts=90)


def sink_data(folder, bins, inputs):
    check_environment(folder, bins, inputs, 'sinks')
    rows = lines(folder / 'samples.jsonl'); attempts = lines(folder / 'attempts.jsonl')
    expected_order = [(n, s, r, a) for ni, n in enumerate(serial.POPULATIONS) for r in range(7)
                      for s in serial.sink_order(ni, r) for a in serial.order(ni + serial.SINKS.index(s), r)]
    assert [(r['n'], r['sink'], r['repetition'], r['arm']) for r in rows] == expected_order
    assert len(rows) == len(attempts) == 224
    for index, (row, attempt) in enumerate(zip(rows, attempts)):
        assert row['process_ms'] == attempt['process_ms']
        raw = check_attempt(attempt); expected_path = inputs / f'n{row["n"]}-c0.decision.json'; expected = expected_path.read_bytes()
        serial.validate(raw, row['n'], row['sink'], 'sham', len(expected))
        assert Path(attempt['argv'][0]) == native.program(bins, row['arm'], 'serial')
        assert attempt['argv'][1:6] == [str(row['n']), '0', row['sink'], 'sham', str(expected_path)]
        assert Path(attempt['argv'][6]).name == f'raw-{index:05d}.json'
        for key, value in raw.items(): assert row[key] == value, key
        assert row['record_sha256'] == digest(expected)
        if row['repetition'] == 0:
            assert gzip.decompress((folder / f'{row["n"]}-{row["sink"]}-{row["arm"]}.json.gz').read_bytes()) == expected
    assessment = load(folder / 'assessment.json')
    assert assessment['status'] == 'Complete' and assessment['normative_bytes_equal']
    check_artifacts(folder, assessment, {f'{n}-{s}-{a}.json.gz' for n in serial.POPULATIONS for s in serial.SINKS for a in serial.ARMS})
    close(analyze.sink(folder), load(HERE / f'{folder.name}-analysis.json'))
    return dict(attempts=224, rounds=1792, artifacts=32)


def anchor_data(folder, bins, inputs):
    check_environment(folder, bins, inputs, 'anchors')
    rows = lines(folder / 'samples.jsonl'); attempts = lines(folder / 'attempts.jsonl')
    assert [(r['n'], r['repetition'], r['arm']) for r in rows] == [(n, r, a) for i, n in enumerate(anchor.POPULATIONS) for r in range(7) for a in anchor.order(i, r)]
    assert len(rows) == len(attempts) == 56
    for index, (row, attempt) in enumerate(zip(rows, attempts)):
        assert row['process_ms'] == attempt['process_ms']
        raw = check_attempt(attempt)
        anchor.validate(raw)
        assert Path(attempt['argv'][0]) == bins / f'exec{anchor.ARMS.index(row["arm"]):02d}'
        assert attempt['argv'][1:4] == [str(row['n']), '1', 'original']
        assert Path(attempt['argv'][4]).name == f'raw-{index:05d}'
        assert raw['mode'] == 'uninstrumented' and (raw['n'], raw['variant'], raw['repetition']) == (row['n'], 'original', 0)
        assert all(raw[p] is None for p in ['evaluate', 'commit', 'serialization'])
        for key in ['evaluate_ms', 'commit_ms', 'record_serialization_ms', 'record_bytes']: assert row[key] == raw[key]
        assert row['consumer_ms'] == row['evaluate_ms'] + row['commit_ms'] + row['record_serialization_ms']
        assert row['evaluate_commit_ms'] == row['evaluate_ms'] + row['commit_ms']
        expected = (inputs / f'n{row["n"]}-c0.decision.json').read_bytes(); assert row['record_sha256'] == digest(expected)
        if row['repetition'] == 0: assert gzip.decompress((folder / f'{row["n"]}-{row["arm"]}.json.gz').read_bytes()) == expected
    assessment = load(folder / 'assessment.json'); assert assessment['status'] == 'Complete' and assessment['normative_bytes_equal']
    check_artifacts(folder, assessment, {f'{n}-{a}.json.gz' for n in anchor.POPULATIONS for a in anchor.ARMS})
    close(analyze.anchor(folder), load(HERE / f'{folder.name}-analysis.json'))
    return dict(attempts=56, artifacts=8)


def verify():
    result = verify_sources()
    bins = Path('/tmp/core-final-binaries-20261031'); inputs = Path('/tmp/core-final-inputs-20261031')
    result['references'] = check_reference_oracles(bins, inputs)
    for name, function, binary_root in [('native', native_data, bins), ('sinks', sink_data, bins),
                                        ('anchors', anchor_data, Path('/tmp/core-final-anchor-binaries-20261031'))]:
        folder = HERE / name
        assert not (folder / 'failure.json').exists()
        result[name] = function(folder, binary_root, inputs)
    result.update(status='Passed', successful_attempts=550)
    return result


if __name__ == '__main__': print(json.dumps(verify(), indent=2))
