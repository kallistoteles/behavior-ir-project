"""Install asserted, diagnostic-only spans in an isolated guarded-C checkout."""
import hashlib
import json
import re
import sys
from pathlib import Path

root=Path(sys.argv[1]); here=Path(__file__).resolve().parent
files={}; inventory=[]
def read(path):
    if path not in files: files[path]=(root/path).read_text()
    return files[path]
def replace(path,old,new,count=1):
    text=read(path); assert text.count(old)==count,(path,old,text.count(old),count)
    files[path]=text.replace(old,new)
def scope(path,name,label,prefix="crate::eval::work",dynamic=False):
    text=read(path); matches=list(re.finditer(r'\bfn '+re.escape(name)+r'(?:<[^\n]*>)?\(',text))
    assert matches,(path,name)
    expression=f'format!("{label}")' if dynamic else json.dumps(label)
    for match in reversed(matches):
        brace=text.index('{',match.end())+1
        text=text[:brace]+f'\n #[cfg(feature="validation-work")] let _residual_scope={prefix}::profile_scope({expression});\n'+text[brace:]
    files[path]=text; inventory.append(dict(path=path,function=name,label=label,insertions=len(matches)))
def block(prefix,label,expression):
    return '{ #[cfg(feature="validation-work")] let _residual_child='+prefix+'::profile_scope('+json.dumps(label)+'); '+expression+' }'

work='crates/behavior-core/src/eval/work.rs'
text=read(work); marker='// RESIDUAL_PROFILER_SCAFFOLD'
assert marker in text
files[work]=text[:text.index(marker)]+(here/'profiler.rs').read_text()
canonical='crates/behavior-core/src/canonical.rs'
for name in ['decode_strict','to_canonical_string','check_canonical_value']:
    scope(canonical,name,'core::'+name)
for name in ['tagged_hash','tagged_hash_canonical_text']:
    scope(canonical,name,'core::'+name+'[{tag}]',dynamic=True)
expression='serde_json::to_string(v).map_err(|e| CanonicalError::Serialize(e.to_string()))'
replace(canonical,expression,block('crate::eval::work','core::serialize_value',expression))
old='''        let mut value = doc.clone();
        if let Value::Object(object) = &mut value {
            object.remove("hash");
        }'''
new='''        let value = { #[cfg(feature="validation-work")] let _residual_clone=crate::eval::work::profile_scope("core::hash_document_clone");
            let mut value = doc.clone();
            if let Value::Object(object) = &mut value { object.remove("hash"); }
            value
        };'''
replace(canonical,old,new)
record='crates/behavior-core/src/record.rs'
for name in ['from_json','with_profile','with_current_profile','reproduce_record','replay_profile','validate_record08','validate_record07','validate_record07_fields','project_current_record','normalize_current_legacy','compare']:
    scope(record,name,'core::record::'+name)
for typ,error in [('Record08','error'),('Record07','e')]:
    old=f'let record: {typ} =\n        serde::Deserialize::deserialize(raw).map_err(|{error}| record_error({error}.to_string()))?;'
    expr=f'serde::Deserialize::deserialize(raw).map_err(|{error}| record_error({error}.to_string()))?'
    replace(record,old,f'let record: {typ} = '+block('crate::eval::work',typ.lower()+'_typed_decode',expr)+';')
replace(record,'    let common = Record07 {','    #[cfg(feature="validation-work")] let residual_move=crate::eval::work::profile_scope("record08_common_move");\n    let common = Record07 {')
replace(record,'    validate_record07_fields(common)','    #[cfg(feature="validation-work")] drop(residual_move);\n    validate_record07_fields(common)')
expr='first_difference("", &stored, replayed.record().as_json())'
replace(record,expr,block('crate::eval::work','core::record::exact_comparison',expr))
evaluate='crates/behavior-core/src/eval.rs'
for name in ['evaluate_decoded_request','run_transition','run_complete_child_rules','snapshot_universe_json']:
    scope(evaluate,name,'core::eval::'+name)
text=read(evaluate); start=text.index('fn evaluate_decoded_request(')
pos=text.index('    let mut record = Map::new();',start)
files[evaluate]=text[:pos]+'    #[cfg(feature="validation-work")] let residual_header=crate::eval::work::profile_scope("core::eval::record_header_echo");\n'+text[pos:]
replace(evaluate,'    // Binding: distinct state parameters must bind to distinct entity identities (FR-027).','    #[cfg(feature="validation-work")] drop(residual_header);\n    // Binding: distinct state parameters must bind to distinct entity identities (FR-027).')
text=read(evaluate); start=text.index('fn evaluate_decoded_request(')
pos=text.index('    let mut derived = std::mem::take(&mut ev.derived);',start)
assert pos<text.index('fn stored_value(',start)
files[evaluate]=text[:pos]+'    #[cfg(feature="validation-work")] let residual_assembly=crate::eval::work::profile_scope("core::eval::record_assembly");\n'+text[pos:]
old='''    (
        execution.record(module, Json::Object(record), outcome.commands),
        Observed { fields, facts },
    )'''
new='''    let residual_result = (
        execution.record(module, Json::Object(record), outcome.commands),
        Observed { fields, facts },
    );
    #[cfg(feature="validation-work")] drop(residual_assembly);
    residual_result'''
replace(evaluate,old,new)
for name in ['evaluate','run_child_rules','checked_child']:
    scope('crates/behavior-core/src/eval/prepared.rs',name,'core::prepared::'+name)
scope('crates/behavior-core/src/facts.rs','to_json','core::facts::to_json')
documents='crates/behavior-store/src/documents.rs'; prefix='behavior_core::eval::work'
scope(documents,'hash_of','store::documents::hash_of[{tag}]',prefix,True)
scope(documents,'decode','store::documents::decode',prefix)
expr='serde_json::to_value(doc).map_err(|e| StoreError::BundleInvalid(e.to_string()))?'
replace(documents,expr,block(prefix,'store::hash_to_value',expr))
for call,field,label in [('document_hash_calls','hash_document_json_bytes','hash'),('document_decode_calls','document_decode_json_bytes','decode')]:
    old=f'''        w.{call} += 1;
        w.{field} += v.to_string().len();'''
    new=f'''        let _residual_counter={prefix}::profile_scope("diagnostic::{label}_document_bytes");
        w.{call} += 1;
        if {prefix}::profile_count_bytes() {{ w.{field} += v.to_string().len(); }}'''
    replace(documents,old,new)
store='crates/behavior-store/src/store.rs'
for name in ['evaluate','bundle_from_evaluation','commit_impl','head','validate_snapshot','validate_snapshot_full','snapshot_identity','rederive_for','transition_hash']:
    scope(store,name,'store::'+name,prefix)
for name in ['validate_incremental_child_at','carry_incremental_child']:
    scope('crates/behavior-store/src/store/incremental/mod.rs',name,'store::incremental::'+name,prefix)
scope('crates/behavior-store/src/memory.rs','commit','backend::commit',prefix)
for expression,label,count in [('bundle.clone()','store::archive_bundle_clone',1)]:
    old='let mut archived_bundle = '+expression+';'
    replace(store,old,'let mut archived_bundle = '+block(prefix,label,expression)+';',count)
replace(store,'bundle: Some(archived_bundle.clone()),','bundle: Some('+block(prefix,'store::event_bundle_clone','archived_bundle.clone()')+'),')
text=read(store); count=text.count('record: bundle.record.clone(),'); assert count>=1
replace(store,'record: bundle.record.clone(),','record: '+block(prefix,'store::return_record_clone','bundle.record.clone()')+',',count)
text=read(store); count=text.count('&record.to_string(),'); assert count==2
replace(store,'&record.to_string(),','&'+block(prefix,'store::record_to_string','record.to_string()')+',',count)

driver='crates/behavior-store/examples/residual_phase_profile.rs'
text=read(driver)
text=text.replace(' std::fs::create_dir_all(out).unwrap();',' #[cfg(feature="validation-work")] core_api::eval::work::profile_set_byte_counts(std::env::var("CORE_PROFILE_BYTES").as_deref()!=Ok("0"));\n std::fs::create_dir_all(out).unwrap();',1)
for marker,label in [('let evaluated=store.evaluate','phase::evaluate'),('let committed=store.commit','phase::commit'),('let record_bytes=evaluated.record.to_string()','phase::serialization')]:
    assert text.count(marker)==1
    text=text.replace(marker,'#[cfg(feature="validation-work")] let residual_phase=core_api::eval::work::profile_scope("'+label+'");\n '+marker,1)
for marker in ['let evaluate_ms=','let commit_ms=','let serialize_ms=']:
    assert text.count(marker)==1
    text=text.replace(marker,'#[cfg(feature="validation-work")] drop(residual_phase);\n '+marker,1)
files[driver]=text
files[driver]+='''
#[cfg(feature="validation-work")]
fn profile_bytes() -> Json { json!(core_api::eval::work::profile_count_bytes()) }
#[cfg(not(feature="validation-work"))]
fn profile_bytes() -> Json { Json::Null }
'''
files[driver]=files[driver].replace('"n":n,"variant":variant','"profile_bytes":profile_bytes(),"n":n,"variant":variant',1)
for path,text in files.items(): (root/path).write_text(text)
manifest={'functions':inventory,'files':{p:hashlib.sha256(t.encode()).hexdigest() for p,t in files.items()}}
(here/'instrumentation-inventory.json').write_text(json.dumps(manifest,indent=2)+'\n')
print(json.dumps({'instrumented_files':len(files),'function_groups':len(inventory)}))
