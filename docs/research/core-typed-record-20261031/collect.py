"""Three-arm exact-output experiment using unchanged Core031 research drivers."""
import datetime
import gzip
import hashlib
import json
import os
import platform
import resource
import statistics
import subprocess
import sys
import time
from pathlib import Path

ARMS = ["baseline", "borrowed", "projected"]


def digest(data):
    return hashlib.sha256(data).hexdigest()


def require_equal(expected, actual):
    if expected != actual:
        raise ValueError("complete output bytes differ")


def require_inventory(rows, wanted):
    actual = [(r["n"], r["repetition"], r["arm"]) for r in rows]
    if len(actual) != len(set(actual)) or set(actual) != set(wanted):
        raise ValueError("missing or duplicate measurement")


def controls():
    # Exercise oracle failures before using either oracle for acceptance.
    require_equal(b"same", b"same")
    try:
        require_equal(b"first", b"other")
    except ValueError:
        pass
    else:
        raise AssertionError("changed output escaped comparison")
    row = {"n": 1, "repetition": 0, "arm": "baseline"}
    require_inventory([row], [(1, 0, "baseline")])
    for rows in [[], [row, row]]:
        try:
            require_inventory(rows, [(1, 0, "baseline")])
        except ValueError:
            pass
        else:
            raise AssertionError("incomplete/duplicate corpus escaped comparison")


def limits():
    os.sched_setaffinity(0, {7})
    resource.setrlimit(resource.RLIMIT_AS, (8 * 1024**3, 8 * 1024**3))


def run(command, attempts, env=None):
    start = time.perf_counter()
    attempt = {"argv": command, "utc": datetime.datetime.now(datetime.timezone.utc).isoformat()}
    try:
        result = subprocess.run(command, text=True, capture_output=True,
                                env=env, preexec_fn=limits, timeout=180)
        attempt.update(exit_code=result.returncode, stdout=result.stdout, stderr=result.stderr)
        result.check_returncode()
        parsed = json.loads(result.stdout)
        attempt["status"] = "Completed"
        return parsed, (time.perf_counter() - start) * 1000
    except subprocess.TimeoutExpired as error:
        def text(value):
            return value.decode(errors="replace") if isinstance(value, bytes) else value
        attempt.update(status="Timeout", stdout=text(error.stdout), stderr=text(error.stderr))
        raise
    except Exception as error:
        attempt.update(status="Failed", error=repr(error))
        raise
    finally:
        attempt["process_ms"] = (time.perf_counter() - start) * 1000
        with attempts.open("a") as stream:
            stream.write(json.dumps(attempt) + "\n")


def retain(path, data):
    path.write_bytes(gzip.compress(data, mtime=0))
    return {"path": path.name, "sha256": digest(data), "bytes": len(data),
            "gzip_bytes": path.stat().st_size}


def main():
    controls()
    binaries, output = map(Path, sys.argv[1:])
    output.mkdir(exist_ok=False)
    metadata = {"utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
                "platform": platform.platform(), "python": sys.version,
                "controller_affinity": sorted(os.sched_getaffinity(0)),
                "child_cpu": 7, "address_space_limit_bytes": 8 * 1024**3,
                "timeout_seconds": 180, "repetitions": 5, "arms": ARMS,
                "expected_timed_samples": 60,
                "cpu": next(line.strip() for line in Path("/proc/cpuinfo").read_text().splitlines() if line.startswith("model name")),
                "binaries": {p.name: digest(p.read_bytes()) for p in sorted(binaries.iterdir()) if p.is_file()}}
    (output / "environment.json").write_text(json.dumps(metadata, indent=2) + "\n")
    rows, representatives, artifacts = [], {}, []
    wanted = [(n, r, a) for n in [128, 512, 2048, 8192]
              for r in range(5) for a in ARMS]
    with (output / "samples.jsonl").open("w") as stream:
        for n in [128, 512, 2048, 8192]:
            for repetition in range(5):
                offset = repetition % len(ARMS)
                arms = ARMS[offset:] + ARMS[:offset]
                if repetition >= 3:
                    arms.reverse()
                for arm in arms:
                    scratch = output / f"raw-{arm}-{n}-{repetition}"
                    row, process_ms = run([str(binaries / f"{arm}-profile"), str(n), "1", "original", str(scratch)], output / "attempts.jsonl")
                    assert row["mode"] == "uninstrumented"
                    assert (row["n"], row["variant"], row["repetition"]) == (n, "original", 0)
                    assert all(row[k] is None for k in ["evaluate", "commit", "serialization"])
                    raw = Path(row["record_path"]).read_bytes()
                    assert row["record_bytes"] == len(raw)
                    if n in representatives:
                        require_equal(representatives[n], raw)
                    else:
                        representatives[n] = raw
                    if repetition == 0:
                        artifacts.append(retain(output / f"{arm}-{n}.record.json.gz", raw))
                    Path(row["record_path"]).unlink()
                    scratch.rmdir()
                    row.update(arm=arm, repetition=repetition, process_ms=process_ms,
                               record_sha256=digest(raw), evaluate_plus_commit_ms=row["evaluate_ms"] + row["commit_ms"])
                    row.pop("record_path")
                    rows.append(row)
                    stream.write(json.dumps(row) + "\n")
                    stream.flush()
                    print(json.dumps({k: row[k] for k in ["arm", "n", "repetition", "evaluate_ms", "commit_ms"]}), flush=True)
    require_inventory(rows, wanted)
    summary = []
    for n in [128, 512, 2048, 8192]:
        cell = {"n": n, "record_bytes": len(representatives[n])}
        for arm in ARMS:
            selected = [r for r in rows if r["n"] == n and r["arm"] == arm]
            cell[arm] = {k: statistics.median(r[k] for r in selected)
                         for k in ["evaluate_ms", "commit_ms", "evaluate_plus_commit_ms", "process_ms"]}
        cell["comparisons"] = {}
        for candidate, reference in [("borrowed", "baseline"), ("projected", "baseline"), ("projected", "borrowed")]:
            cell["comparisons"][f"{candidate}_vs_{reference}"] = {
                metric: 100 * (cell[candidate][metric] / cell[reference][metric] - 1)
                for metric in ["commit_ms", "evaluate_plus_commit_ms"]
            }
        summary.append(cell)
    # Complete observations and semantic/recovery paths, outside the timing table.
    full_paths = []
    for label, overrides in [
        ("ordinary", {}),
        ("commands-references", {"history": 2, "commands": 2, "relations": True, "global": "filtered"}),
        ("history-update", {"history": 8, "commands": 2, "operation": "update"}),
    ]:
        case = dict(case_id=label, n=8, history=0, steps=2, batch=1, rules=1,
                    padding=0, filter_terms=1, operation="create", commands=0, relations=False,
                    **{"global": "count"})
        case.update(overrides)
        expected = None
        for arm in ARMS:
            path = output / f"{label}-{arm}.json"
            env = dict(os.environ, CORE031_OBSERVATION=str(path))
            result, process_ms = run([str(binaries / f"{arm}-full-path"), json.dumps(case)], output / "attempts.jsonl", env)
            assert result["mode"] == "production-like"
            assert result["execution_outcome"] == "ALLOW"
            assert result["final_position"] == case["history"] + case["steps"]
            raw = path.read_bytes()
            observation = json.loads(raw)
            for key in ["subject", "records", "bundles", "commits", "committed_results", "head", "versions", "reads", "commands", "replay"]:
                assert key in observation, key
            assert observation["subject"]["case"] == case
            assert set(observation["replay"]) == {"data", "behavior", "references"}
            assert all(report["ok"] for report in observation["replay"].values())
            assert len(observation["records"]) == case["steps"] + 2
            assert len(observation["bundles"]) == len(observation["committed_results"]) == case["steps"]
            assert len(observation["commits"]) == case["history"] + case["steps"]
            assert len(observation["reads"]) == 1
            if expected is None:
                expected = raw
            else:
                require_equal(expected, raw)
            artifacts.append(retain(output / f"{label}-{arm}.json.gz", raw))
            path.unlink()
            full_paths.append(dict(case=case, arm=arm, process_ms=process_ms,
                                   observation_sha256=digest(raw), result=result))
    result = dict(status="Complete", samples=len(rows), byte_equal=True, summary=summary,
                  full_paths=full_paths, artifacts=artifacts,
                  comparison_controls="changed byte, omitted sample and duplicate sample rejected")
    (output / "assessment.json").write_text(json.dumps(result, indent=2) + "\n")


if __name__ == "__main__":
    preexisting_output = len(sys.argv) == 3 and Path(sys.argv[2]).exists()
    try:
        main()
    except Exception as error:
        if len(sys.argv) == 3 and not preexisting_output:
            output = Path(sys.argv[2])
            if output.is_dir():
                samples = output / "samples.jsonl"
                failure = dict(status="Failed", error=repr(error), declared_timed_samples=60,
                               completed_timed_samples=len(samples.read_text().splitlines()) if samples.exists() else 0)
                (output / "failure.json").write_text(json.dumps(failure, indent=2) + "\n")
        raise
