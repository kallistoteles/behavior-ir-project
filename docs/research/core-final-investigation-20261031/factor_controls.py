import copy
import json
import unittest
from pathlib import Path
import factor_followup as factor


class FactorControls(unittest.TestCase):
    def test_matrix_is_complete_unique_and_every_arm_visits_every_position(self):
        rows=factor.matrix()
        self.assertEqual(len(rows),560)
        self.assertEqual(len(set(rows)),560)
        for n,c,arms in factor.CASES:
            for sink in factor.SINKS:
                for touch in factor.TOUCHES:
                    for arm in arms:
                        positions=[]
                        for repetition in range(7):
                            selected=[r[-1] for r in rows if r[:5]==(n,c,repetition,sink,touch)]
                            self.assertEqual(set(selected),set(arms))
                            positions.append(selected.index(arm))
                        self.assertEqual(set(positions),set(range(len(arms))))

    def sample(self):
        row=json.loads((Path(__file__).parent/'sinks/samples.jsonl').read_text().splitlines()[0])
        return row

    def test_real_primary_receipt_schema_passes(self):
        row=self.sample()
        factor.validate(row,row['n'],0,row['sink'],row['intervention'],row['record_bytes'])

    def test_actual_command_mismatch_is_not_masked_by_common_schema_adapter(self):
        row=self.sample()
        with self.assertRaises(AssertionError): factor.validate(row,row['n'],2,row['sink'],row['intervention'],row['record_bytes'])

    def test_missing_round_and_wrong_setup_sum_refuse(self):
        row=self.sample()
        bad=copy.deepcopy(row);bad['rounds'].pop()
        with self.assertRaises(AssertionError): factor.validate(bad,bad['n'],0,bad['sink'],bad['intervention'],bad['record_bytes'])
        bad=copy.deepcopy(row);bad['rounds'][0]['total_ns']+=1
        with self.assertRaises(AssertionError): factor.validate(bad,bad['n'],0,bad['sink'],bad['intervention'],bad['record_bytes'])

    def test_fake_touch_and_diagnostic_mode_refuse(self):
        row=self.sample();row['intervention']='touch';row['touch_checksum']=0
        with self.assertRaises(AssertionError): factor.validate(row,row['n'],0,row['sink'],'touch',row['record_bytes'])
        row=self.sample();row['diagnostics']=True
        with self.assertRaises(AssertionError): factor.validate(row,row['n'],0,row['sink'],row['intervention'],row['record_bytes'])


if __name__=='__main__': unittest.main()
