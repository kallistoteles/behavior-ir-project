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
    attempt = {"argv": command, "utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
               "status":"Started", "stdout":"", "stderr":""}
    if env is not None and "CORE_PROFILE_BYTES" in env:
        attempt["profile_bytes_env"] = env["CORE_PROFILE_BYTES"]
    process = None
    try:
        process = subprocess.Popen(command, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                   env=env, preexec_fn=limits)
        try:
            stdout, stderr = process.communicate(timeout=180)
        except BaseException as error:
            if process.poll() is None:
                process.kill()
            stdout, stderr = process.communicate()
            attempt.update(exit_code=process.returncode, stdout=stdout, stderr=stderr,
                           status="Timeout" if isinstance(error, subprocess.TimeoutExpired) else "Interrupted")
            raise
        attempt.update(exit_code=process.returncode, stdout=stdout, stderr=stderr)
        if process.returncode:
            raise subprocess.CalledProcessError(process.returncode, command, stdout, stderr)
        parsed = json.loads(stdout)
        attempt["status"] = "Completed"
        return parsed, (time.perf_counter() - start) * 1000
    except BaseException as error:
        if attempt["status"] not in {"Timeout","Interrupted"}:
            attempt["status"] = "Failed" if isinstance(error,Exception) else "Interrupted"
        attempt["error"] = repr(error)
        raise
    finally:
        attempt["process_ms"] = (time.perf_counter() - start) * 1000
        with attempts.open("a") as stream:
            stream.write(json.dumps(attempt) + "\n")


def retain(path, data):
    path.write_bytes(gzip.compress(data, mtime=0))
    return {"path": path.name, "sha256": digest(data), "bytes": len(data),
            "gzip_bytes": path.stat().st_size}

