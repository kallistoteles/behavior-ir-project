//! Decision records and replay (research R14; contracts/engine-api.md).
//!
//! A record is self-contained: it holds the request as evaluated, so it can be replayed and
//! audited without the source. It never contains timestamps or host data.

/// Closed semantic command decision format.
pub const RECORD_VERSION_COMMANDS: &str = "0.7";
pub(crate) const RECORD_VERSION_CURRENT: &str = "0.8";
pub(crate) const VALIDATION_PROFILE_CURRENT: &str = "behavior.complete_resulting_state.v1";
use serde::Serialize;
use serde_json::{Value as Json, json};

use crate::semantic::module::Module;

#[derive(Debug, Clone)]
pub struct DecisionRecord {
    json: Json,
    diagnostics: Json,
    commands: crate::commands::CommandIntentBag,
}

impl DecisionRecord {
    /// Decode the closed new-profile record form; this validates claims, not
    /// whether a live store actually performed the claimed evaluation.
    pub fn from_json(text: &str) -> Result<Self, RecordError> {
        #[cfg(feature = "validation-work")]
        crate::eval::work::note(|w| {
            w.record_parse_calls += 1;
            w.record_parse_bytes += text.len();
        });
        let json =
            crate::canonical::decode_strict(text).map_err(|e| record_error(e.to_string()))?;
        let commands = match json.get("record_version").and_then(Json::as_str) {
            Some(RECORD_VERSION_COMMANDS) => validate_record07(&json)?,
            Some(RECORD_VERSION_CURRENT) => validate_record08(&json)?,
            _ => return Err(record_error("unsupported decision record version")),
        };
        Ok(Self {
            json,
            commands,
            diagnostics: Json::Null,
        })
    }
    pub(crate) fn new(json: Json) -> Self {
        DecisionRecord {
            json,
            diagnostics: Json::Null,
            commands: crate::commands::CommandIntentBag::default(),
        }
    }

    pub(crate) fn with_profile(
        module: &Module,
        mut json: Json,
        mut commands: crate::commands::CommandIntentBag,
    ) -> Self {
        if module.semantic_profile() == crate::semantic::types::SemanticProfile::Legacy {
            return Self::new(json);
        }
        let diagnostics =
            json!({"trace":json["trace"],"reasons":json["reasons"],"derived":json["derived"]});
        let archive = match crate::commands::archive(module, &commands) {
            Ok(archive) => archive,
            Err(error) => {
                json["result"] = json!("ERROR");
                json["changes"] = json!([]);
                json.as_object_mut().map(|o| o.remove("lifecycle"));
                json["reasons"] = json!([{"code":error.code}]);
                commands = crate::commands::CommandIntentBag::default();
                json!({"declarations":[],"types":[],"intents":[]})
            }
        };
        json["record_version"] = json!(RECORD_VERSION_COMMANDS);
        json["semantic_profile"] = json!("0.8");
        json["commands"] = archive;
        let mut read_keys = std::collections::BTreeMap::new();
        for d in module.derived_items().values() {
            collect_read_keys(d.body(), &mut read_keys);
        }
        for (name, d) in module.derived_items() {
            read_keys.insert(
                name.clone(),
                format!("derived:{}", crate::semantic::types::hash_display(d.hash())),
            );
        }
        if let Some(action) = json["action"]["name"]
            .as_str()
            .and_then(|n| module.action(n))
        {
            for c in action.preconditions().iter().chain(action.postconditions()) {
                collect_read_keys(c.expr(), &mut read_keys);
            }
            for e in action.effects() {
                collect_read_keys(e.value(), &mut read_keys);
            }
            for c in action.command_emissions() {
                collect_read_keys(c.guard(), &mut read_keys);
                for (_, v) in c.payload() {
                    collect_read_keys(v, &mut read_keys);
                }
            }
            for c in action.creates() {
                collect_read_keys(c.id(), &mut read_keys);
                for (_, e) in c.fields() {
                    collect_read_keys(e, &mut read_keys);
                }
            }
        }
        for r in module.invariants().values() {
            collect_read_keys(r.body(), &mut read_keys);
        }
        for r in module.global_invariants().values() {
            collect_read_keys(r.body(), &mut read_keys);
        }
        for r in module.constraints().values() {
            collect_read_keys(r.body(), &mut read_keys);
        }
        let failure = json["reasons"]
            .as_array()
            .and_then(|a| a.iter().find_map(|r| r.get("details")))
            .cloned();
        for section in ["reasons", "trace", "derived"] {
            if let Some(entries) = json[section].as_array_mut() {
                for entry in entries {
                    semantic_evidence(entry, &read_keys, failure.as_ref());
                    if let Some(o) = entry.as_object_mut() {
                        o.remove("name");
                    }
                }
            }
        }
        if let Some(entries) = json["derived"].as_array_mut() {
            entries.sort_by_key(Json::to_string);
        }
        Self {
            json,
            diagnostics,
            commands,
        }
    }

    /// Fresh action evidence has its own validation profile, independent of
    /// the admitted module's command-language profile.
    pub(crate) fn with_current_profile(
        module: &Module,
        json: Json,
        commands: crate::commands::CommandIntentBag,
    ) -> Self {
        let mut record = Self::with_profile(module, json, commands);
        if module.semantic_profile() == crate::semantic::types::SemanticProfile::Legacy {
            record.diagnostics = json!({
                "trace": record.json["trace"],
                "reasons": record.json["reasons"],
                "derived": record.json["derived"]
            });
            normalize_current_legacy(module, &mut record.json);
        }
        record.json["record_version"] = json!(RECORD_VERSION_CURRENT);
        record.json["validation_profile"] = json!(VALIDATION_PROFILE_CURRENT);
        record
    }

    pub fn diagnostics(&self) -> &Json {
        &self.diagnostics
    }
    pub fn command_intents(&self) -> &crate::commands::CommandIntentBag {
        &self.commands
    }

    /// `ALLOW`, `DENY`, `ERROR`, `INVALID_INPUT`, or `INVALID_STATE`.
    pub fn result(&self) -> &str {
        self.json["result"].as_str().unwrap_or("ERROR")
    }

    pub fn as_json(&self) -> &Json {
        &self.json
    }

    pub(crate) fn into_json(self) -> Json {
        self.json
    }

    /// Canonical JSON. Records hold no floats (invalid input is sanitized), so this cannot fail.
    pub fn to_json_string(&self) -> String {
        self.json.to_string()
    }
}

#[derive(Debug, Clone, PartialEq, Eq, thiserror::Error)]
#[error("{code}: {message}")]
pub struct RecordError {
    pub code: &'static str,
    pub message: String,
}

/// Errors of the bounded Core-to-Store replay integration. Replay diagnostics
/// render these only after reproduction has finished; causes remain available
/// to callers through `std::error::Error::source`.
#[doc(hidden)]
#[derive(Debug, thiserror::Error)]
pub enum ReplayError {
    #[error("{0}")]
    InvalidRecord(String),
    #[error("{scope}: different module")]
    ModuleMismatch { scope: &'static str },
    #[error("{scope}: different module representation")]
    ModuleRepresentationMismatch { scope: &'static str },
    #[error("{0}")]
    Canonical(#[from] crate::canonical::CanonicalError),
    #[error("{0}")]
    Invocation(#[from] crate::invocation::TransportError),
    #[error("record is not valid JSON: {0}")]
    ReadJson(#[source] crate::canonical::CanonicalError),
    #[error("binding_facts: {0}")]
    BindingFacts(#[source] serde_json::Error),
    #[error("read.definition: not admitted ({})", .0.errors.iter().map(|e| e.code.as_str()).collect::<Vec<_>>().join(", "))]
    ReadDefinition(crate::admit::AdmissionResult),
    #[error("outcome.record.facts: {}", .0.message)]
    Facts(#[source] crate::facts::FactsProblem),
    #[error("outcome.record.{}", .0.message)]
    Decision(#[source] RecordError),
    #[error("{}", .0.join("; "))]
    EntityValue(Vec<String>),
    #[error("{}", .0.message)]
    QueryClaim(#[source] crate::facts::FactsProblem),
    #[error("{path}: {source}")]
    Evidence {
        path: String,
        #[source]
        source: Box<Self>,
    },
    #[error("unsupported read record format/profile")]
    ReadProfile {
        #[source]
        source: Box<Self>,
    },
}

impl From<String> for ReplayError {
    fn from(message: String) -> Self {
        Self::InvalidRecord(message)
    }
}

impl From<&str> for ReplayError {
    fn from(message: &str) -> Self {
        Self::InvalidRecord(message.into())
    }
}

#[derive(Debug, Clone, Serialize)]
pub struct ReplayResult {
    pub matches: bool,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub diff: Option<String>,
}

impl ReplayResult {
    /// A replay that did not reproduce the record, with the first difference.
    pub fn mismatch(diff: String) -> Self {
        ReplayResult {
            matches: false,
            diff: Some(diff),
        }
    }

    pub fn to_json_string(&self) -> String {
        let mut fields = serde_json::Map::new();
        fields.insert("matches".into(), Json::Bool(self.matches));
        if let Some(diff) = &self.diff {
            fields.insert("diff".into(), Json::String(diff.clone()));
        }
        Json::Object(fields).to_string()
    }
}

/// Compares a stored record with its replay (feature 010 shares this with read records).
pub fn compare(stored: &Json, replayed: &Json) -> ReplayResult {
    match first_difference("", stored, replayed) {
        None => ReplayResult {
            matches: true,
            diff: None,
        },
        Some(d) => ReplayResult::mismatch(d),
    }
}

/// First differing JSON path between the stored record and the replayed one.
fn first_difference(path: &str, stored: &Json, replayed: &Json) -> Option<String> {
    match (stored, replayed) {
        (Json::Object(a), Json::Object(b)) => {
            let mut keys: Vec<&String> = a.keys().chain(b.keys()).collect();
            keys.sort();
            keys.dedup();
            keys.into_iter().find_map(|k| {
                let p = if path.is_empty() {
                    k.clone()
                } else {
                    format!("{path}.{k}")
                };
                match (a.get(k), b.get(k)) {
                    (Some(x), Some(y)) => first_difference(&p, x, y),
                    (x, y) => Some(format!(
                        "{p}: record has {}, replay has {}",
                        x.map_or("nothing".into(), Json::to_string),
                        y.map_or("nothing".into(), Json::to_string)
                    )),
                }
            })
        }
        (Json::Array(a), Json::Array(b)) => {
            for i in 0..a.len().max(b.len()) {
                let p = format!("{path}[{i}]");
                match (a.get(i), b.get(i)) {
                    (Some(x), Some(y)) => {
                        if let Some(d) = first_difference(&p, x, y) {
                            return Some(d);
                        }
                    }
                    (x, y) => {
                        return Some(format!(
                            "{p}: record has {}, replay has {}",
                            x.map_or("nothing".into(), Json::to_string),
                            y.map_or("nothing".into(), Json::to_string)
                        ));
                    }
                }
            }
            None
        }
        (a, b) if a == b => None,
        (a, b) => Some(format!("{path}: record has {a}, replay has {b}")),
    }
}

/// Re-evaluates the request stored in `record` and compares the outcome byte for byte.
pub fn replay(module: &Module, record: &str) -> ReplayResult {
    match reproduce_record(module, record, None, None, None) {
        Ok(_) => ReplayResult {
            matches: true,
            diff: None,
        },
        Err(error) => ReplayResult::mismatch(error.to_string()),
    }
}

/// Internal Core/Store replay bridge. Execution is selected exclusively by
/// validated immutable evidence, never by a caller-selected strategy. The
/// provider supplies actual historical facts; recorded facts are not trusted
/// as the provider's inputs. Return observations only after exact reproduction.
/// This function is deliberately absent from the behavior-engine facade.
pub fn reproduce_observed_with(
    module: &Module,
    record: &str,
    provider: &dyn crate::EvaluationFacts,
) -> Result<(DecisionRecord, crate::Observed), RecordError> {
    reproduce_record(module, record, Some(provider), None, None).map(Reproduced::into_parts)
}

/// Invocation replay evaluates its resolved outer request under the profile
/// selected by the immutable inner record. Existing typed decoding establishes
/// agreement after canonical normalization, including invalid-input evidence.
/// Exact record comparison prevents an envelope from substituting semantic
/// inputs while keeping an otherwise authentic inner computation.
pub(crate) fn reproduce_requested_with(
    module: &Module,
    record: &str,
    request: &Json,
    provider: &dyn crate::EvaluationFacts,
) -> Result<(DecisionRecord, crate::Observed), RecordError> {
    reproduce_record(module, record, Some(provider), Some(request), None)
        .map(Reproduced::into_parts)
}

struct PreparedReplay<'a> {
    parent: &'a crate::eval::prepared::PreparedSnapshot,
    hint: Option<&'a crate::eval::prepared::CheckedEvaluation>,
}
/// Reproduce against engine-owned complete-state evidence. The optional hint is
/// usable only at its exact private parent epoch and for the same request. The
/// untrusted record still undergoes all profile and exact comparison checks.
#[doc(hidden)]
pub fn reproduce_prepared(
    module: &Module,
    record: &str,
    provider: &dyn crate::EvaluationFacts,
    parent: &crate::eval::prepared::PreparedSnapshot,
    hint: Option<&crate::eval::prepared::CheckedEvaluation>,
) -> Result<crate::eval::prepared::CheckedEvaluation, RecordError> {
    let replay = PreparedReplay { parent, hint };
    match reproduce_record(module, record, Some(provider), None, Some(&replay))? {
        Reproduced::Checked(checked) => Ok(checked),
        Reproduced::Ordinary(_) => Err(record_error(
            "prepared reproduction requires the current profile",
        )),
    }
}

// Ordinary replay keeps ownership of its actual result. Prepared replay borrows
// the immutable checked execution for the complete comparison; it does not copy
// an entire record merely to retain and then discard reuse evidence.
enum Reproduced {
    Ordinary(Box<(DecisionRecord, crate::Observed)>),
    Checked(crate::eval::prepared::CheckedEvaluation),
}
impl Reproduced {
    fn ordinary(pair: (DecisionRecord, crate::Observed)) -> Self {
        Self::Ordinary(Box::new(pair))
    }
    fn record(&self) -> &DecisionRecord {
        match self {
            Self::Ordinary(pair) => &pair.0,
            Self::Checked(checked) => checked.record(),
        }
    }
    fn into_parts(self) -> (DecisionRecord, crate::Observed) {
        match self {
            Self::Ordinary(pair) => *pair,
            Self::Checked(checked) => (checked.record().clone(), checked.observed().clone()),
        }
    }
}

fn reproduce_record(
    module: &Module,
    record: &str,
    provider: Option<&dyn crate::EvaluationFacts>,
    requested: Option<&Json>,
    prepared: Option<&PreparedReplay<'_>>,
) -> Result<Reproduced, RecordError> {
    let stored: Json = crate::canonical::decode_strict(record)
        .map_err(|e| record_error(format!("record is not valid JSON: {e}")))?;
    let execution = replay_profile(module, &stored)?;
    let version = module.behavior_version();
    if stored["behavior_version"] != json!(version) {
        return Err(record_error(format!(
            "behavior_version: record has {}, module is \"{version}\"",
            stored["behavior_version"]
        )));
    }
    let mut request = requested.cloned().unwrap_or_else(|| {
        json!({
            "action": stored["action"]["name"],
            "data_version": stored["data_version"],
            "state": stored["state"],
            "input": stored["input"],
            "context": stored["context"],
        })
    });
    if requested.is_none()
        && let (Some(g), Json::Object(m)) = (stored.get("git_revision"), &mut request)
    {
        m.insert("git_revision".into(), g.clone());
    }
    // Standalone replay uses only recorded observations. Provider-backed
    // reproduction must instead establish them at the actual historical state.
    if provider.is_none()
        && let (Some(f), Json::Object(m)) = (stored.get("facts"), &mut request)
    {
        m.insert("facts".into(), f.clone());
    }
    if provider.is_some() && requested.is_none() && stored.get("refused_request").is_some() {
        return Err(record_error(
            "refused_request requires standalone captured-input replay",
        ));
    }
    let request_text = if execution == RecordExecution::Current && provider.is_none() {
        stored
            .get("refused_request")
            .and_then(Json::as_str)
            .map(str::to_owned)
            .unwrap_or_else(|| request.to_string())
    } else {
        request.to_string()
    };
    let replayed = match (execution, provider) {
        (RecordExecution::Current, Some(provider)) => {
            if let Some(replay) = prepared {
                let checked = match replay
                    .hint
                    .filter(|h| h.matches(module, &request_text, replay.parent))
                {
                    Some(hint) => hint.clone(),
                    None => replay.parent.evaluate(module, &request_text, provider),
                };
                Reproduced::Checked(checked)
            } else {
                Reproduced::ordinary(crate::eval::evaluate_with(module, &request_text, provider))
            }
        }
        (RecordExecution::Current, None) => {
            let (record, fields) = crate::eval::evaluate_observed(module, &request_text);
            // Standalone replay exposes only the exact record comparison.
            // Provider-backed callers above receive the actual full observer.
            Reproduced::ordinary((
                record,
                crate::Observed {
                    fields,
                    ..crate::Observed::default()
                },
            ))
        }
        (RecordExecution::Archived, provider) => Reproduced::ordinary(
            crate::eval::evaluate_archived(module, &request_text, provider),
        ),
    };
    match first_difference("", &stored, replayed.record().as_json()) {
        None => Ok(replayed),
        Some(d) => Err(record_error(d)),
    }
}

/// Historical reproduction is selected by validated immutable evidence, never
/// by an invocation option or by the module's language version alone.
#[derive(Clone, Copy, PartialEq, Eq)]
enum RecordExecution {
    Current,
    Archived,
}

fn replay_profile(module: &Module, stored: &Json) -> Result<RecordExecution, RecordError> {
    use crate::semantic::types::SemanticProfile;
    let command_module = module.semantic_profile() == SemanticProfile::CommandIntents;
    match stored.get("record_version").and_then(Json::as_str) {
        Some(RECORD_VERSION_CURRENT) => {
            // reproduce_record already strictly decoded this immutable value.
            // Retain every typed/profile check without a second text round trip.
            validate_record08(stored)?;
            if command_module != stored.get("semantic_profile").is_some() {
                return Err(record_error("record/module profile mismatch"));
            }
            Ok(RecordExecution::Current)
        }
        Some(RECORD_VERSION_COMMANDS) if command_module => {
            validate_record07(stored)?;
            Ok(RecordExecution::Archived)
        }
        Some("0.4" | "0.5" | "0.6") if !command_module => {
            if [
                "validation_profile",
                "semantic_profile",
                "commands",
                "refused_request",
            ]
            .iter()
            .any(|key| stored.get(*key).is_some())
            {
                return Err(record_error("conflicting historical record profile"));
            }
            Ok(RecordExecution::Archived)
        }
        _ => Err(record_error("unsupported record/module profile pair")),
    }
}

fn collect_read_keys(
    expression: &crate::semantic::expr::Expr,
    keys: &mut std::collections::BTreeMap<String, String>,
) {
    use crate::semantic::expr::ExprKind;
    match expression.kind() {
        ExprKind::Count(_)
        | ExprKind::Fold { .. }
        | ExprKind::Exists(_)
        | ExprKind::Referenced(_) => {
            keys.insert(
                crate::pretty::text(expression),
                format!(
                    "node:{}",
                    crate::semantic::types::hash_display(expression.hash())
                ),
            );
        }
        _ => {}
    }
    for child in expression.children() {
        collect_read_keys(child, keys);
    }
}

/// Legacy-language current records use the same evidence primitives as command
/// records, without changing their frozen historical constructor.
fn normalize_current_legacy(module: &Module, json: &mut Json) {
    let mut read_keys = std::collections::BTreeMap::new();
    for (name, item) in module.derived_items() {
        collect_read_keys(item.body(), &mut read_keys);
        read_keys.insert(
            name.clone(),
            format!(
                "derived:{}",
                crate::semantic::types::hash_display(item.hash())
            ),
        );
    }
    if let Some(action) = json["action"]["name"]
        .as_str()
        .and_then(|name| module.action(name))
    {
        for condition in action.preconditions().iter().chain(action.postconditions()) {
            collect_read_keys(condition.expr(), &mut read_keys);
        }
        for effect in action.effects() {
            collect_read_keys(effect.value(), &mut read_keys);
        }
        for creation in action.creates() {
            collect_read_keys(creation.id(), &mut read_keys);
            for (_, expression) in creation.fields() {
                collect_read_keys(expression, &mut read_keys);
            }
        }
    }
    for rule in module.invariants().values() {
        collect_read_keys(rule.body(), &mut read_keys);
    }
    for rule in module.global_invariants().values() {
        collect_read_keys(rule.body(), &mut read_keys);
    }
    for rule in module.constraints().values() {
        collect_read_keys(rule.body(), &mut read_keys);
    }
    let failure = json["reasons"]
        .as_array()
        .and_then(|reasons| reasons.iter().find_map(|reason| reason.get("details")))
        .cloned();
    for section in ["reasons", "trace", "derived"] {
        if let Some(entries) = json[section].as_array_mut() {
            for entry in entries {
                semantic_evidence(entry, &read_keys, failure.as_ref());
                if let Some(object) = entry.as_object_mut() {
                    // The nested obligation name identifies a semantic declaration.
                    object.remove("name");
                }
            }
        }
    }
    if let Some(entries) = json["derived"].as_array_mut() {
        entries.sort_by_key(Json::to_string);
    }
}
fn semantic_evidence(
    value: &mut Json,
    read_keys: &std::collections::BTreeMap<String, String>,
    failure: Option<&Json>,
) {
    match value {
        Json::Object(object) => {
            for key in ["loc", "expr_text", "message", "rescale"] {
                object.remove(key);
            }
            if let Some(Json::Object(reads)) = object.get_mut("reads") {
                *reads = std::mem::take(reads)
                    .into_iter()
                    .map(|(key, value)| (read_keys.get(&key).cloned().unwrap_or(key), value))
                    .collect();
            }
            if let Some(Json::String(_)) = object.get("error") {
                object.insert(
                    "error".into(),
                    failure
                        .cloned()
                        .unwrap_or_else(|| json!({"code":"EVALUATION_ERROR"})),
                );
            }
            // Values and operand products are domain data, even when a field
            // happens to be named "loc" or "message". Only evidence metadata
            // is detached.
            if let Some(Json::Object(outcome)) = object.get_mut("outcome")
                && matches!(outcome.get("error"), Some(Json::String(_)))
            {
                outcome.insert(
                    "error".into(),
                    failure
                        .cloned()
                        .unwrap_or_else(|| json!({"code":"EVALUATION_ERROR"})),
                );
            }
            if let Some(Json::Array(rescales)) = object.get_mut("rescales") {
                for entry in rescales {
                    if let Some(o) = entry.as_object_mut() {
                        o.remove("rescale");
                    }
                }
            }
        }
        Json::Array(array) => array
            .iter_mut()
            .for_each(|v| semantic_evidence(v, read_keys, failure)),
        _ => {}
    }
}

// Closed semantic record bodies. Domain values remain JSON because historical
// entity schemas are a store concern; command products carry their own types.
#[derive(serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct Record07 {
    record_version: String,
    semantic_profile: String,
    behavior_version: String,
    data_version: String,
    #[serde(default)]
    git_revision: Option<String>,
    action: RecordAction,
    state: serde_json::Map<String, Json>,
    input: serde_json::Map<String, Json>,
    context: serde_json::Map<String, Json>,
    #[serde(default)]
    facts: Option<Json>,
    result: String,
    reasons: Vec<SemanticReason>,
    trace: Vec<SemanticTrace>,
    derived: Vec<SemanticDerived>,
    changes: Vec<SemanticChange>,
    #[serde(default)]
    lifecycle: Vec<SemanticLifecycle>,
    commands: Json,
}

/// Closed current evidence is checked before projecting its common fields into
/// the frozen command-record validator. Projection is never a permissive parse.
#[derive(serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct Record08 {
    record_version: String,
    validation_profile: String,
    #[serde(default)]
    semantic_profile: Option<String>,
    behavior_version: String,
    data_version: String,
    #[serde(default)]
    git_revision: Option<String>,
    action: RecordAction,
    state: serde_json::Map<String, Json>,
    input: serde_json::Map<String, Json>,
    context: serde_json::Map<String, Json>,
    #[serde(default)]
    facts: Option<Json>,
    result: String,
    reasons: Vec<SemanticReason>,
    trace: Vec<CurrentTrace>,
    derived: Vec<SemanticDerived>,
    changes: Vec<SemanticChange>,
    #[serde(default)]
    lifecycle: Vec<SemanticLifecycle>,
    #[serde(default)]
    commands: Option<Json>,
    #[serde(default)]
    refused_request: Option<String>,
}

#[derive(serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct CurrentTrace {
    phase: String,
    hash: String,
    reads: serde_json::Map<String, Json>,
    outcome: Json,
    #[serde(default)]
    param: Option<String>,
    #[serde(default)]
    role: Option<String>,
    #[serde(default)]
    rescales: Vec<SemanticRescale>,
    #[serde(default)]
    emission: Option<String>,
    #[serde(default)]
    canonical_index: Option<u32>,
    #[serde(default)]
    field: Option<String>,
    #[serde(default)]
    subject: Option<ChildSubject>,
    #[serde(default)]
    obligation: Option<ChildObligation>,
    #[serde(default)]
    observations: Option<Vec<ChildObservation>>,
}

#[derive(serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct ChildSubject {
    entity: String,
    id: String,
}

#[derive(Clone, Copy, PartialEq, Eq, serde::Deserialize)]
#[serde(rename_all = "snake_case")]
enum ObligationKind {
    Invariant,
    Constraint,
}

#[derive(serde::Deserialize)]
#[serde(tag = "source", rename_all = "snake_case", deny_unknown_fields)]
enum ChildObligation {
    Declared {
        kind: ObligationKind,
        name: String,
        hash: String,
    },
    SynthesizedReference {
        kind: ObligationKind,
        entity_declaration: String,
        field: String,
        hash: String,
    },
}

#[derive(serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct ChildObservation {
    field: String,
    phase_state: String,
    value: Json,
}
#[derive(serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct RecordAction {
    name: String,
    #[serde(default)]
    hash: Option<String>,
}
#[derive(serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct SemanticReason {
    code: String,
    #[serde(default)]
    path: Option<String>,
    #[serde(default)]
    details: Option<SemanticFailure>,
    #[serde(default)]
    references: Vec<SemanticReference>,
}
#[derive(serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct SemanticReference {
    entity: String,
    id: String,
    field: String,
}
#[derive(serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct SemanticFailure {
    code: String,
    node: String,
    operands: Vec<SemanticOperand>,
}
#[derive(serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct SemanticOperand {
    node: String,
    value: Json,
}
#[derive(serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct SemanticTrace {
    phase: String,
    hash: String,
    reads: serde_json::Map<String, Json>,
    outcome: Json,
    #[serde(default)]
    param: Option<String>,
    #[serde(default)]
    role: Option<String>,
    #[serde(default)]
    rescales: Vec<SemanticRescale>,
    #[serde(default)]
    emission: Option<String>,
    #[serde(default)]
    canonical_index: Option<u32>,
    #[serde(default)]
    field: Option<String>,
}
#[derive(serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct SemanticRescale {
    exact: String,
    rounding: String,
    scale: u8,
    result: String,
}
#[derive(serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct SemanticDerived {
    hash: String,
    phase_state: String,
    value: Json,
}
#[derive(serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct SemanticChange {
    entity: String,
    id: String,
    param: String,
    field: String,
    old: Json,
    new: Json,
}
#[derive(serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct SemanticLifecycle {
    op: String,
    entity: String,
    id: String,
    value: Json,
}
fn record_error(message: impl Into<String>) -> RecordError {
    RecordError {
        code: "INVALID_DECISION_RECORD",
        message: message.into(),
    }
}
fn record_hash(value: &str) -> Result<(), RecordError> {
    crate::commands::parse_hash(value)
        .map(|_| ())
        .map_err(|e| record_error(e.to_string()))
}
fn record_failure(failure: &SemanticFailure) -> Result<(), RecordError> {
    if failure.code.is_empty() {
        return Err(record_error("empty error code"));
    }
    record_hash(&failure.node)?;
    for operand in &failure.operands {
        record_hash(&operand.node)?;
        crate::canonical::to_canonical_string(&operand.value)
            .map_err(|e| record_error(e.to_string()))?;
    }
    Ok(())
}

pub(crate) fn validate_semantic_failure(value: &Json) -> Result<(), String> {
    let failure: SemanticFailure =
        serde_json::from_value(value.clone()).map_err(|e| e.to_string())?;
    record_failure(&failure).map_err(|e| e.to_string())
}
fn trace_outcome(step: &SemanticTrace) -> Result<(), RecordError> {
    let command = matches!(step.phase.as_str(), "command_guard" | "command_payload");
    if command != (step.emission.is_some() && step.canonical_index.is_some())
        || (!command && (step.emission.is_some() || step.canonical_index.is_some()))
        || (step.phase == "command_payload") != step.field.is_some()
    {
        return Err(record_error("invalid command trace site"));
    }
    if step.outcome.get("error").is_some() {
        let object = step
            .outcome
            .as_object()
            .ok_or_else(|| record_error("invalid trace outcome"))?;
        if object.len() != 1 {
            return Err(record_error("unknown trace error field"));
        }
        let failure: SemanticFailure = serde_json::from_value(object["error"].clone())
            .map_err(|e| record_error(e.to_string()))?;
        return record_failure(&failure);
    }
    let key = match step.phase.as_str() {
        "effect" => Some("assigned"),
        "create" => Some("created"),
        "remove" => Some("removed"),
        "command_payload" => Some("value"),
        _ => None,
    };
    if let Some(key) = key {
        let object = step
            .outcome
            .as_object()
            .ok_or_else(|| record_error("invalid trace value outcome"))?;
        if object.len() != 1 || !object.contains_key(key) {
            return Err(record_error("unknown trace value field"));
        }
        if matches!(key, "created" | "removed") {
            let value = object[key]
                .as_object()
                .ok_or_else(|| record_error("invalid lifecycle trace identity"))?;
            if value.len() != 2
                || value
                    .get("entity")
                    .and_then(Json::as_str)
                    .is_none_or(str::is_empty)
                || value.get("id").and_then(Json::as_str).is_none()
            {
                return Err(record_error("invalid lifecycle trace identity"));
            }
        }
    } else if !step.outcome.is_boolean()
        && !(step.phase != "command_guard" && step.outcome == json!("skipped"))
    {
        return Err(record_error("invalid predicate outcome"));
    }
    Ok(())
}

fn record_identifier(value: &str) -> Result<(), RecordError> {
    let mut bytes = value.bytes();
    if !bytes
        .next()
        .is_some_and(|byte| byte.is_ascii_alphabetic() || byte == b'_')
        || !bytes.all(|byte| byte.is_ascii_alphanumeric() || byte == b'_')
    {
        return Err(record_error("invalid semantic declaration identifier"));
    }
    Ok(())
}

fn reject_null_fields(raw: &Json, fields: &[&str]) -> Result<(), RecordError> {
    if fields
        .iter()
        .any(|field| raw.get(*field).is_some_and(Json::is_null))
    {
        return Err(record_error("null is not an omitted evidence field"));
    }
    Ok(())
}

fn validate_record08(raw: &Json) -> Result<crate::commands::CommandIntentBag, RecordError> {
    let record: Record08 =
        serde_json::from_value(raw.clone()).map_err(|error| record_error(error.to_string()))?;
    if record.record_version != RECORD_VERSION_CURRENT
        || record.validation_profile != VALIDATION_PROFILE_CURRENT
    {
        return Err(record_error("unsupported record/validation profile pair"));
    }
    reject_null_fields(
        raw,
        &[
            "semantic_profile",
            "commands",
            "git_revision",
            "refused_request",
        ],
    )?;
    match (&record.semantic_profile, &record.commands) {
        (Some(profile), Some(_)) if profile == "0.8" => {}
        (None, None) => {}
        _ => {
            return Err(record_error(
                "invalid command-language profile/archive pair",
            ));
        }
    }
    if record.result != "INVALID_INPUT"
        && record
            .facts
            .as_ref()
            .and_then(|facts| facts.get("universe"))
            .and_then(Json::as_array)
            .is_none()
    {
        return Err(record_error(
            "current evaluation has no complete parent universe",
        ));
    }
    if record.refused_request.is_some()
        && (record.result != "INVALID_INPUT"
            || !record.trace.is_empty()
            || !record.derived.is_empty()
            || !record.changes.is_empty()
            || !record.lifecycle.is_empty())
    {
        return Err(record_error(
            "refused input text conflicts with body evidence",
        ));
    }
    reject_null_fields(&raw["action"], &["hash"])?;
    for reason in raw["reasons"].as_array().into_iter().flatten() {
        reject_null_fields(reason, &["path", "details"])?;
    }
    for (step, raw_step) in record
        .trace
        .iter()
        .zip(raw["trace"].as_array().into_iter().flatten())
    {
        reject_null_fields(
            raw_step,
            &[
                "param",
                "role",
                "emission",
                "canonical_index",
                "field",
                "subject",
                "obligation",
                "observations",
            ],
        )?;
        let child_kind = match step.phase.as_str() {
            "invariant_post" => Some(ObligationKind::Invariant),
            "constraint_post" => Some(ObligationKind::Constraint),
            _ => None,
        };
        if let Some(expected_kind) = child_kind {
            let subject = step
                .subject
                .as_ref()
                .ok_or_else(|| record_error("child validity step has no typed subject"))?;
            record_identifier(&subject.entity)?;
            let _ = &subject.id;
            let obligation = step
                .obligation
                .as_ref()
                .ok_or_else(|| record_error("child validity step has no semantic obligation"))?;
            let (kind, hash) = match obligation {
                ChildObligation::Declared { kind, name, hash } => {
                    record_identifier(name)?;
                    (*kind, hash)
                }
                ChildObligation::SynthesizedReference {
                    kind,
                    entity_declaration,
                    field,
                    hash,
                } => {
                    if *kind != ObligationKind::Constraint {
                        return Err(record_error("a reference obligation is a constraint"));
                    }
                    record_hash(entity_declaration)?;
                    record_identifier(field)?;
                    (*kind, hash)
                }
            };
            record_hash(hash)?;
            if kind != expected_kind || hash != &step.hash {
                return Err(record_error(
                    "child obligation does not match trace phase/hash",
                ));
            }
            let observations = step
                .observations
                .as_ref()
                .ok_or_else(|| record_error("child validity step has no observations"))?;
            if step.outcome == json!("skipped") && !observations.is_empty() {
                return Err(record_error("skipped child step has observations"));
            }
            for observation in observations {
                if observation.field.is_empty() || observation.phase_state != "S'" {
                    return Err(record_error("invalid child field observation"));
                }
                crate::canonical::to_canonical_string(&observation.value)
                    .map_err(|error| record_error(error.to_string()))?;
            }
        } else if ["subject", "obligation", "observations"]
            .iter()
            .any(|field| raw_step.get(*field).is_some())
        {
            return Err(record_error(
                "child evidence outside the child validity phase",
            ));
        }
        // Common outcome, hash, role and rescale checks use the same validator
        // below; the closed typed parse has already rejected unknown fields.
        let _ = (
            &step.reads,
            &step.param,
            &step.role,
            &step.rescales,
            &step.emission,
            step.canonical_index,
            &step.field,
        );
    }
    let mut common = raw.clone();
    if let Some(object) = common.as_object_mut() {
        object.remove("validation_profile");
        object.remove("refused_request");
        object.insert("record_version".into(), json!(RECORD_VERSION_COMMANDS));
        object.insert("semantic_profile".into(), json!("0.8"));
        if record.commands.is_none() {
            object.insert(
                "commands".into(),
                json!({"declarations":[],"types":[],"intents":[]}),
            );
        }
    }
    if let Some(trace) = common["trace"].as_array_mut() {
        for step in trace {
            if let Some(object) = step.as_object_mut() {
                object.remove("subject");
                object.remove("obligation");
                object.remove("observations");
            }
        }
    }
    let bag = validate_record07(&common)?;
    let _ = (
        record.behavior_version,
        record.data_version,
        record.git_revision,
        record.action,
        record.state,
        record.input,
        record.context,
        record.reasons,
    );
    Ok(bag)
}

fn validate_record07(raw: &Json) -> Result<crate::commands::CommandIntentBag, RecordError> {
    let record: Record07 =
        serde_json::from_value(raw.clone()).map_err(|e| record_error(e.to_string()))?;
    if record.record_version != RECORD_VERSION_COMMANDS || record.semantic_profile != "0.8" {
        return Err(record_error("unsupported record/profile pair"));
    }
    record_hash(&record.behavior_version)?;
    if let Some(hash) = &record.action.hash {
        record_hash(hash)?;
    }
    if record.result == "ALLOW" && record.action.hash.is_none() {
        return Err(record_error("allowed record has no action identity"));
    }
    if ![
        "ALLOW",
        "DENY",
        "ERROR",
        "INVALID_INPUT",
        "INVALID_STATE",
        "INVALID_CONTEXT",
        "INVALID_BINDING",
        "ENTITY_ID_ALREADY_USED",
        "LIFECYCLE_CONFLICT",
    ]
    .contains(&record.result.as_str())
    {
        return Err(record_error("unknown result"));
    }
    let bag = crate::commands::decode_archive(&record.commands)
        .map_err(|e| record_error(e.to_string()))?;
    if record.result != "ALLOW"
        && (!bag.is_empty() || !record.changes.is_empty() || !record.lifecycle.is_empty())
    {
        return Err(record_error("a refused record exposes partial effects"));
    }
    if let Some(facts) = record.facts
        && record.result != "INVALID_INPUT"
    {
        crate::facts::Facts::from_json(&facts).map_err(|e| record_error(e.message))?;
    }
    for reason in record.reasons {
        if reason.code.is_empty() {
            return Err(record_error("empty reason code"));
        }
        if let Some(detail) = reason.details {
            record_failure(&detail)?;
        }
        for edge in reason.references {
            if edge.entity.is_empty() || edge.field.is_empty() {
                return Err(record_error("invalid reference edge"));
            }
            let _ = edge.id;
        }
        let _ = reason.path;
    }
    for step in record.trace {
        trace_outcome(&step)?;
        record_hash(&step.hash)?;
        if ![
            "constraint",
            "invariant_pre",
            "precondition",
            "effect",
            "create",
            "remove",
            "command_guard",
            "command_payload",
            "postcondition",
            "invariant_post",
            "constraint_post",
            "invariant_global",
        ]
        .contains(&step.phase.as_str())
        {
            return Err(record_error("unknown trace phase"));
        }
        if let Some(hash) = step.emission {
            record_hash(&hash)?;
        }
        if let Some(role) = step.role
            && !["state", "input", "context"].contains(&role.as_str())
        {
            return Err(record_error("invalid trace role"));
        }
        for rescale in step.rescales {
            if rescale.scale > 28
                || crate::exact::Rounding::parse(&rescale.rounding).is_none()
                || crate::exact::Exact::parse(&rescale.exact).is_err()
                || crate::decimal::Dec::parse_str(&rescale.result).is_err()
            {
                return Err(record_error("invalid rescale evidence"));
            }
        }
        let _ = (step.reads, step.param, step.canonical_index, step.field);
    }
    for derived in record.derived {
        record_hash(&derived.hash)?;
        if !["S", "S'"].contains(&derived.phase_state.as_str()) {
            return Err(record_error("invalid derived phase"));
        }
        let _ = derived.value;
    }
    for change in record.changes {
        if change.entity.is_empty() || change.param.is_empty() || change.field.is_empty() {
            return Err(record_error("invalid changed cell"));
        }
        let _ = (change.id, change.old, change.new);
    }
    for change in record.lifecycle {
        if !["create", "remove"].contains(&change.op.as_str()) || change.entity.is_empty() {
            return Err(record_error("invalid lifecycle event"));
        }
        let _ = (change.id, change.value);
    }
    let _ = (
        record.data_version,
        record.git_revision,
        record.action.name,
        record.state,
        record.input,
        record.context,
    );
    Ok(bag)
}
