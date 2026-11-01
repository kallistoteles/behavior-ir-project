"""Evidence-harness controls; these do not count as Core correctness evidence."""
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import collect


class CollectorControls(unittest.TestCase):
    def test_omitting_an_entire_arm_cannot_complete_the_campaign(self):
        wanted = [(n,r,arm) for n in [128,512] for r in range(2)
                  for arm in ["baseline","borrowed","projected"]]
        rows = [dict(n=n,repetition=r,arm=arm) for n,r,arm in wanted]
        collect.require_inventory(rows,wanted)
        with self.assertRaises(ValueError):
            collect.require_inventory([r for r in rows if r["arm"]!="projected"],wanted)

    def test_comparison_and_inventory_reject_corrupted_evidence(self):
        collect.controls()

    def test_nonzero_process_retains_actual_output_and_status(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "attempts.jsonl"
            with self.assertRaises(subprocess.CalledProcessError):
                collect.run([sys.executable, "-c", "import sys; print('out'); print('err',file=sys.stderr); sys.exit(7)"], path)
            attempt = json.loads(path.read_text())
            self.assertEqual((attempt["status"], attempt["exit_code"]), ("Failed", 7))
            self.assertEqual((attempt["stdout"], attempt["stderr"]), ("out\n", "err\n"))

    def test_invalid_json_success_is_not_accepted_as_a_measurement(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "attempts.jsonl"
            with self.assertRaises(json.JSONDecodeError):
                collect.run([sys.executable, "-c", "print('not JSON')"], path)
            attempt = json.loads(path.read_text())
            self.assertEqual((attempt["status"], attempt["exit_code"]), ("Failed", 0))
            self.assertEqual(attempt["stdout"], "not JSON\n")

    def test_timeout_retains_partial_output(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "attempts.jsonl"
            failure = subprocess.TimeoutExpired(["probe"], 180, output=b"partial", stderr=b"diagnostic")
            with patch.object(collect.subprocess, "run", side_effect=failure):
                with self.assertRaises(subprocess.TimeoutExpired):
                    collect.run(["probe"], path)
            attempt = json.loads(path.read_text())
            self.assertEqual(attempt["status"], "Timeout")
            self.assertEqual((attempt["stdout"], attempt["stderr"]), ("partial", "diagnostic"))


if __name__ == "__main__":
    unittest.main()
