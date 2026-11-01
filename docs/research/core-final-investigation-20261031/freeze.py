"""Create the final review patch, equal-length aliases and precollection freeze."""
import datetime
import json
import subprocess
from pathlib import Path
from common import digest

HERE = Path(__file__).resolve().parent
ROOT = Path('/tmp/behavior-ir-core-final-20261031')
BINS = Path('/tmp/core-final-binaries-20261031')
ANCHORS = Path('/tmp/core-final-anchor-binaries-20261031')
INPUTS = Path('/tmp/core-final-inputs-20261031')
assert 'gates: OK' in (HERE / 'workspace-gates.log').read_text()
assert '\nOK\n' in (HERE / 'collector-controls.log').read_text()
assert not (HERE / 'measurement-precollection.json').exists()
arms = ['original', 'decode', 'typed', 'moved', 'stream', 'view']
for index, arm in enumerate(arms):
    for role in ['native', 'serial', 'full']:
        alias = BINS / f'exec{index:02d}-{role}'
        if alias.is_symlink():
            assert alias.resolve() == BINS / f'{arm}-{role}'
        else:
            alias.symlink_to(BINS / f'{arm}-{role}')
ANCHORS.mkdir(exist_ok=True)
old = Path('/tmp/core-typed-record-binaries-20261031')
sources = [old / 'baseline-profile', old / 'projected-profile',
           Path('/tmp/core-bundle-ownership-binaries-20261031/moved-profile'), BINS / 'view-legacy']
for index, source in enumerate(sources):
    assert source.is_file(), source
    alias = ANCHORS / f'exec{index:02d}'
    if alias.is_symlink():
        assert alias.resolve() == source
    else:
        alias.symlink_to(source)
tracked = subprocess.check_output(['git', 'diff', '--binary', '--', 'crates/'], cwd=ROOT)
untracked = subprocess.check_output(['git', 'ls-files', '--others', '--exclude-standard', 'crates/'], cwd=ROOT, text=True).splitlines()
patch = bytearray(tracked)
for path in sorted(untracked):
    if '/examples/' in path:
        continue
    result = subprocess.run(['git', 'diff', '--no-index', '--binary', '--', '/dev/null', path],
                            cwd=ROOT, stdout=subprocess.PIPE, check=False)
    assert result.returncode == 1, path
    patch.extend(result.stdout)
(HERE / 'solution.patch').write_bytes(patch)
patch_check = Path('/tmp/behavior-ir-core-patch-check-20261101')
subprocess.run(['git', 'apply', '--check', str(HERE / 'solution.patch')], cwd=patch_check, check=True)
paths = [p for p in HERE.rglob('*') if p.is_file() and '__pycache__' not in p.parts
         and p.name not in ['progress.json', 'measurement-precollection.json']]
frozen = dict(utc=datetime.datetime.now(datetime.timezone.utc).isoformat(), status='Frozen before primary measurements',
              base=subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip(),
              project_notes_checkout=str(HERE.parents[2]), final_checkout=str(ROOT), patch_check_checkout=str(patch_check),
              native_attempts=270, sink_attempts=224, anchor_attempts=56,
              order='Cyclic rotation each repetition; direction fixed by case/index parity, independent of repetition. Seven reps visit every position; unequal remainder is retained.',
              inputs={str(p.relative_to(HERE)): digest(p.read_bytes()) for p in sorted(paths)},
              binaries={str(p): digest(p.read_bytes()) for folder in [BINS, ANCHORS]
                        for p in sorted(folder.iterdir()) if p.is_file()},
              records={str(p): digest(p.read_bytes()) for p in sorted(INPUTS.iterdir()) if p.is_file()},
              anchor_targets={str(p): str(p.resolve()) for p in sorted(ANCHORS.iterdir())})
(HERE / 'measurement-precollection.json').write_text(json.dumps(frozen, indent=2) + '\n')
print(json.dumps(dict(status=frozen['status'], frozen_inputs=len(frozen['inputs']),
                      binaries=len(frozen['binaries']), records=len(frozen['records'])), indent=2))
