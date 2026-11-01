"""Historical driver-prefix anchors; never merge with the expanded native probe."""
import datetime
import json
import math
import os
import sys
from pathlib import Path
from common import check_precollection, digest, precollection_digest, require_equal, retain, run
from final_collect import inventory

ARMS = ['decode', 'typed', 'moved', 'view']
POPULATIONS = [128, 512]
REPETITIONS = 7


def order(index, repetition):
    offset = (index + repetition) % len(ARMS)
    selected = ARMS[offset:] + ARMS[:offset]
    return selected if index % 2 == 0 else list(reversed(selected))


def validate(row):
    for key in ['evaluate_ms', 'commit_ms', 'record_serialization_ms']:
        assert isinstance(row[key], (int, float)) and math.isfinite(row[key]) and row[key] >= 0


def main():
    check_precollection()
    bins, inputs, out = map(Path, sys.argv[1:])
    out.mkdir(exist_ok=False)
    (out / 'environment.json').write_text(json.dumps(dict(
        utc=datetime.datetime.now(datetime.timezone.utc).isoformat(), child_cpu=7,
        precollection_sha256=precollection_digest(),
        address_space_limit_bytes=8 * 1024**3, timeout_seconds=180,
        controller_affinity=sorted(os.sched_getaffinity(0)), declared_attempts=56,
        binaries={a: digest((bins / f'exec{index:02d}').read_bytes()) for index, a in enumerate(ARMS)},
        inputs={str(n): digest((inputs / f'n{n}-c0.decision.json').read_bytes()) for n in POPULATIONS}), indent=2) + '\n')
    rows, artifacts = [], []
    with (out / 'samples.jsonl').open('w') as stream:
        for index, n in enumerate(POPULATIONS):
            expected = (inputs / f'n{n}-c0.decision.json').read_bytes()
            for repetition in range(REPETITIONS):
                for arm in order(index, repetition):
                    scratch = out / f'raw-{len(rows):05d}'
                    row, process_ms = run([str(bins / f'exec{ARMS.index(arm):02d}'), str(n), '1', 'original', str(scratch)], out / 'attempts.jsonl')
                    assert (row['n'], row['variant'], row['repetition'], row['mode']) == (n, 'original', 0, 'uninstrumented')
                    assert all(row[p] is None for p in ['evaluate', 'commit', 'serialization'])
                    validate(row)
                    raw = Path(row['record_path']).read_bytes(); require_equal(expected, raw)
                    assert row['record_bytes'] == len(raw)
                    if repetition == 0: artifacts.append(retain(out / f'{n}-{arm}.json.gz', raw))
                    Path(row.pop('record_path')).unlink(); scratch.rmdir()
                    row.update(arm=arm, repetition=repetition, process_ms=process_ms,
                               record_sha256=digest(raw), evaluate_commit_ms=row['evaluate_ms'] + row['commit_ms'],
                               consumer_ms=row['evaluate_ms'] + row['commit_ms'] + row['record_serialization_ms'])
                    rows.append(row); stream.write(json.dumps(row) + '\n'); stream.flush()
                print(json.dumps(dict(n=n, repetition=repetition)), flush=True)
    inventory(rows, ['n', 'repetition', 'arm'], [(n, r, a) for n in POPULATIONS for r in range(REPETITIONS) for a in ARMS])
    (out / 'assessment.json').write_text(json.dumps(dict(status='Complete', attempts=len(rows), normative_bytes_equal=True,
                                                       artifacts=artifacts), indent=2) + '\n')


if __name__ == '__main__':
    existed = len(sys.argv) == 4 and Path(sys.argv[3]).exists()
    try:
        main()
    except BaseException as error:
        if len(sys.argv) == 4 and not existed and Path(sys.argv[3]).is_dir():
            (Path(sys.argv[3]) / 'failure.json').write_text(json.dumps(dict(
                status='Failed' if isinstance(error, Exception) else 'Interrupted', error=repr(error), declared_attempts=56), indent=2) + '\n')
        raise
