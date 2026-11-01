"""Recompute retained descriptive summaries; no measurements or source mutations."""
import json
import statistics
from pathlib import Path

HERE = Path(__file__).resolve().parent


def rows(name):
    return [json.loads(line) for line in (HERE / 'evidence' / name).read_text().splitlines()]


def summarize():
    phases = rows('phase-samples.jsonl')
    serialization = rows('serialization-samples.jsonl')
    result = {'phase_summary': [], 'representative_no_bytes_n8192_r1': [], 'serialization_summary': []}
    native = {'evaluate': 'evaluate_ms', 'commit': 'commit_ms', 'serialization': 'record_serialization_ms'}
    for n in [128, 512, 2048, 8192]:
        item = {'n': n}
        for mode in ['normal', 'full', 'count-off']:
            selected = [r for r in phases if r['n'] == n and r['profile_mode'] == mode]
            item[mode] = {p: statistics.median(r[key] for r in selected) for p, key in native.items()}
        item['diagnostic_commit_ms'] = [
            {'mode': mode, 'median_closure_ms': statistics.median(
                sum(s['inclusive_ns'] for name, s in r['commit']['spans'].items() if name.startswith('diagnostic::')) / 1e6
                for r in phases if r['n'] == n and r['profile_mode'] == mode)}
            for mode in ['full', 'count-off']]
        result['phase_summary'].append(item)
    representative = next(r for r in phases if (r['n'], r['profile_mode'], r['repetition']) == (8192, 'count-off', 1))
    selectors = {
        'document_to_value': lambda name: name == 'store::hash_to_value',
        'document_hash_own': lambda name: name.startswith('store::documents::hash_of['),
        'canonical_serialization': lambda name: name == 'core::serialize_value',
        'canonical_value_check': lambda name: name == 'core::check_canonical_value',
        'digest_and_hex': lambda name: name.startswith('core::tagged_hash_canonical_text['),
        'bundle_and_return_clones': lambda name: name in ['store::archive_bundle_clone', 'store::event_bundle_clone', 'store::return_record_clone'],
        'strict_decode': lambda name: name == 'core::decode_strict',
        'typed_record_decode': lambda name: name in ['record08_typed_decode', 'record07_typed_decode'],
        'typed_common_validation': lambda name: name == 'core::record::validate_record07_fields',
        'current_specific_validation': lambda name: name == 'core::record::validate_record08',
        'exact_record_comparison': lambda name: name == 'core::record::exact_comparison',
        'reproduction_record_text': lambda name: name == 'store::record_to_string',
        'diagnostic_byte_closures': lambda name: name.startswith('diagnostic::'),
    }
    for phase, key in native.items():
        spans = representative[phase]['spans']
        root_ns = spans[f'phase::{phase}']['inclusive_ns']
        ranked = [dict(name=name, **s, exclusive_ms=s['exclusive_ns'] / 1e6,
                       share_percent=s['exclusive_ns'] / root_ns * 100)
                  for name, s in sorted(spans.items(), key=lambda item: -item[1]['exclusive_ns'])]
        groups = {label: {'exclusive_ms': sum(s['exclusive_ns'] for name, s in spans.items() if select(name)) / 1e6,
                          'calls': sum(s['calls'] for name, s in spans.items() if select(name))}
                  for label, select in selectors.items()}
        result['representative_no_bytes_n8192_r1'].append(dict(
            phase=phase, native_ms=representative[key], root_ms=root_ns / 1e6, ranked=ranked,
            work=representative[phase]['work'], disjoint_named_groups=groups,
            selected_group_share_percent=sum(g['exclusive_ms'] for g in groups.values()) / (root_ns / 1e6) * 100))
    for n in [128, 512]:
        for order in ['blocked', 'alternating-original', 'alternating-parsed']:
            item = {'n': n, 'order': order}
            for arm in ['a', 'c']:
                processes = []
                for r in serialization:
                    if (r['n'], r['order'], r['arm']) != (n, order, arm):
                        continue
                    process = {'repetition': r['repetition']}
                    for obj in ['original', 'parsed']:
                        rounds = [s for s in r['rounds'] if s['object'] == obj]
                        process[f'{obj}_first_ms'] = next(s['elapsed_ns'] / 1e6 for s in rounds if s['ordinal'] == 1)
                        process[f'{obj}_repeat_ms'] = statistics.median(s['elapsed_ns'] / 1e6 for s in rounds if s['ordinal'] > 1)
                    processes.append(process)
                item[arm] = {key: statistics.median(r[key] for r in processes) for key in processes[0] if key != 'repetition'}
                item[f'{arm}_processes'] = processes
            item['c_vs_a_percent'] = {key: (item['c'][key] / item['a'][key] - 1) * 100 for key in item['a']}
            result['serialization_summary'].append(item)
    return result


def equal(left, right):
    if isinstance(left, dict):
        assert left.keys() == right.keys()
        for key in left:
            equal(left[key], right[key])
    elif isinstance(left, list):
        assert len(left) == len(right)
        for a, b in zip(left, right):
            equal(a, b)
    elif isinstance(left, float):
        assert abs(left - right) <= max(1e-9, abs(left) * 1e-12), (left, right)
    else:
        assert left == right, (left, right)


if __name__ == '__main__':
    computed = summarize()
    equal(computed, json.loads((HERE / 'analysis.json').read_text()))
    print('All retained descriptive summaries reproduce from raw samples.')
