"""Descriptive within-campaign medians and matched pairs, keeping workloads separate."""
import json
import statistics
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent


def rows(folder):
    return [json.loads(line) for line in (folder / 'samples.jsonl').read_text().splitlines()]


def grouped(processes, keys, arms, comparisons):
    summaries = []
    for group in sorted({tuple(row[key] for key in keys) for row in processes}):
        selected = [r for r in processes if tuple(r[k] for k in keys) == group]
        cell = dict(zip(keys, group))
        by_arm = {arm: sorted([r for r in selected if r['arm'] == arm], key=lambda r: r['repetition']) for arm in arms}
        assert all([r['repetition'] for r in group_rows] == list(range(7)) for group_rows in by_arm.values())
        metrics = [key for key in selected[0] if key.endswith('_ms')]
        cell['arms'] = {arm: {metric: statistics.median(r[metric] for r in group_rows) for metric in metrics}
                        for arm, group_rows in by_arm.items()}
        cell['comparisons'] = {}
        for candidate, reference in comparisons:
            paired = [dict(repetition=c['repetition'], **{
                metric: 100 * (c[metric] / r[metric] - 1) if r[metric] else None for metric in metrics})
                for c, r in zip(by_arm[candidate], by_arm[reference])]
            cell['comparisons'][f'{candidate}_vs_{reference}'] = {
                'median_change_percent': {metric: 100 * (cell['arms'][candidate][metric] / cell['arms'][reference][metric] - 1)
                                          if cell['arms'][reference][metric] else None for metric in metrics},
                'paired_changes_percent': paired,
                'adverse_pair_counts': {metric: sum(p[metric] is not None and p[metric] > 0 for p in paired) for metric in metrics}}
        summaries.append(cell)
    return summaries


def native(folder):
    from final_collect import ARMS
    processes = []
    for row in rows(folder):
        item = {k: row[k] for k in ['n', 'commands', 'arm', 'repetition', 'process_ms']}
        for label, source in [('evaluate', 'evaluate_ns'), ('commit', 'commit_ns'), ('serialize', 'serialization_ns'),
                              ('evaluate_commit', 'evaluate_commit_ns'), ('consumer', 'consumer_ns')]:
            item[f'{label}_ms'] = row[source] / 1e6
        processes.append(item)
    comparisons = list(zip(ARMS[1:], ARMS[:-1])) + [('view', a) for a in ARMS[:-2]]
    return dict(summary=grouped(processes, ['n', 'commands'], ARMS, comparisons), process_summaries=processes)


def sink(folder):
    from serial_collect import ARMS
    processes = []
    for row in rows(folder):
        item = {k: row[k] for k in ['n', 'sink', 'intervention', 'arm', 'repetition', 'process_ms']}
        item.update(evaluate_commit_ms=(row['evaluate_ns'] + row['commit_ns']) / 1e6,
                    touch_ms=row['touch_ns'] / 1e6,
                    first_consumer_ms=(row['evaluate_ns'] + row['commit_ns'] + row['touch_ns'] + row['rounds'][0]['total_ns']) / 1e6)
        for name, prefix in [('original', 'o'), ('parsed', 'p')]:
            selected = [r for r in row['rounds'] if r['object'] == name]
            first = next(r for r in selected if r['ordinal'] == 1)
            repeats = [r for r in selected if r['ordinal'] > 1]
            for phase in ['setup', 'write', 'total']:
                item[f'{prefix}1_{phase}_ms'] = first[f'{phase}_ns'] / 1e6
                item[f'{prefix}_repeat_{phase}_ms'] = statistics.median(r[f'{phase}_ns'] / 1e6 for r in repeats)
        processes.append(item)
    comparisons = [('typed', 'decode'), ('moved', 'decode'), ('view', 'decode'), ('view', 'typed'), ('view', 'moved')]
    summary = grouped(processes, ['n', 'sink', 'intervention'], ARMS, comparisons)
    sink_pairs = []
    modes = {r['sink'] for r in processes}
    for n in sorted({r['n'] for r in processes}):
        for intervention in sorted({r['intervention'] for r in processes}):
            for arm in ARMS:
                for candidate, reference in [('vec', 'display'), ('writer-full', 'writer128'),
                                               ('writer-full', 'display'), ('display-full', 'display128')]:
                    if not {candidate, reference} <= modes: continue
                    selected = []
                    for row in processes:
                        if (row['n'], row['intervention'], row['arm']) == (n, intervention, arm) and row['sink'] in [candidate, reference]:
                            selected.append({**row, 'arm': row['sink']})
                    paired = grouped(selected, ['n', 'intervention'], [reference, candidate], [(candidate, reference)])[0]
                    sink_pairs.append(dict(n=n, intervention=intervention, arm=arm, candidate=candidate,
                                           reference=reference, **paired['comparisons'][f'{candidate}_vs_{reference}']))
    return dict(summary=summary, sink_contrasts=sink_pairs, process_summaries=processes)


def anchor(folder):
    from anchor_collect import ARMS
    processes = []
    for row in rows(folder):
        item = {k: row[k] for k in ['n', 'arm', 'repetition', 'evaluate_ms', 'commit_ms', 'process_ms', 'evaluate_commit_ms', 'consumer_ms']}
        item['serialize_ms'] = row['record_serialization_ms']; processes.append(item)
    return dict(summary=grouped(processes, ['n'], ARMS,
        [('typed', 'decode'), ('moved', 'decode'), ('view', 'decode'), ('view', 'typed'), ('view', 'moved')]), process_summaries=processes)


if __name__ == '__main__':
    mode, name = sys.argv[1:]
    result = {'native': native, 'sink': sink, 'anchor': anchor}[mode](HERE / name)
    (HERE / f'{name}-analysis.json').write_text(json.dumps(result, indent=2) + '\n')
    print(f'Recomputed {mode} summaries from all retained process samples.')
