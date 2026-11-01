"""Retain original-arm decision/event oracles and actual wrong-oracle refusals."""
import gzip
import json
import shutil
import subprocess
import sys
from pathlib import Path
from common import digest, require_equal, retain, run
from final_collect import CASES, case_name, validate_native

HERE = Path(__file__).resolve().parent
bins, inputs = map(Path, sys.argv[1:])
inputs.mkdir(exist_ok=False)
out = HERE / 'reference-controls'
out.mkdir(exist_ok=False)
retained = HERE / 'reference-inputs'
retained.mkdir(exist_ok=False)
metadata = []
for n, commands in CASES:
    name = case_name(n, commands)
    row, _ = run([str(bins / 'original-native'), str(n), str(commands), '-', str(out / name)], out / 'attempts.jsonl')
    validate_native(row, n, commands)
    record = Path(row['decision_path']).read_bytes(); event = Path(row['event_path']).read_bytes()
    if commands == 0:
        old = HERE.parent / f'core-residual-profile-20261031/evidence/phase-normal-{n}.json.gz'
        require_equal(gzip.decompress(old.read_bytes()), record)
    for suffix, raw in [('decision', record), ('event', event)]:
        (inputs / f'{name}.{suffix}.json').write_bytes(raw)
        metadata.append(retain(retained / f'{name}.{suffix}.json.gz', raw))
    for key in ['decision_path', 'event_path']: Path(row[key]).unlink()
    (out / name).rmdir()
wrong = out / 'wrong.json'; wrong.write_bytes(b'wrong')
negative = [
    [str(bins / 'original-native'), '128', '0', str(wrong), str(out / 'wrong-native')],
    [str(bins / 'original-serial'), '128', '0', 'display', 'sham', str(wrong), str(out / 'wrong-serial.actual.json')],
]
for command in negative:
    try:
        run(command, out / 'attempts.jsonl')
    except subprocess.CalledProcessError:
        pass
    else:
        raise AssertionError('actual binary accepted wrong expected bytes')
result = dict(status='Complete', original_reference_controls=6, expected_wrong_oracle_failures=2,
              input_hashes={p.name: digest(p.read_bytes()) for p in sorted(inputs.iterdir())}, artifacts=metadata)
(HERE / 'reference-inputs.json').write_text(json.dumps(result, indent=2) + '\n')
print(json.dumps({k: result[k] for k in ['status', 'original_reference_controls', 'expected_wrong_oracle_failures']}))
