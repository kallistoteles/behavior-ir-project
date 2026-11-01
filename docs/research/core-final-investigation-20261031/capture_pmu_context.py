import hashlib
import json
import re
import shutil
import subprocess
from pathlib import Path

HERE=Path(__file__).resolve().parent
manifest=json.loads((HERE/'pmu-builds.json').read_text());result={}
for arm,metadata in manifest['arms'].items():
    path=Path(metadata['binary'])
    raw=subprocess.check_output(['nm','-n','--defined-only',str(path)],text=True)
    symbols=[]
    for line in raw.splitlines():
        fields=line.split()
        if len(fields)>=3:
            try:address=int(fields[0],16)
            except ValueError:continue
            symbols.append((address,fields[2]))
    index=next(i for i,(address,symbol) in enumerate(symbols) if 'allocation_pmu_probe4main' in symbol)
    start=symbols[index][0];end=next(address for address,symbol in symbols[index+1:] if address>start)
    disassembly=subprocess.check_output(['objdump','-Cd',f'--start-address={start}',f'--stop-address={end}',str(path)],text=True)
    (HERE/f'pmu-{arm}-main.asm').write_text(disassembly)
    names={}
    for line in subprocess.check_output(['nm','-nC','--defined-only',str(path)],text=True).splitlines():
        fields=line.split(maxsplit=2)
        if len(fields)==3:
            try:names[int(fields[0],16)]=fields[2]
            except ValueError:pass
    relocations={}
    for line in subprocess.check_output(['readelf','-rW',str(path)],text=True).splitlines():
        fields=line.split()
        if len(fields)>=4 and fields[2]=='R_X86_64_RELATIVE':relocations[int(fields[0],16)]=int(fields[3],16)
    annotated=[]
    for line in disassembly.splitlines():
        match=re.search(r'# ([0-9a-f]+) <',line)
        if match and int(match.group(1),16) in relocations:
            target=relocations[int(match.group(1),16)]
            line+=f' ; GOT => {target:x} {names.get(target,"unknown")} '
        annotated.append(line)
    (HERE/f'pmu-{arm}-annotated-main.asm').write_text('\n'.join(annotated)+'\n')
    controls=[i for i,line in enumerate(annotated) if 'call' in line and '<allocation_pmu_probe::control>' in line]
    phase='\n'.join(annotated[controls[0]:controls[1]+1])
    assert 'Instant>::now' in phase and 'Instant>::elapsed' in phase and '__rust_alloc' in phase
    calls=[line.strip() for line in phase.splitlines() if 'call' in line]
    result[arm]=dict(binary=str(path),sha256=hashlib.sha256(path.read_bytes()).hexdigest(),main_start=hex(start),main_end=hex(end),
                     main_symbol=symbols[index][1],allocation_window_calls=calls,
                     ldd=subprocess.check_output(['ldd',str(path)],text=True))
lib=Path('/nix/store/lm3pknxi0ipypy3lxh1wmm8wvvavdwrn-glibc-2.42-84/lib/libc.so.6')
notes=subprocess.check_output(['readelf','-n',str(lib)],text=True)
result['libc']=dict(path=str(lib),sha256=hashlib.sha256(lib.read_bytes()).hexdigest(),
                   build_id=re.search(r'Build ID: (\w+)',notes).group(1),
                   allocator_symbols=[line for line in subprocess.check_output(['nm','-an',str(lib)],text=True).splitlines()
                                      if re.search(r' (malloc_consolidate|_int_malloc|sysmalloc|__libc_malloc|malloc)$',line)])
result['tools']={name:shutil.which(name) for name in ['nm','objdump','ldd','readelf']}
(HERE/'pmu-binary-context.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(dict(status='Captured',arms=list(manifest['arms']),libc_build_id=result['libc']['build_id']),indent=2))
