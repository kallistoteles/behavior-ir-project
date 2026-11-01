"""Descriptive same-campaign medians and matched pairs; no latency inference."""
import json
import statistics
from pathlib import Path
from common import require_inventory
from collect import ARMS, POPULATIONS, wanted

HERE = Path(__file__).resolve().parent
METRICS = ['evaluate_ms', 'commit_ms', 'record_serialization_ms',
           'evaluate_plus_commit_ms', 'evaluated_serialized_ms', 'process_ms']


def analyze():
    rows = [json.loads(line) for line in (HERE / 'evidence/samples.jsonl').read_text().splitlines()]
    require_inventory(rows, wanted())
    summary = []
    for n in POPULATIONS:
        cell = {'n': n}
        for arm in ARMS:
            selected = [r for r in rows if (r['n'], r['arm']) == (n, arm)]
            cell[arm] = {metric: statistics.median(r[metric] for r in selected) for metric in METRICS}
        cell['moved_vs_baseline_percent'] = {
            metric: 100 * (cell['moved'][metric] / cell['baseline'][metric] - 1) for metric in METRICS}
        pairs = []
        for repetition in range(7):
            a = next(r for r in rows if (r['n'], r['arm'], r['repetition']) == (n, 'baseline', repetition))
            b = next(r for r in rows if (r['n'], r['arm'], r['repetition']) == (n, 'moved', repetition))
            pairs.append({'repetition': repetition, **{metric: 100 * (b[metric] / a[metric] - 1) for metric in METRICS}})
        cell['paired_changes_percent'] = pairs
        cell['adverse_pair_counts'] = {metric: sum(p[metric] > 0 for p in pairs) for metric in METRICS}
        summary.append(cell)
    return {'summary': summary, 'sign_convention': 'negative means moved faster; ratio of cohort medians and per-repetition paired ratios are distinct'}


if __name__ == '__main__':
    (HERE / 'analysis.json').write_text(json.dumps(analyze(), indent=2) + '\n')
    print('Wrote descriptive analysis from all 56 fresh-process samples.')
