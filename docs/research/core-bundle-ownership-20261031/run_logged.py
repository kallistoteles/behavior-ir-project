"""Capture one explicit research command without recording ambient configuration."""
import datetime
import json
import subprocess
import sys
from pathlib import Path

log = Path(sys.argv[1])
command = sys.argv[2:]
with log.open("w") as stream:
    stream.write(json.dumps({"command": command, "utc": datetime.datetime.now(datetime.timezone.utc).isoformat()}) + "\n")
    stream.flush()
    result = subprocess.run(command, stdout=stream, stderr=subprocess.STDOUT)
print(json.dumps({"log": str(log), "exit_code": result.returncode}))
raise SystemExit(result.returncode)
