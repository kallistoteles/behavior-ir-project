import copy
import unittest
import collect
import common
import json
import tempfile
from pathlib import Path
from unittest.mock import Mock,patch

class EvidenceControls(unittest.TestCase):
    def test_handled_interrupt_retains_partial_output_and_mode(self):
        process=Mock(); process.communicate.side_effect=[KeyboardInterrupt(),('partial','diagnostic')]
        process.poll.return_value=None;process.returncode=-9
        with tempfile.TemporaryDirectory() as directory:
            path=Path(directory)/'attempts.jsonl'
            with patch.object(common.subprocess,'Popen',return_value=process):
                with self.assertRaises(KeyboardInterrupt): common.run(['probe'],path,{'CORE_PROFILE_BYTES':'0'})
            row=json.loads(path.read_text())
            self.assertEqual((row['status'],row['stdout'],row['stderr']),('Interrupted','partial','diagnostic'))
            self.assertEqual(row['profile_bytes_env'],'0');process.kill.assert_called_once()
    def serial(self):
        return {'n':128,'order':'blocked','diagnostics':False,'record_bytes':7,'record_sha256':'expected',
                'rounds':[{'object':kind,'ordinal':index,'elapsed_ns':1,'bytes':7} for kind,index in collect.schedule('blocked')]}
    def test_complete_rounds_pass(self): collect.validate_rounds(self.serial(),128,'blocked','expected',7)
    def test_omitted_round_refuses(self):
        row=self.serial();row['rounds'].pop()
        with self.assertRaises((AssertionError,ValueError)): collect.validate_rounds(row,128,'blocked','expected',7)
    def test_duplicate_round_refuses(self):
        row=self.serial(); row['rounds'][-1]=row['rounds'][-2]
        with self.assertRaises((AssertionError,ValueError)): collect.validate_rounds(row,128,'blocked','expected',7)
    def test_wrong_output_identity_refuses(self):
        row=self.serial(); row['record_sha256']='changed'
        with self.assertRaises((AssertionError,ValueError)): collect.validate_rounds(row,128,'blocked','expected',7)
    def test_unbalanced_partition_refuses(self):
        spans={'root':{'calls':1,'inclusive_ns':10,'exclusive_ns':4},'child':{'calls':1,'inclusive_ns':6,'exclusive_ns':5}}
        with self.assertRaises((AssertionError,ValueError)): collect.validate_partition(spans,'root')
    def test_complete_partition_passes(self):
        collect.validate_partition({'root':{'calls':1,'inclusive_ns':10,'exclusive_ns':4},'child':{'calls':1,'inclusive_ns':6,'exclusive_ns':6}},'root')
    def test_missing_byte_count_mode_refuses(self):
        expected=[(128,r,m) for r in range(3) for m in ['normal','full','count-off']]
        rows=[dict(n=n,repetition=r,mode=m) for n,r,m in expected if m!='count-off']
        with self.assertRaises(ValueError): collect.require_cases(rows,['n','repetition','mode'],expected)

if __name__=='__main__': unittest.main()
