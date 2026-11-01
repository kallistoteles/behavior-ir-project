"""Preserve every measured executable once by content hash, including old anchors."""
import gzip
import hashlib
import io
import json
import tarfile
from pathlib import Path

HERE=Path(__file__).resolve().parent
primary=json.loads((HERE/'measurement-precollection.json').read_text())
pmu=json.loads((HERE/'pmu-builds.json').read_text())
bindings=dict(primary['binaries'])
bindings.update({row['binary']:row['sha256'] for row in pmu['arms'].values()})
unique={}
for path,expected in bindings.items():
    assert hashlib.sha256(Path(path).read_bytes()).hexdigest()==expected,path
    unique.setdefault(expected,Path(path))
destination=HERE/'executables.tar.gz'
assert not destination.exists()
manifest=json.dumps(dict(format='content-addressed-executables-v1',original_paths=bindings),indent=2).encode()+b'\n'
with destination.open('wb') as raw:
    with gzip.GzipFile(fileobj=raw,mode='wb',filename='',mtime=0,compresslevel=6) as compressed:
        with tarfile.open(fileobj=compressed,mode='w|') as archive:
            info=tarfile.TarInfo('manifest.json');info.size=len(manifest);info.mode=0o644
            archive.addfile(info,io.BytesIO(manifest))
            for digest,path in sorted(unique.items()):
                data=path.read_bytes();info=tarfile.TarInfo(f'sha256/{digest}');info.size=len(data);info.mode=0o755
                archive.addfile(info,io.BytesIO(data))
with tarfile.open(destination) as archive:
    assert len(archive.getmembers())==len(unique)+1
    assert archive.extractfile('manifest.json').read()==manifest
    for digest in unique:
        assert hashlib.sha256(archive.extractfile(f'sha256/{digest}').read()).hexdigest()==digest
result=dict(status='Passed',logical_executable_paths=len(bindings),unique_executables=len(unique),
            raw_unique_bytes=sum(p.stat().st_size for p in unique.values()),archive_bytes=destination.stat().st_size,
            archive_sha256=hashlib.sha256(destination.read_bytes()).hexdigest())
(HERE/'executable-preservation.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
