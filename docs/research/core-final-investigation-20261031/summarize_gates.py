"""Summarize the complete owner gate log without converting ignored tests to passes."""
import json
import re
from pathlib import Path

HERE = Path(__file__).resolve().parent
raw = (HERE / 'workspace-gates.log').read_text()
assert raw.rstrip().endswith('gates: OK') and 'gates: FAILED' not in raw
sections = re.split(r'^gates: (.+)$', raw, flags=re.MULTILINE)
gates = []
for index in range(1, len(sections), 2):
    name, output = sections[index:index+2]
    if name == 'OK':
        continue
    results = [tuple(map(int, row)) for row in re.findall(
        r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored', output)]
    gates.append(dict(name=name, status='Passed', test_groups=len(results),
                      passed=sum(row[0] for row in results),
                      failed=sum(row[1] for row in results),
                      ignored=sum(row[2] for row in results)))
assert len(gates) == 13 and all(row['failed'] == 0 for row in gates)
result = dict(status='Passed', owner_command='scripts/gates.sh',
              default_test_scope='cargo test --workspace; standard ignored tests remain ignored',
              gates=gates)
(HERE / 'validation.json').write_text(json.dumps(result, indent=2) + '\n')
print(json.dumps(result, indent=2))
