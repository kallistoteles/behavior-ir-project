"""First sink-factor stage; conditional contrasts use a separately frozen manifest."""
import datetime
import json
import os
import platform
import sys
from pathlib import Path
from common import check_precollection, digest, precollection_digest, require_equal, retain, run
from final_collect import inventory, program

ARMS = ['decode', 'typed', 'moved', 'view']
SINKS = ['display', 'vec', 'writer128', 'writer-full']
POPULATIONS = [128, 512]
REPETITIONS = 7


def order(index, repetition):
    offset = (index + repetition) % len(ARMS)
    selected = ARMS[offset:] + ARMS[:offset]
    return selected if index % 2 == 0 else list(reversed(selected))


def sink_order(index, repetition):
    offset = (index + repetition) % len(SINKS)
    selected = SINKS[offset:] + SINKS[:offset]
    return selected if index % 2 == 0 else list(reversed(selected))


def validate(row, n, sink, intervention, length):
    assert (row['n'], row['commands'], row['sink'], row['intervention'], row['diagnostics']) == (n, 0, sink, intervention, False)
    assert row['record_bytes'] == length and type(row['touch_ns']) is int and row['touch_ns'] >= 0
    if intervention == 'sham': assert row['touch_checksum'] == 0
    for key in ['evaluate_ns', 'commit_ns']:
        assert type(row[key]) is int and row[key] >= 0
    assert [(r['object'], r['ordinal']) for r in row['rounds']] == [(o, r) for o in ['original', 'parsed'] for r in range(1, 5)]
    for r in row['rounds']:
        assert r['bytes'] == length
        for key in ['setup_ns', 'write_ns', 'total_ns', 'capacity_before', 'capacity_after']:
            assert type(r[key]) is int and r[key] >= 0
        assert r['setup_ns'] + r['write_ns'] == r['total_ns']
        assert r['capacity_after'] >= length
        if sink.endswith('full'): assert r['capacity_before'] >= length and r['capacity_after'] == r['capacity_before']
        if sink in ['display', 'vec']: assert r['setup_ns'] == 0


def main():
    check_precollection()
    bins, inputs, out = map(Path, sys.argv[1:])
    out.mkdir(exist_ok=False)
    for arm in ARMS:
        assert digest(program(bins, arm, 'serial').read_bytes()) == digest((bins / f'{arm}-serial').read_bytes())
    (out / 'environment.json').write_text(json.dumps(dict(
        utc=datetime.datetime.now(datetime.timezone.utc).isoformat(), platform=platform.platform(),
        precollection_sha256=precollection_digest(),
        python=sys.version, controller_affinity=sorted(os.sched_getaffinity(0)), child_cpu=7,
        address_space_limit_bytes=8 * 1024**3, timeout_seconds=180, declared_attempts=224,
        binaries={f'{a}-serial': digest((bins / f'{a}-serial').read_bytes()) for a in ARMS},
        inputs={str(n): digest((inputs / f'n{n}-c0.decision.json').read_bytes()) for n in POPULATIONS}), indent=2) + '\n')
    rows, artifacts = [], []
    with (out / 'samples.jsonl').open('w') as stream:
        for ni, n in enumerate(POPULATIONS):
            expected_path = inputs / f'n{n}-c0.decision.json'; expected = expected_path.read_bytes()
            for repetition in range(REPETITIONS):
                for sink in sink_order(ni, repetition):
                    si = SINKS.index(sink)
                    for arm in order(ni + si, repetition):
                        path = out / f'raw-{len(rows):05d}.json'
                        row, process_ms = run([str(program(bins, arm, 'serial')), str(n), '0', sink, 'sham', str(expected_path), str(path)], out / 'attempts.jsonl')
                        validate(row, n, sink, 'sham', len(expected))
                        raw = path.read_bytes(); require_equal(expected, raw)
                        if repetition == 0: artifacts.append(retain(out / f'{n}-{sink}-{arm}.json.gz', raw))
                        path.unlink(); row.update(arm=arm, repetition=repetition, process_ms=process_ms, record_sha256=digest(raw))
                        rows.append(row); stream.write(json.dumps(row) + '\n'); stream.flush()
                    print(json.dumps(dict(n=n, sink=sink, repetition=repetition)), flush=True)
    inventory(rows, ['n', 'sink', 'repetition', 'arm'], [(n, s, r, a) for n in POPULATIONS for s in SINKS for r in range(REPETITIONS) for a in ARMS])
    (out / 'assessment.json').write_text(json.dumps(dict(status='Complete', attempts=len(rows),
        normative_bytes_equal=True, artifacts=artifacts), indent=2) + '\n')


if __name__ == '__main__':
    existed = len(sys.argv) == 4 and Path(sys.argv[3]).exists()
    try:
        main()
    except BaseException as error:
        if len(sys.argv) == 4 and not existed and Path(sys.argv[3]).is_dir():
            (Path(sys.argv[3]) / 'failure.json').write_text(json.dumps(dict(
                status='Failed' if isinstance(error, Exception) else 'Interrupted', error=repr(error), declared_attempts=224), indent=2) + '\n')
        raise
