import json
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import Mock,patch
import allocation_pmu as pmu
import allocation_pmu_verify as verifier


class PmuControls(unittest.TestCase):
    def test_counter_receipts_require_both_events_and_running_time(self):
        raw='100,,cycles:u,1234,100.00,\n200,,instructions:u,1234,100.00,\n'
        self.assertEqual(pmu.counters(raw)['cycles:u']['count'],100)
        for bad in [raw.splitlines()[0],raw.replace('100.00','50.00'),raw.replace('100,,','<not counted>,,'),
                    raw+raw.splitlines()[0],raw.replace('100,,','inf,,')]:
            with self.assertRaises((AssertionError,ValueError)):pmu.counters(bad)

    def test_exact_matrix_and_arm_position_coverage(self):
        self.assertEqual((len(pmu.matrix('stat')),len(pmu.matrix('record'))),(70,35))
        for kind in ['stat','record']:
            rows=pmu.matrix(kind);self.assertEqual(len(rows),len(set(rows)))
            for n,c,arms in pmu.CASES:
                for mode in (['alloc','empty'] if kind=='stat' else ['alloc']):
                    for arm in arms:
                        positions=[]
                        for r in range(7):
                            selected=[row[3] for row in rows if row[:3]==(n,c,r) and row[4]==mode]
                            self.assertEqual(set(selected),set(arms));positions.append(selected.index(arm))
                        self.assertEqual(set(positions),set(range(len(arms))))

    def test_sampling_requires_both_diagnostic_gaps(self):
        values=[(512,0,'decode',1000000),(512,0,'typed',1000000),(512,0,'view',100000),
                (128,2,'original',10000),(128,2,'view',300000)]
        rows=[dict(n=n,commands=c,arm=a,mode='alloc',window_ns=t) for n,c,a,t in values for _ in range(7)]
        self.assertTrue(pmu.condition(rows)['collect_record'])
        for row in rows:
            if row['n']==128 and row['arm']=='view':row['window_ns']=10000
        self.assertFalse(pmu.condition(rows)['collect_record'])

    def test_timeout_kills_process_group_and_retains_partial_streams(self):
        process=Mock(pid=12345,returncode=-9)
        process.communicate.side_effect=[subprocess.TimeoutExpired(['perf'],180),('partial','diagnostic')]
        with tempfile.TemporaryDirectory() as directory:
            receipts=Path(directory)/'attempts.jsonl'
            with patch.object(pmu.subprocess,'Popen',return_value=process),patch.object(pmu.os,'killpg') as kill:
                with self.assertRaises(subprocess.TimeoutExpired):pmu.execute(['perf'],receipts,'stat')
                kill.assert_called_once()
            row=json.loads(receipts.read_text())
            self.assertEqual((row['status'],row['stdout'],row['stderr'],row['exit_code']),('Timeout','partial','diagnostic',-9))

    def test_nonzero_exit_retains_available_output(self):
        process=Mock(returncode=1);process.communicate.return_value=('partial','refused')
        with tempfile.TemporaryDirectory() as directory:
            receipts=Path(directory)/'attempts.jsonl'
            with patch.object(pmu.subprocess,'Popen',return_value=process):
                with self.assertRaises(subprocess.CalledProcessError):pmu.execute(['perf'],receipts,'stat')
            row=json.loads(receipts.read_text())
            self.assertEqual((row['status'],row['stdout'],row['stderr']),('Failed','partial','refused'))

    def test_sample_parser_preserves_spaced_symbols_unknowns_and_zero_weights(self):
        parsed=verifier.sample('  123  7ff <alloc::vec::Vec<u8> as core::fmt::Debug>::fmt (/nix/lib.so)')
        self.assertEqual(parsed['symbol'],'<alloc::vec::Vec<u8> as core::fmt::Debug>::fmt')
        self.assertEqual((parsed['period'],parsed['dso']),(123,'/nix/lib.so'))
        self.assertEqual(verifier.sample('0 abc [unknown] ([unknown])')['period'],0)
        for raw in ['PERF_RECORD_LOST 4','PERF_RECORD_THROTTLE','not a sample']:
            self.assertIsNone(verifier.sample(raw))


if __name__=='__main__':unittest.main()
