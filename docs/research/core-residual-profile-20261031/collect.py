"""Frozen residual scopes and original/parsed serialization campaign."""
import datetime
import hashlib
import json
import os
import platform
import statistics
import sys
from pathlib import Path
from common import controls, digest, retain, run

ORDERS=["blocked","alternating-original","alternating-parsed"]

def schedule(order):
    if order=="blocked": return [("original",i) for i in range(1,9)]+[("parsed",i) for i in range(1,9)]
    plan=[("original",1)]
    for i in range(1,8):
        pair=[("original",i+1),("parsed",i)]
        plan.extend(pair if order=="alternating-original" else reversed(pair))
    return plan+[("parsed",8)]

def validate_partition(spans,root):
    assert spans[root]['calls']==1
    for row in spans.values():
        assert type(row['calls']) is int and row['calls']>=1
        assert type(row['inclusive_ns']) is int and type(row['exclusive_ns']) is int
        assert 0<=row['exclusive_ns']<=row['inclusive_ns']
    assert sum(row['exclusive_ns'] for row in spans.values())==spans[root]['inclusive_ns']

def validate_rounds(row,n,order,expected_sha,expected_bytes):
    assert row['n']==n and row['order']==order and row['diagnostics'] is False
    assert row['record_sha256']==expected_sha and row['record_bytes']==expected_bytes
    rounds=row['rounds']
    assert [(r['object'],r['ordinal']) for r in rounds]==schedule(order)
    for r in rounds:
        assert type(r['elapsed_ns']) is int and r['elapsed_ns']>=0 and r['bytes']==expected_bytes

def require_cases(rows,keys,expected):
    actual=[tuple(row[k] for k in keys) for row in rows]
    if len(actual)!=len(set(actual)) or set(actual)!=set(expected): raise ValueError("incomplete or duplicate corpus")

def main():
    controls(); bins,inputs,out=map(Path,sys.argv[1:]); out.mkdir(exist_ok=False)
    env={"utc":datetime.datetime.now(datetime.timezone.utc).isoformat(),"platform":platform.platform(),
         "python":sys.version,"controller_affinity":sorted(os.sched_getaffinity(0)),"child_cpu":7,
         "child_address_space_limit":8*1024**3,"timeout_seconds":180,
         "binaries":{p.name:digest(p.read_bytes()) for p in sorted(bins.iterdir()) if p.is_file()},
         "input_records":{p.name:digest(p.read_bytes()) for p in sorted(inputs.iterdir()) if p.is_file()}}
    (out/'environment.json').write_text(json.dumps(env,indent=2)+'\n')
    phase_rows=[]; artifacts=[]
    with (out/'phase-samples.jsonl').open('w') as stream:
        modes=['normal','full','count-off']
        for n in [128,512,2048,8192]:
            expected=(inputs/f'{n}.json').read_bytes()
            for repetition in range(3):
                selected=modes[repetition:]+modes[:repetition]
                for mode in selected:
                    path=out/f'raw-phase-{mode}-{n}-{repetition}'
                    binary=bins/('normal-c' if mode=='normal' else 'scoped-c')
                    child_env=dict(os.environ,CORE_PROFILE_BYTES='0' if mode=='count-off' else '1')
                    row,process_ms=run([str(binary),str(n),'1','original',str(path)],out/'attempts.jsonl',child_env)
                    assert (row['n'],row['variant'],row['repetition'])==(n,'original',0)
                    if mode=='normal':
                        assert row['mode']=='uninstrumented'
                        assert all(row[p] is None for p in ['evaluate','commit','serialization'])
                    else:
                        assert row['mode']=='instrumented' and row['profile_bytes']==(mode=='full')
                        for phase in ['evaluate','commit','serialization']:
                            validate_partition(row[phase]['spans'],f'phase::{phase}')
                            if mode=='count-off':
                                assert row[phase]['work']['hash_document_json_bytes']==0
                                assert row[phase]['work']['document_decode_json_bytes']==0
                        assert row['commit']['spans']['core::record::validate_record07_fields']['calls']>=1
                        assert row['commit']['spans']['record08_typed_decode']['calls']>=1
                        assert row['commit']['work']['document_hash_calls']>=1
                    raw=Path(row['record_path']).read_bytes(); assert raw==expected and row['record_bytes']==len(raw)
                    if repetition==0: artifacts.append(retain(out/f'phase-{mode}-{n}.json.gz',raw))
                    Path(row['record_path']).unlink(); path.rmdir()
                    row.pop('record_path'); row.update(profile_mode=mode,repetition=repetition,process_ms=process_ms,record_sha256=digest(raw))
                    phase_rows.append(row); stream.write(json.dumps(row)+'\n'); stream.flush()
                    print(json.dumps({'stage':'profile','n':n,'repetition':repetition,'mode':mode}),flush=True)
    require_cases(phase_rows,['n','repetition','profile_mode'],[(n,r,m) for n in [128,512,2048,8192] for r in range(3) for m in modes])
    # Diagnostic-only byte counting must not alter semantic call/row counts.
    for n in [128,512,2048,8192]:
        for phase in ['evaluate','commit','serialization']:
            counts=[]
            for row in phase_rows:
                if row['n']==n and row['profile_mode']!='normal':
                    count=dict(row[phase]['work']); count.pop('hash_document_json_bytes');count.pop('document_decode_json_bytes');counts.append(count)
            assert all(c==counts[0] for c in counts)
    serial_rows=[]
    with (out/'serialization-samples.jsonl').open('w') as stream:
        for n in [128,512]:
            expected=(inputs/f'{n}.json').read_bytes()
            for order in ORDERS:
                for repetition in range(10):
                    for arm in (['a','c'] if repetition%2==0 else ['c','a']):
                        path=out/f'raw-serialize-{n}-{order}-{repetition}-{arm}.json'
                        row,process_ms=run([str(bins/f'{arm}-serialize'),str(n),order,str(inputs/f'{n}.json'),str(path)],out/'attempts.jsonl')
                        validate_rounds(row,n,order,digest(expected),len(expected))
                        raw=path.read_bytes(); assert raw==expected
                        if repetition==0: artifacts.append(retain(out/f'serialize-{n}-{order}-{arm}.json.gz',raw))
                        path.unlink(); row.update(arm=arm,repetition=repetition,process_ms=process_ms)
                        serial_rows.append(row); stream.write(json.dumps(row)+'\n');stream.flush()
                    print(json.dumps({'stage':'serialization','n':n,'order':order,'repetition':repetition}),flush=True)
    require_cases(serial_rows,['n','order','repetition','arm'],[(n,o,r,a) for n in [128,512] for o in ORDERS for r in range(10) for a in ['a','c']])
    result={'status':'Complete','phase_attempts':len(phase_rows),'serialization_attempts':len(serial_rows),
            'normative_bytes_equal':True,'artifacts':artifacts}
    (out/'assessment.json').write_text(json.dumps(result,indent=2)+'\n')

if __name__=='__main__':
    existed=len(sys.argv)==4 and Path(sys.argv[3]).exists()
    try: main()
    except BaseException as error:
        if len(sys.argv)==4 and not existed and Path(sys.argv[3]).is_dir():
            out=Path(sys.argv[3]); (out/'failure.json').write_text(json.dumps({'status':'Failed' if isinstance(error,Exception) else 'Interrupted','error':repr(error),'declared_phase_attempts':36,'declared_serialization_attempts':120},indent=2)+'\n')
        raise
