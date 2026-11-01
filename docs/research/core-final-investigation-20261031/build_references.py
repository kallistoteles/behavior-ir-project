"""Build fresh original/decode/typed/moved probes in one isolated reference checkout."""
import hashlib
import json
import shutil
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
core, bins, target = map(Path, sys.argv[1:])
bins.mkdir(exist_ok=False)
original_record = subprocess.check_output(['git', 'show', 'HEAD:crates/behavior-core/src/record.rs'], cwd=core)
original_store = subprocess.check_output(['git', 'show', 'HEAD:crates/behavior-store/src/store.rs'], cwd=core)
prior = HERE.parent / 'core-typed-record-20261031'
owner = HERE.parent / 'core-bundle-ownership-20261031'
(core / 'crates/behavior-core/src/record').mkdir(exist_ok=True)
for name in ['typed_materialization_tests.rs', 'typed_materialization_reference.rs', 'typed_materialization_corpus.json']:
    shutil.copyfile(prior / name, core / 'crates/behavior-core/src/record' / name)
for name in ['serialization_factor.rs', 'final_native_probe.rs']:
    shutil.copyfile(HERE / name, core / 'crates/behavior-store/examples' / name)

arms = [
    ('original', original_record, original_store),
    ('decode', (prior / 'baseline-record.rs').read_bytes(), original_store),
    ('typed', (prior / 'projected-record.rs').read_bytes(), original_store),
    ('moved', (prior / 'projected-record.rs').read_bytes(), (owner / 'moved-store.rs').read_bytes()),
]
result = {'status': 'Building', 'arms': {}}
try:
    for arm, record, store in arms:
        (core / 'crates/behavior-core/src/record.rs').write_bytes(record)
        (core / 'crates/behavior-store/src/store.rs').write_bytes(store)
        command = ['cargo', 'build', '--locked', '--release', '-p', 'behavior-store',
                   '--example', 'serialization_factor', '--example', 'final_native_probe', '--example', 'execution_evidence_bench']
        subprocess.run([sys.executable, str(HERE / 'run_logged.py'), str(HERE / f'{arm}-build.log'), *command], cwd=core, check=True)
        identity = {'record_sha256': hashlib.sha256(record).hexdigest(), 'store_sha256': hashlib.sha256(store).hexdigest(), 'binaries': {}}
        for source, suffix in [('serialization_factor', 'serial'), ('final_native_probe', 'native'), ('execution_evidence_bench', 'full')]:
            path = bins / f'{arm}-{suffix}'
            shutil.copyfile(target / 'release/examples' / source, path)
            path.chmod(0o755)
            identity['binaries'][path.name] = hashlib.sha256(path.read_bytes()).hexdigest()
        result['arms'][arm] = identity
        (HERE / 'reference-builds.json').write_text(json.dumps(result, indent=2) + '\n')
    result['status'] = 'Complete'
except BaseException as error:
    result.update(status='Failed', error=repr(error))
    raise
finally:
    (HERE / 'reference-builds.json').write_text(json.dumps(result, indent=2) + '\n')
