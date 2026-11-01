import json
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import Mock, patch
import collect
import common


class EvidenceControls(unittest.TestCase):
    def inventory(self):
        return [dict(n=n, repetition=r, arm=a) for n, r, a in collect.wanted()]

    def test_exact_matrix_passes(self):
        common.require_inventory(self.inventory(), collect.wanted())

    def test_missing_entire_arm_refuses(self):
        with self.assertRaises(ValueError):
            common.require_inventory([r for r in self.inventory() if r['arm'] == 'baseline'], collect.wanted())

    def test_missing_and_duplicate_samples_refuse(self):
        for rows in [self.inventory()[:-1], self.inventory() + [self.inventory()[0]]]:
            with self.assertRaises(ValueError):
                common.require_inventory(rows, collect.wanted())

    def test_changed_complete_bytes_refuse(self):
        common.require_equal(b'complete', b'complete')
        with self.assertRaises(ValueError):
            common.require_equal(b'complete', b'completE')

    def test_instrumented_phase_refuses(self):
        row = dict(n=128, variant='original', repetition=0, mode='uninstrumented', evaluate=None,
                   commit=None, serialization=None, evaluate_ms=1, commit_ms=2, record_serialization_ms=3)
        collect.validate_phase(row, 128)
        row['mode'] = 'instrumented'
        with self.assertRaises(AssertionError):
            collect.validate_phase(row, 128)

    def attempt_error(self, error, expected_status):
        process = Mock()
        process.communicate.side_effect = [error, ('partial', 'diagnostic')]
        process.poll.return_value = None
        process.returncode = -9
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'attempts.jsonl'
            with patch.object(common.subprocess, 'Popen', return_value=process):
                with self.assertRaises(type(error)):
                    common.run(['probe'], path)
            row = json.loads(path.read_text())
            self.assertEqual((row['status'], row['stdout'], row['stderr']), (expected_status, 'partial', 'diagnostic'))
            self.assertEqual(row['exit_code'], -9)
            process.kill.assert_called_once()

    def test_timeout_retains_partial_output(self):
        self.attempt_error(subprocess.TimeoutExpired(['probe'], 180), 'Timeout')

    def test_interrupt_retains_partial_output(self):
        self.attempt_error(KeyboardInterrupt(), 'Interrupted')

    def test_nonzero_process_retains_output(self):
        process = Mock()
        process.communicate.return_value = ('partial', 'failed')
        process.returncode = 7
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'attempts.jsonl'
            with patch.object(common.subprocess, 'Popen', return_value=process):
                with self.assertRaises(subprocess.CalledProcessError):
                    common.run(['probe'], path, {'CORE031_OBSERVATION': '/tmp/synthetic-observation.json'})
            row = json.loads(path.read_text())
            self.assertEqual((row['status'], row['exit_code'], row['stdout'], row['stderr']), ('Failed', 7, 'partial', 'failed'))
            self.assertEqual(row['observation_path_env'], '/tmp/synthetic-observation.json')


if __name__ == '__main__':
    unittest.main()
