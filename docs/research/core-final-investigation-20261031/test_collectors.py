import copy
import json
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import Mock, patch
import common
import final_collect as native
import serial_collect as serial
import anchor_collect as anchor
import verify


class EvidenceControls(unittest.TestCase):
    def native_rows(self):
        return [dict(n=n, commands=c, repetition=r, arm=a) for n, c in native.CASES
                for r in range(native.REPETITIONS) for a in native.ARMS]

    def expected(self):
        return [(r['n'], r['commands'], r['repetition'], r['arm']) for r in self.native_rows()]

    def test_exact_native_matrix_passes(self):
        native.inventory(self.native_rows(), ['n', 'commands', 'repetition', 'arm'], self.expected())

    def test_rotated_sink_orders_cover_each_mode_and_equal_length_program_aliases(self):
        orders = []
        for repetition in range(serial.REPETITIONS):
            modes = serial.sink_order(0, repetition)
            self.assertEqual(sorted(modes), sorted(serial.SINKS))
            orders.append(tuple(modes))
        self.assertGreater(len(set(orders)), 1)
        self.assertEqual(len({len(str(native.program(Path('/tmp/bin'), arm, 'serial'))) for arm in native.ARMS}), 1)

    def test_each_arm_and_sink_visits_every_position(self):
        for module in [native, serial, anchor]:
            for index in range(6):
                for arm in module.ARMS:
                    positions = [module.order(index, r).index(arm) for r in range(module.REPETITIONS)]
                    self.assertEqual(set(positions), set(range(len(module.ARMS))))
        for index in range(2):
            for sink in serial.SINKS:
                self.assertEqual({serial.sink_order(index, r).index(sink) for r in range(serial.REPETITIONS)}, set(range(len(serial.SINKS))))

    def test_successful_process_duration_is_identical_in_row_and_attempt(self):
        process = Mock(); process.communicate.return_value = ('{"ok":true}', ''); process.returncode = 0
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'attempts.jsonl'
            with patch.object(common.subprocess, 'Popen', return_value=process):
                parsed, elapsed = common.run(['probe'], path)
            self.assertEqual(parsed, {'ok': True})
            self.assertEqual(elapsed, json.loads(path.read_text())['process_ms'])

    def test_missing_arm_case_or_duplicate_refuses(self):
        rows = self.native_rows()
        for bad in [[r for r in rows if r['arm'] != 'view'], rows[:-1], rows + [rows[0]],
                    [r for r in rows if r['commands'] == 0]]:
            with self.assertRaises(ValueError): native.inventory(bad, ['n', 'commands', 'repetition', 'arm'], self.expected())

    def round_row(self):
        return dict(n=128, commands=0, sink='writer-full', intervention='sham', diagnostics=False,
                    record_bytes=1000, touch_ns=1, touch_checksum=0, evaluate_ns=1, commit_ns=2,
                    rounds=[dict(object=o, ordinal=r, setup_ns=1, write_ns=2, total_ns=3,
                                 capacity_before=1000, capacity_after=1000, bytes=1000)
                            for o in ['original', 'parsed'] for r in range(1, 5)])

    def test_exact_serial_rounds_pass(self):
        serial.validate(self.round_row(), 128, 'writer-full', 'sham', 1000)

    def test_missing_or_duplicated_serial_round_refuses(self):
        for remove in [True, False]:
            row = self.round_row()
            if remove: row['rounds'].pop()
            else: row['rounds'][-1] = row['rounds'][-2]
            with self.assertRaises(AssertionError): serial.validate(row, 128, 'writer-full', 'sham', 1000)

    def test_bad_sink_mode_capacity_size_or_time_refuses(self):
        for field, value in [('capacity_after', 2000), ('bytes', 999), ('total_ns', 4), ('setup_ns', -1)]:
            row = self.round_row(); row['rounds'][0][field] = value
            with self.assertRaises(AssertionError): serial.validate(row, 128, 'writer-full', 'sham', 1000)
        row = self.round_row(); row['diagnostics'] = True
        with self.assertRaises(AssertionError): serial.validate(row, 128, 'writer-full', 'sham', 1000)

    def test_changed_complete_bytes_refuse(self):
        common.require_equal(b'complete', b'complete')
        with self.assertRaises(ValueError): common.require_equal(b'complete', b'completE')

    def test_anchor_invalid_times_refuse(self):
        row = dict(evaluate_ms=1.0, commit_ms=2.0, record_serialization_ms=0.1)
        anchor.validate(row)
        for bad in [-1, float('nan'), float('inf')]:
            with self.assertRaises(AssertionError): anchor.validate({**row, 'commit_ms': bad})

    def test_verifier_environment_rejects_changed_receipt(self):
        with tempfile.TemporaryDirectory() as directory:
            here = Path(directory); bins = here / 'bins'; bins.mkdir()
            inputs = here / 'inputs'; inputs.mkdir(); folder = here / 'native'; folder.mkdir()
            binary = bins / 'exec00-native'; binary.write_bytes(b'binary')
            record = inputs / 'n128-c0.decision.json'; record.write_bytes(b'record')
            frozen = dict(utc='2026-01-01T00:00:00+00:00', binaries={str(binary): common.digest(binary.read_bytes())},
                          records={str(record): common.digest(record.read_bytes())})
            path = here / 'measurement-precollection.json'; path.write_text(json.dumps(frozen))
            env = dict(utc='2026-01-02T00:00:00+00:00', child_cpu=7, address_space_limit_bytes=8*1024**3,
                       timeout_seconds=180, precollection_sha256=common.digest(path.read_bytes()),
                       declared_native=252, declared_full=18, binaries={binary.name: frozen['binaries'][str(binary)]},
                       inputs={record.name: frozen['records'][str(record)]})
            snapshot = folder / 'environment.json'; snapshot.write_text(json.dumps(env))
            with patch.object(verify, 'HERE', here):
                verify.check_environment(folder, bins, inputs, 'native')
                for key, value in [('precollection_sha256', 'wrong'), ('child_cpu', 6),
                                   ('binaries', {binary.name: 'wrong'}), ('inputs', {record.name: 'wrong'})]:
                    snapshot.write_text(json.dumps({**env, key: value}))
                    with self.assertRaises(AssertionError): verify.check_environment(folder, bins, inputs, 'native')

    def test_diagnostic_native_mode_refuses(self):
        row = dict(n=128, commands=0, diagnostics=False, evaluate_ns=1, commit_ns=2,
                   serialization_ns=3, record_bytes=1000, event_bytes=2000)
        native.validate_native(row, 128, 0); row['diagnostics'] = True
        with self.assertRaises(AssertionError): native.validate_native(row, 128, 0)

    def attempt(self, error, status):
        process = Mock(); process.communicate.side_effect = [error, ('partial', 'diagnostic')]
        process.poll.return_value = None; process.returncode = -9
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'attempts.jsonl'
            with patch.object(common.subprocess, 'Popen', return_value=process):
                with self.assertRaises(type(error)): common.run(['probe'], path)
            row = json.loads(path.read_text())
            self.assertEqual((row['status'], row['exit_code'], row['stdout'], row['stderr']), (status, -9, 'partial', 'diagnostic'))
            process.kill.assert_called_once()

    def test_handled_interrupt_retains_partial_output(self): self.attempt(KeyboardInterrupt(), 'Interrupted')
    def test_timeout_retains_partial_output(self): self.attempt(subprocess.TimeoutExpired(['probe'], 180), 'Timeout')

    def test_nonzero_exit_retains_output_and_explicit_observation_path(self):
        process = Mock(); process.communicate.return_value = ('partial', 'refused'); process.returncode = 7
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'attempts.jsonl'
            with patch.object(common.subprocess, 'Popen', return_value=process):
                with self.assertRaises(subprocess.CalledProcessError): common.run(['probe'], path, {'CORE031_OBSERVATION': '/tmp/synthetic.json'})
            row = json.loads(path.read_text())
            self.assertEqual((row['status'], row['exit_code'], row['stdout'], row['stderr']), ('Failed', 7, 'partial', 'refused'))
            self.assertEqual(row['observation_path_env'], '/tmp/synthetic.json')


if __name__ == '__main__': unittest.main()
