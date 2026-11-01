"""Build and bind the final candidate to its complete local source snapshot."""
import gzip
import hashlib
import io
import json
import os
import shutil
import subprocess
import sys
import tarfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT, BINS, TARGET = map(Path, sys.argv[1:])


def sha(data):
    return hashlib.sha256(data).hexdigest()


command = ['cargo', 'build', '--locked', '--release', '-v', '-p', 'behavior-store']
examples = [('final_native_probe', 'native'), ('serialization_factor', 'serial'),
            ('execution_evidence_bench', 'full'), ('legacy_anchor_probe', 'legacy')]
for example, _ in examples:
    command.extend(['--example', example])
subprocess.run([sys.executable, str(HERE / 'run_logged.py'), str(HERE / 'view-build.log'),
                *command], cwd=ROOT, check=True)
paths = set(subprocess.check_output(['git', 'ls-files', '-co', '--exclude-standard'],
                                   cwd=ROOT, text=True).splitlines())
paths = sorted(path for path in paths if path.startswith('crates/') or path in
               ['Cargo.toml', 'Cargo.lock', 'rust-toolchain.toml', 'flake.nix', 'flake.lock'])
source = {path: sha((ROOT / path).read_bytes()) for path in paths if (ROOT / path).is_file()}
archive_bytes = io.BytesIO()
with tarfile.open(fileobj=archive_bytes, mode='w') as archive:
    for path in source:
        raw = (ROOT / path).read_bytes()
        info = tarfile.TarInfo(path)
        info.size = len(raw)
        info.mode = 0o644
        archive.addfile(info, io.BytesIO(raw))
(HERE / 'view-source.tar.gz').write_bytes(gzip.compress(archive_bytes.getvalue(), mtime=0))
identities = {}
for example, role in examples:
    destination = BINS / f'view-{role}'
    shutil.copyfile(TARGET / 'release/examples' / example, destination)
    destination.chmod(0o755)
    identities[destination.name] = sha(destination.read_bytes())
    if role != 'legacy':
        assert identities[destination.name] != sha((BINS / f'stream-{role}').read_bytes())
deps = '\n'.join(path.read_text() for path in (TARGET / 'release/examples').glob('*.d'))
assert 'canonical/view.rs' in deps and 'documents/views.rs' in deps
result = dict(status='Complete', checkout=str(ROOT), target=str(TARGET), source=source,
              binaries=identities, source_archive_sha256=sha((HERE / 'view-source.tar.gz').read_bytes()),
              command=command, features='default; no validation-work diagnostics',
              rustc=subprocess.check_output(['rustc', '-Vv'], text=True),
              cargo=subprocess.check_output(['cargo', '-V'], text=True),
              selected_environment={key: os.environ.get(key) for key in
                                    ['CARGO_TARGET_DIR', 'CARGO_BUILD_JOBS', 'CARGO_INCREMENTAL',
                                     'RUSTFLAGS', 'CARGO_ENCODED_RUSTFLAGS']},
              dep_info_contains_canonical_view=True, dep_info_contains_document_views=True)
(HERE / 'view-builds.json').write_text(json.dumps(result, indent=2) + '\n')
print(json.dumps(dict(status=result['status'], source_files=len(source), binaries=identities), indent=2))
