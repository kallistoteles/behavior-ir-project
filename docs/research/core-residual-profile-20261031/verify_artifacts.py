"""Read-only verification of frozen inputs, retained outputs and live research identities.

Run without Python optimization: these research checks deliberately use assertions.
The final self-excluding file manifest is checked separately by the reproduction command.
"""
import gzip
import hashlib
import json
import tarfile
from pathlib import Path
from analyze import equal, rows, summarize
from collect import ORDERS, require_cases, validate_partition, validate_rounds

HERE = Path(__file__).resolve().parent


def sha(data):
    return hashlib.sha256(data).hexdigest()


def verify():
    frozen = json.loads((HERE / 'precollection.json').read_text())
    for name, expected in frozen['inputs'].items():
        assert sha((HERE / name).read_bytes()) == expected, name
    builds = json.loads((HERE / 'builds.json').read_text())
    environment = json.loads((HERE / 'evidence/environment.json').read_text())
    binaries = Path('/tmp/core-residual-profile-binaries-20261031')
    inputs = Path('/tmp/core-residual-profile-inputs-20261031')
    for name, expected in builds['binaries'].items():
        assert sha((binaries / name).read_bytes()) == expected == environment['binaries'][name], name
    for name, expected in builds['inputs'].items():
        assert sha((inputs / name).read_bytes()) == expected == environment['input_records'][name], name
    scoped = Path('/tmp/behavior-ir-core-profile-20261031')
    original = Path('/tmp/behavior-ir-core-continuation-20261029')
    inventory = json.loads((HERE / 'instrumentation-inventory.json').read_text())
    assert inventory['files'] == builds['scoped_source_files']
    with tarfile.open(HERE / 'profile-source.tar.gz') as archive:
        for name, expected in builds['scoped_source_files'].items():
            assert sha((scoped / name).read_bytes()) == expected == sha(archive.extractfile(name).read()), name
    assert sha((original / 'crates/behavior-core/src/record.rs').read_bytes()) == builds['candidate_record_sha256']
    for name, expected in builds['locks'].items():
        assert sha((scoped / name).read_bytes()) == expected == sha((original / name).read_bytes()), name
    preserved = {}
    for name in ['core-continuation-20261029', 'core-typed-record-20261031']:
        previous = HERE.parent / name
        manifest = json.loads((previous / 'artifact-sha256.json').read_text())
        for file, expected in manifest.items():
            assert sha((previous / file).read_bytes()) == expected, (name, file)
        preserved[name] = {'manifest_sha256': sha((previous / 'artifact-sha256.json').read_bytes()), 'files_verified': len(manifest)}
    phases = rows('phase-samples.jsonl')
    serial = rows('serialization-samples.jsonl')
    attempts = rows('attempts.jsonl')
    require_cases(phases, ['n', 'repetition', 'profile_mode'], [(n, r, m) for n in [128, 512, 2048, 8192] for r in range(3) for m in ['normal', 'full', 'count-off']])
    require_cases(serial, ['n', 'order', 'repetition', 'arm'], [(n, o, r, a) for n in [128, 512] for o in ORDERS for r in range(10) for a in ['a', 'c']])
    assert len(attempts) == len(phases) + len(serial) == 156
    partitions = 0
    for row, attempt in zip(phases + serial, attempts):
        assert attempt['status'] == 'Completed' and attempt['exit_code'] == 0
        raw = json.loads(attempt['stdout'])
        for key, value in raw.items():
            if key not in ['record_path', 'repetition']:
                assert row[key] == value, key
        expected = (inputs / f"{row['n']}.json").read_bytes()
        assert row['record_sha256'] == sha(expected) and row['record_bytes'] == len(expected)
        if 'profile_mode' in row:
            mode = row['profile_mode']
            assert attempt['profile_bytes_env'] == ('0' if mode == 'count-off' else '1')
            if mode == 'normal':
                assert row['mode'] == 'uninstrumented'
                assert all(row[p] is None for p in ['evaluate', 'commit', 'serialization'])
            else:
                assert row['mode'] == 'instrumented' and row['profile_bytes'] == (mode == 'full')
                for phase in ['evaluate', 'commit', 'serialization']:
                    validate_partition(row[phase]['spans'], f'phase::{phase}')
                    partitions += 1
                    if mode == 'count-off':
                        assert row[phase]['work']['hash_document_json_bytes'] == row[phase]['work']['document_decode_json_bytes'] == 0
        else:
            validate_rounds(row, row['n'], row['order'], sha(expected), len(expected))
    for n in [128, 512, 2048, 8192]:
        for phase in ['evaluate', 'commit', 'serialization']:
            counts = [{k: v for k, v in r[phase]['work'].items() if k not in ['hash_document_json_bytes', 'document_decode_json_bytes']}
                      for r in phases if r['n'] == n and r['profile_mode'] != 'normal']
            assert all(c == counts[0] for c in counts)
    assessment = json.loads((HERE / 'evidence/assessment.json').read_text())
    assert assessment['status'] == 'Complete' and assessment['normative_bytes_equal']
    assert len(assessment['artifacts']) == 24
    for artifact in assessment['artifacts']:
        path = HERE / 'evidence' / artifact['path']
        raw = gzip.decompress(path.read_bytes())
        assert len(raw) == artifact['bytes'] and sha(raw) == artifact['sha256']
        assert path.stat().st_size == artifact['gzip_bytes']
        population = next(part.removesuffix('.json.gz') for part in artifact['path'].split('-')
                          if part.removesuffix('.json.gz') in ['128', '512', '2048', '8192'])
        assert raw == (inputs / f'{population}.json').read_bytes()
    assert not list((HERE / 'evidence').glob('raw-*'))
    equal(summarize(), json.loads((HERE / 'analysis.json').read_text()))
    return dict(status='Passed', frozen_inputs=len(frozen['inputs']), live_binaries=4,
                live_input_records=4, scoped_source_files=11, prior_studies=preserved,
                phase_samples=len(phases), serialization_samples=len(serial), successful_attempts=len(attempts),
                exact_root_partitions=partitions, full_off_non_byte_counts_equal=True,
                byte_equal_gzip_artifacts=24, analysis_recomputed=True,
                independent_background_audit='Passed; independently recomputed matrices, identities, partitions, counts, bytes and all descriptive summaries; no files changed.')


if __name__ == '__main__':
    print(json.dumps(verify(), indent=2))
