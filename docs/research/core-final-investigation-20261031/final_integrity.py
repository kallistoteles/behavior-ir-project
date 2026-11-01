"""Recheck every campaign, source contract and executable archive; seal the study."""
import hashlib
import json
import re
import subprocess
import sys
import tarfile
from pathlib import Path
import common

HERE=Path(__file__).resolve().parent
EXCLUDED={'artifact-sha256.json','artifact-verification.json','progress.json'}


def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()


def verify_manifest():
    manifest=json.loads((HERE/'artifact-sha256.json').read_text())
    files={str(path.relative_to(HERE)) for path in HERE.rglob('*') if path.is_file()
           and '__pycache__' not in path.parts and path.name not in EXCLUDED}
    assert files==set(manifest)
    for name,expected in manifest.items():assert sha(HERE/name)==expected,name
    receipt=dict(status='Passed',files=len(manifest),bytes=sum((HERE/name).stat().st_size for name in manifest),
                 manifest_sha256=sha(HERE/'artifact-sha256.json'))
    (HERE/'artifact-verification.json').write_text(json.dumps(receipt,indent=2)+'\n')
    return receipt


def create():
    assert not (HERE/'artifact-sha256.json').exists()
    for name in ['final-report-audit.md','final-interpretation-audit.md','pmu-evidence-audit.md',
                 'allocator-source-conclusion.md','serialization-conclusion-audit.md']:
        assert (HERE/name).is_file(),name
    results={}
    for label,command in [('primary',['verify.py']),('factors',['factor_followup.py','verify']),
                          ('pmu',['allocation_pmu_verify.py'])]:
        raw=subprocess.check_output([sys.executable,*command],cwd=HERE,text=True)
        result=json.loads(raw);assert result['status']=='Passed'
        (HERE/f'final-{label}-recheck.json').write_text(raw)
        results[label]=result
    patch_check=Path('/tmp/behavior-ir-core-patch-check-20261101')
    assert subprocess.check_output(['git','status','--porcelain'],cwd=patch_check,text=True)==''
    assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=patch_check,text=True).strip()=='1a3ae37623cf90b4608a678ef283ee313306d9bb'
    subprocess.run(['git','apply','--check',str(HERE/'solution.patch')],cwd=patch_check,check=True)
    bindings=dict(json.loads((HERE/'measurement-precollection.json').read_text())['binaries'])
    bindings.update({row['binary']:row['sha256'] for row in json.loads((HERE/'pmu-builds.json').read_text())['arms'].values()})
    preservation=json.loads((HERE/'executable-preservation.json').read_text())
    assert sha(HERE/'executables.tar.gz')==preservation['archive_sha256']
    with tarfile.open(HERE/'executables.tar.gz') as archive:
        expected={f'sha256/{digest}' for digest in bindings.values()}|{'manifest.json'}
        assert {member.name for member in archive.getmembers()}==expected and len(archive.getmembers())==len(expected)
        assert json.loads(archive.extractfile('manifest.json').read())['original_paths']==bindings
        for digest in set(bindings.values()):
            data=archive.extractfile(f'sha256/{digest}').read()
            assert data.startswith(b'\x7fELF') and hashlib.sha256(data).hexdigest()==digest
    assert (len(bindings),len(set(bindings.values())))==(45,26)
    links=[]
    for path in [HERE/'report.md',HERE/'final-reproduction.md',HERE.parent/'README.md']:
        for target in re.findall(r'\[[^\]]*\]\(([^)]+)\)',path.read_text()):
            if target.startswith(('http://','https://','#')):continue
            assert (path.parent/target.split('#',1)[0]).exists(),(path.name,target)
            links.append((path.name,target))
    result=dict(status='Passed',campaigns=results,measured_processes=1215,executable_paths=45,
                unique_archived_executables=26,patch_base_check='Passed',final_document_links_checked=len(links),
                index_sha256=sha(HERE.parent/'README.md'),owner_gates=json.loads((HERE/'validation.json').read_text())['status'],
                qualifications=['Native N128 command-v2 first Display regresses; preserved.',
                                'PMU13zero-sample processes and1kernel/unknown sample preserved.',
                                'Source-site resource counters are not global allocator totals.'])
    (HERE/'final-integrity.json').write_text(json.dumps(result,indent=2)+'\n')
    manifest={str(path.relative_to(HERE)):sha(path) for path in sorted(HERE.rglob('*'))
              if path.is_file() and '__pycache__' not in path.parts and path.name not in EXCLUDED}
    (HERE/'artifact-sha256.json').write_text(json.dumps(manifest,indent=2)+'\n')
    return verify_manifest()


if __name__=='__main__':print(json.dumps(create() if sys.argv[1]=='create' else verify_manifest(),indent=2))
