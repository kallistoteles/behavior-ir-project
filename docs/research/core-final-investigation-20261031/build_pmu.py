"""Build separately identified allocation-window probes; primary binaries stay immutable."""
import gzip
import hashlib
import io
import json
import os
import shutil
import subprocess
import sys
import tarfile
from pathlib import Path

HERE=Path(__file__).resolve().parent
FINAL=Path('/tmp/behavior-ir-core-final-20261031')
REFERENCE=Path('/tmp/behavior-ir-core-reference-20261031')
BINS=Path('/tmp/core-final-pmu-binaries-20261101')
BINS.mkdir(exist_ok=True)
assert not any(BINS.iterdir()), 'refuse to replace retained diagnostic binaries'
sha=lambda data:hashlib.sha256(data).hexdigest()
subprocess.run(['rustfmt','--edition','2024','--config','skip_children=true',str(HERE/'allocation_pmu_probe.rs')],check=True)
for root in [FINAL,REFERENCE]:
    shutil.copyfile(HERE/'allocation_pmu_probe.rs',root/'crates/behavior-store/examples/allocation_pmu_probe.rs')
old=HERE.parent/'core-typed-record-20261031'
base_record=subprocess.check_output(['git','show','HEAD:crates/behavior-core/src/record.rs'],cwd=REFERENCE)
base_store=subprocess.check_output(['git','show','HEAD:crates/behavior-store/src/store.rs'],cwd=REFERENCE)
arms=[('view',FINAL,None),('original',REFERENCE,base_record),
      ('decode',REFERENCE,(old/'baseline-record.rs').read_bytes()),
      ('typed',REFERENCE,(old/'projected-record.rs').read_bytes())]
result=dict(status='Building',arms={})
for arm,root,record in arms:
    if record is not None:
        (root/'crates/behavior-core/src/record.rs').write_bytes(record)
        (root/'crates/behavior-store/src/store.rs').write_bytes(base_store)
    target=FINAL/'target' if root==FINAL else Path('/tmp/behavior-ir-core-continuation-20261029/target')
    env=dict(os.environ,CARGO_TARGET_DIR=str(target),CARGO_BUILD_JOBS='3',CARGO_INCREMENTAL='0')
    if arm=='view':
        subprocess.run([sys.executable,str(HERE/'run_logged.py'),str(HERE/'pmu-clippy.log'),
                        'cargo','clippy','--locked','-p','behavior-store','--example','allocation_pmu_probe','--','-D','warnings'],
                       cwd=root,env=env,check=True)
    command=['cargo','build','--locked','--release','-v','-p','behavior-store','--example','allocation_pmu_probe']
    subprocess.run([sys.executable,str(HERE/'run_logged.py'),str(HERE/f'pmu-{arm}-build.log'),*command],cwd=root,env=env,check=True)
    path=BINS/f'exec{["original","decode","typed","view"].index(arm):02d}'
    shutil.copyfile(target/'release/examples/allocation_pmu_probe',path);path.chmod(0o755)
    paths=set(subprocess.check_output(['git','ls-files','-co','--exclude-standard'],cwd=root,text=True).splitlines())
    paths=sorted(p for p in paths if p.startswith('crates/') or p in ['Cargo.toml','Cargo.lock','rust-toolchain.toml','flake.nix','flake.lock'])
    sources={p:sha((root/p).read_bytes()) for p in paths if (root/p).is_file()}
    buf=io.BytesIO()
    with tarfile.open(fileobj=buf,mode='w') as archive:
        for name in sources:
            data=(root/name).read_bytes();info=tarfile.TarInfo(name);info.size=len(data);info.mode=0o644
            archive.addfile(info,io.BytesIO(data))
    archive=HERE/f'pmu-{arm}-source.tar.gz';archive.write_bytes(gzip.compress(buf.getvalue(),mtime=0))
    result['arms'][arm]=dict(checkout=str(root),target=str(target),binary=str(path),sha256=sha(path.read_bytes()),
                             source=sources,archive=archive.name,archive_sha256=sha(archive.read_bytes()),command=command)
    (HERE/'pmu-builds.json').write_text(json.dumps(result,indent=2)+'\n')
result.update(status='Complete',rustc=subprocess.check_output(['rustc','-Vv'],text=True))
(HERE/'pmu-builds.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({a:v['sha256'] for a,v in result['arms'].items()},indent=2))
