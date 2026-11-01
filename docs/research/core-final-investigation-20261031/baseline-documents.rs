//! Canonical persistence documents (data-model.md): entity content and versions, state references,
//! the store genesis and its evidence policy, commit bundles, transition records, and replay
//! reports. Every document is canonical JSON identified by a domain-tagged SHA-256.

use std::collections::BTreeMap;

use serde::{Deserialize, Serialize};
use serde_json::Value as Json;

use behavior_verify::hashing::document_hash;

pub const TAG_GENESIS_V2: &str = "behavior.store_genesis.v2";
pub const TAG_COMMIT_BUNDLE_V2: &str = "behavior.commit_bundle.v2";
pub const TAG_TRANSITION_RECORD_V2: &str = "behavior.transition_record.v2";
pub const TAG_MIGRATION_BUNDLE_V2: &str = "behavior.migration_bundle.v2";
pub const TAG_ENTITY_CONTENT: &str = "behavior.entity_content.v1";
pub const TAG_ENTITY_VERSION: &str = "behavior.entity_version.v1";
pub const TAG_STATE: &str = "behavior.state.v1";
pub const TAG_EVIDENCE_POLICY: &str = "behavior.evidence_policy.v1";
pub const TAG_GENESIS: &str = "behavior.store_genesis.v1";
pub const TAG_COMMIT_BUNDLE: &str = "behavior.commit_bundle.v1";
pub const TAG_TRANSITION_RECORD: &str = "behavior.transition_record.v1";
pub const TAG_REPLAY_REPORT: &str = "behavior.replay_report.v1";
/// The migration bundle of a migration record (feature 009).
pub const TAG_MIGRATION_BUNDLE: &str = "behavior.migration_bundle.v1";

/// Every store document tag (feature 008: reported by `behavior engine-info`).
pub const DOCUMENT_TAGS: &[&str] = &[
    TAG_ENTITY_CONTENT,
    TAG_ENTITY_VERSION,
    TAG_STATE,
    TAG_EVIDENCE_POLICY,
    TAG_GENESIS,
    TAG_COMMIT_BUNDLE,
    TAG_TRANSITION_RECORD,
    TAG_REPLAY_REPORT,
    TAG_MIGRATION_BUNDLE,
    TAG_GENESIS_V2,
    TAG_COMMIT_BUNDLE_V2,
    TAG_MIGRATION_BUNDLE_V2,
    TAG_TRANSITION_RECORD_V2,
];

/// Errors of the store and its documents (data-model.md → Store results and errors).
#[derive(Debug, Clone, PartialEq, Eq, thiserror::Error)]
pub enum StoreError {
    #[error("HISTORY_MISMATCH at position {position}: {message}")]
    HistoryInvalid {
        position: u64,
        kind: &'static str,
        message: String,
    },
    #[error("{code}: {message}")]
    Contract { code: &'static str, message: String },
    #[error("STATE_CONFLICT: the store is at {current:?}, not the expected parent")]
    StateConflict {
        current: StateRef,
        changed: Vec<EntityKey>,
    },
    #[error("NOTHING_TO_COMMIT: {0}")]
    NothingToCommit(String),
    #[error("ENTITY_NOT_FOUND: {0}")]
    EntityNotFound(String),
    #[error("ENTITY_DECLARATION_MISMATCH: {0}")]
    EntityDeclarationMismatch(String),
    /// The module's store schema is not the store's schema at the evaluated position (feature
    /// 009, FR-005): checked before the action runs, over every entity type.
    #[error("SCHEMA_MISMATCH: {}", schema_mismatch_text(.store, .module, .differing))]
    SchemaMismatch {
        store: String,
        module: String,
        differing: Vec<DeclarationDiff>,
    },
    #[error("BUNDLE_INVALID: {0}")]
    BundleInvalid(String),
    #[error("EVIDENCE_REQUIRED: {0}")]
    EvidenceRequired(String),
    #[error("EVIDENCE_MISMATCH: {0}")]
    EvidenceMismatch(String),
    #[error("ENTITY_UNIVERSE_CHANGED: {0}")]
    EntityUniverseChanged(String),
    #[error("GENESIS_INVALID: {0}")]
    GenesisInvalid(String),
    #[error("ENTITY_ID_ALREADY_USED: {0}")]
    EntityIdAlreadyUsed(String),
    #[error("DANGLING_REFERENCE: {0}")]
    DanglingReference(String),
    #[error("BACKEND_ERROR: {0}")]
    Backend(String),
    /// A migration was refused (feature 009): `MIGRATION_SCHEMA_MISMATCH`,
    /// `MIGRATION_SOURCE_INVALID`, `MIGRATION_REQUIREMENT_FAILED`, `MIGRATION_TRANSFORM_ERROR`,
    /// `MIGRATION_INVALID_RESULT` or `RETIRED_TYPE_NOT_EMPTY`, naming the rule and the entities.
    #[error("{0}")]
    Migration(behavior_core::migration::MigrationRefusal),
}

impl StoreError {
    /// The stable error code.
    pub fn code(&self) -> &'static str {
        match self {
            StoreError::Contract { code, .. } => code,
            StoreError::HistoryInvalid { .. } => "HISTORY_MISMATCH",
            StoreError::StateConflict { .. } => "STATE_CONFLICT",
            StoreError::NothingToCommit(_) => "NOTHING_TO_COMMIT",
            StoreError::EntityNotFound(_) => "ENTITY_NOT_FOUND",
            StoreError::EntityDeclarationMismatch(_) => "ENTITY_DECLARATION_MISMATCH",
            StoreError::SchemaMismatch { .. } => "SCHEMA_MISMATCH",
            StoreError::BundleInvalid(_) => "BUNDLE_INVALID",
            StoreError::EvidenceRequired(_) => "EVIDENCE_REQUIRED",
            StoreError::EvidenceMismatch(_) => "EVIDENCE_MISMATCH",
            StoreError::EntityUniverseChanged(_) => "ENTITY_UNIVERSE_CHANGED",
            StoreError::GenesisInvalid(_) => "GENESIS_INVALID",
            StoreError::EntityIdAlreadyUsed(_) => "ENTITY_ID_ALREADY_USED",
            StoreError::DanglingReference(_) => "DANGLING_REFERENCE",
            StoreError::Backend(_) => "BACKEND_ERROR",
            StoreError::Migration(r) => r.code,
        }
    }
}

pub type R<T> = Result<T, StoreError>;

/// Exact immutable history event, including lineage and content-state identity.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct HistoryRef {
    pub format: String,
    pub store: String,
    pub state: String,
    pub position: u64,
    pub record: String,
}
/// A validated canonical live-state export; adoption creates a new lineage.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct SnapshotExport {
    pub format: String,
    pub source_history: HistoryRef,
    pub schema: String,
    pub state: String,
    pub seed: Vec<SeedEntity>,
}
impl HistoryRef {
    pub fn from_json(text: &str) -> R<Self> {
        let value: Self = behavior_core::canonical::decode_closed(text)
            .map_err(|e| StoreError::BundleInvalid(e.to_string()))?;
        value.validate()?;
        Ok(value)
    }
    pub fn validate(&self) -> R<()> {
        if self.format != "behavior.history_ref.v1"
            || (self.position == 0 && self.record != self.store)
            || [&self.store, &self.state, &self.record]
                .iter()
                .any(|h| !valid_hash(h))
        {
            return Err(StoreError::Contract {
                code: "INVALID_HISTORY_REF",
                message: "invalid history format, hash or genesis anchor".into(),
            });
        }
        Ok(())
    }
    pub fn as_json(&self) -> Json {
        serde_json::json!(self)
    }
    pub fn state_ref(&self) -> StateRef {
        StateRef {
            state: self.state.clone(),
            position: self.position,
        }
    }
}

/// One entity type declared differently by a store schema and a module (feature 009): its
/// declaration hash on each side, absent where the type is not declared.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct DeclarationDiff {
    pub entity: String,
    pub store: Option<String>,
    pub module: Option<String>,
}

impl DeclarationDiff {
    /// The entity types declared differently by the two maps, sorted by name.
    pub fn between(
        store: &BTreeMap<String, String>,
        module: &BTreeMap<String, String>,
    ) -> Vec<DeclarationDiff> {
        let names: std::collections::BTreeSet<&String> =
            store.keys().chain(module.keys()).collect();
        names
            .into_iter()
            .filter(|n| store.get(*n) != module.get(*n))
            .map(|n| DeclarationDiff {
                entity: n.clone(),
                store: store.get(n).cloned(),
                module: module.get(n).cloned(),
            })
            .collect()
    }
}

fn schema_mismatch_text(store: &str, module: &str, differing: &[DeclarationDiff]) -> String {
    let side = |d: &Option<String>| d.clone().unwrap_or_else(|| "not declared".into());
    let list: Vec<String> = differing
        .iter()
        .map(|d| {
            format!(
                "{} (store {}, module {})",
                d.entity,
                side(&d.store),
                side(&d.module)
            )
        })
        .collect();
    format!(
        "the store's schema is {store}, the module's is {module}; entity types declared \
         differently: {}. A different schema needs an explicit migration",
        list.join(", ")
    )
}

/// The domain-tagged hash of a serializable document.
pub fn hash_of<T: Serialize>(tag: &str, doc: &T) -> R<String> {
    let v = serde_json::to_value(doc).map_err(|e| StoreError::BundleInvalid(e.to_string()))?;
    #[cfg(feature = "validation-work")]
    behavior_core::eval::work::note(|w| {
        w.document_hash_calls += 1;
        w.hash_document_json_bytes += v.to_string().len();
    });
    document_hash(tag, &v).map_err(|e| StoreError::BundleInvalid(e.to_string()))
}

/// Decodes a document strictly (unknown fields are refused).
pub fn decode<T: for<'de> Deserialize<'de>>(what: &str, v: &Json) -> R<T> {
    #[cfg(feature = "validation-work")]
    behavior_core::eval::work::note(|w| {
        w.document_decode_calls += 1;
        w.document_decode_json_bytes += v.to_string().len();
    });
    serde_json::from_value(v.clone()).map_err(|e| StoreError::BundleInvalid(format!("{what}: {e}")))
}

/// An entity instance: type name and id (string form).
#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct EntityKey {
    pub entity: String,
    pub id: String,
}

impl std::fmt::Display for EntityKey {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}#{}", self.entity, self.id)
    }
}

/// What an entity *is* (enters the state identity): type, declaration, id, canonical value.
/// Revisions and positions are history, not content.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct EntityContent {
    pub entity: String,
    pub declaration: String,
    pub id: String,
    pub value: Json,
}

impl EntityContent {
    pub fn hash(&self) -> R<String> {
        hash_of(TAG_ENTITY_CONTENT, self)
    }
}

/// One historical incarnation of an entity. `created_at` is the position of the commit that
/// created it (0 for the seed); stored versions never change.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct EntityVersion {
    pub content_hash: String,
    pub entity: String,
    pub id: String,
    pub revision: u64,
    pub created_at: u64,
    pub value: Json,
}

impl EntityVersion {
    pub fn key(&self) -> EntityKey {
        EntityKey {
            entity: self.entity.clone(),
            id: self.id.clone(),
        }
    }

    pub fn content(&self, declaration: &str) -> EntityContent {
        EntityContent {
            entity: self.entity.clone(),
            declaration: declaration.to_string(),
            id: self.id.clone(),
            value: self.value.clone(),
        }
    }

    pub fn hash(&self) -> R<String> {
        hash_of(TAG_ENTITY_VERSION, self)
    }
}

/// A state (content identity) at a history position.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct StateRef {
    pub state: String,
    pub position: u64,
}

/// The store's head: current state, the state accumulator (hex), and the last record (or the
/// genesis hash before the first commit).
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Head {
    pub state_ref: StateRef,
    pub acc_num: String,
    pub acc_den: String,
    pub last_record: String,
    /// The store schema in force since the last migration (feature 009); absent while the store
    /// is under its genesis schema, so heads of stores that never migrate keep their bytes.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub schema: Option<SchemaRef>,
}

/// A store schema in force from a history position on (feature 009, research R3): its SchemaHash,
/// its entity declarations, the position from which it applies, and the record that introduced
/// it (the genesis hash for the genesis schema).
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct SchemaRef {
    pub hash: String,
    pub declarations: BTreeMap<String, String>,
    pub since: u64,
    pub migration_record: String,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum Require {
    None,
    CommitAuthorization,
}

/// What governance evidence a commit needs (research R9); fixed in the genesis.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct EvidencePolicy {
    pub format: String,
    pub require: Require,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub trusted_execution_policies: Option<Vec<String>>,
    /// What a migration needs (feature 009); absent: the same as an action. Existing policies
    /// keep their bytes and hashes.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub migration: Option<MigrationEvidence>,
}

/// The evidence a migration transition needs (feature 009, FR-019b).
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct MigrationEvidence {
    pub require: Require,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub trusted_execution_policies: Option<Vec<String>>,
}

impl EvidencePolicy {
    pub fn none() -> Self {
        EvidencePolicy {
            format: TAG_EVIDENCE_POLICY.into(),
            require: Require::None,
            trusted_execution_policies: None,
            migration: None,
        }
    }

    /// What a migration needs: the `migration` section, or else what an action needs.
    pub fn for_migration(&self) -> (Require, Option<&Vec<String>>) {
        match &self.migration {
            Some(m) => (m.require, m.trusted_execution_policies.as_ref()),
            None => (self.require, self.trusted_execution_policies.as_ref()),
        }
    }

    pub fn hash(&self) -> R<String> {
        hash_of(TAG_EVIDENCE_POLICY, self)
    }

    pub fn validate(&self) -> R<()> {
        if self.format != TAG_EVIDENCE_POLICY {
            return Err(StoreError::GenesisInvalid(format!(
                "evidence policy format `{}`",
                self.format
            )));
        }
        Ok(())
    }
}

/// Policy formats have distinct meanings and identity domains. A v2 policy
/// never passes through the historical structural authorization checker.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(untagged)]
pub enum EvidencePolicyDocument {
    Legacy(EvidencePolicy),
    Trusted(behavior_verify::governance::trusted::EvidencePolicyV2),
}
impl From<EvidencePolicy> for EvidencePolicyDocument {
    fn from(p: EvidencePolicy) -> Self {
        Self::Legacy(p)
    }
}
impl EvidencePolicyDocument {
    pub fn hash(&self) -> R<String> {
        match self {
            Self::Legacy(p) => p.hash(),
            Self::Trusted(p) => Ok(p.hash().into()),
        }
    }
    pub fn validate(&self) -> R<()> {
        match self {
            Self::Legacy(p) => p.validate(),
            Self::Trusted(_) => Ok(()),
        }
    }
    pub fn as_legacy(&self) -> Option<&EvidencePolicy> {
        if let Self::Legacy(p) = self {
            Some(p)
        } else {
            None
        }
    }
    pub fn as_trusted(&self) -> Option<&behavior_verify::governance::trusted::EvidencePolicyV2> {
        if let Self::Trusted(p) = self {
            Some(p)
        } else {
            None
        }
    }
    pub fn require(&self) -> Require {
        match self {
            Self::Legacy(p) => p.require,
            Self::Trusted(p) => {
                if p.requires_authorization() {
                    Require::CommitAuthorization
                } else {
                    Require::None
                }
            }
        }
    }
    pub fn for_migration(&self) -> (Require, Option<&Vec<String>>) {
        match self {
            Self::Legacy(p) => p.for_migration(),
            Self::Trusted(p) => (
                if p.migration_requires_authorization() {
                    Require::CommitAuthorization
                } else {
                    Require::None
                },
                None,
            ),
        }
    }
}
pub fn valid_hash(hash: &str) -> bool {
    hash.strip_prefix("sha256:").is_some_and(|h| {
        h.len() == 64
            && h.bytes()
                .all(|c| c.is_ascii_digit() || (b'a'..=b'f').contains(&c))
    })
}

/// One seed entity of the genesis.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct SeedEntity {
    pub entity: String,
    pub value: Json,
}

/// The document a store is created from; its hash is the store identity and the chain root.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Genesis {
    pub format: String,
    pub evidence_policy: EvidencePolicyDocument,
    pub entity_declarations: BTreeMap<String, String>,
    pub seed: Vec<SeedEntity>,
}

impl Genesis {
    pub fn from_json(text: &str) -> R<Self> {
        let g: Self = behavior_core::canonical::decode_closed(text)
            .map_err(|e| StoreError::GenesisInvalid(e.to_string()))?;
        g.hash()?;
        Ok(g)
    }
    pub fn hash(&self) -> R<String> {
        self.evidence_policy.validate()?;
        let tag = match (&*self.format, &self.evidence_policy) {
            (TAG_GENESIS, EvidencePolicyDocument::Legacy(_)) => TAG_GENESIS,
            (TAG_GENESIS_V2, EvidencePolicyDocument::Trusted(_)) => {
                if self
                    .entity_declarations
                    .iter()
                    .any(|(name, h)| name.is_empty() || !valid_hash(h))
                {
                    return Err(StoreError::GenesisInvalid(
                        "invalid typed declaration identity".into(),
                    ));
                }
                let mut previous: Option<(&str, &str)> = None;
                for seed in &self.seed {
                    let fields = seed.value.as_object().ok_or_else(|| {
                        StoreError::GenesisInvalid("seed is not a typed entity product".into())
                    })?;
                    let id = fields
                        .get("id")
                        .and_then(Json::as_str)
                        .filter(|s| !s.is_empty())
                        .ok_or_else(|| {
                            StoreError::GenesisInvalid("seed has no entity identity".into())
                        })?;
                    let key = (seed.entity.as_str(), id);
                    if !self.entity_declarations.contains_key(&seed.entity)
                        || previous.is_some_and(|p| p >= key)
                        || fields.values().any(|v| {
                            !(v.is_null()
                                || v.is_boolean()
                                || v.is_string()
                                || v.as_i64().is_some())
                        })
                    {
                        return Err(StoreError::GenesisInvalid(
                            "seed product or canonical typed-key ordering is invalid".into(),
                        ));
                    }
                    previous = Some(key);
                }
                TAG_GENESIS_V2
            }
            _ => {
                return Err(StoreError::GenesisInvalid(
                    "genesis/policy format pairing differs".into(),
                ));
            }
        };
        hash_of(tag, self)
    }

    /// The genesis schema (feature 009): computed from the declarations, never stored.
    pub fn schema(&self) -> R<SchemaRef> {
        let s = behavior_core::StoreSchema::of(self.entity_declarations.clone());
        Ok(SchemaRef {
            hash: s.hash,
            declarations: s.declarations,
            since: 0,
            migration_record: self.hash()?,
        })
    }
}

/// An observed read of one entity: the revision at the evaluated state and the fields read.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ReadEntry {
    pub entity: String,
    pub id: String,
    pub revision: u64,
    pub fields: Vec<String>,
}

/// A written cell.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct WriteEntry {
    pub entity: String,
    pub id: String,
    pub field: String,
    pub old: Json,
    pub new: Json,
}

/// A lifecycle write (feature 006): the existence of `entity#id` changes (`create` also writes
/// every field).
#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct LifecycleWrite {
    pub op: String,
    pub entity: String,
    pub id: String,
}

/// A removal in a transition record: the last version the entity had.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct RemovedEntity {
    pub entity: String,
    pub id: String,
    pub last_revision: u64,
    pub last_content_hash: String,
}

/// A change of the derived reverse-reference index (feature 006): `source.field` starts (`add`)
/// or stops (`drop`) pointing at `target`.
#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct RefChange {
    pub target: EntityKey,
    pub source: EntityKey,
    pub field: String,
    pub op: String,
}

fn is_null(v: &Json) -> bool {
    v.is_null()
}

/// Governance evidence for one commit (feature 002 documents).
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Evidence {
    pub authorization: Json,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub execution_policy: Option<Json>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub attestation: Option<Json>,
    #[serde(default, skip_serializing_if = "Vec::is_empty")]
    pub waivers: Vec<Json>,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(untagged)]
pub enum CommitEvidence {
    Legacy(Evidence),
    Trusted(Box<behavior_verify::governance::trusted::EvidenceV2>),
}
impl From<Evidence> for CommitEvidence {
    fn from(e: Evidence) -> Self {
        Self::Legacy(e)
    }
}
impl CommitEvidence {
    pub fn as_legacy(&self) -> Option<&Evidence> {
        if let Self::Legacy(e) = self {
            Some(e)
        } else {
            None
        }
    }
    pub fn as_trusted(&self) -> Option<&behavior_verify::governance::trusted::EvidenceV2> {
        if let Self::Trusted(e) = self {
            Some(e)
        } else {
            None
        }
    }
}

/// What an allowed evaluation hands to a store.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct CommitBundle {
    pub format: String,
    pub evaluated_state: StateRef,
    pub behavior_version: String,
    pub store: String,
    pub record: Json,
    pub transition_hash: String,
    pub entity_declarations: BTreeMap<String, String>,
    pub read_set: Vec<ReadEntry>,
    pub write_set: Vec<WriteEntry>,
    /// The evaluation facts the decision observed (feature 006; the record's `facts` section):
    /// existence, identity and reference reads. Omitted when there are none.
    #[serde(default, skip_serializing_if = "is_null")]
    pub read_facts: Json,
    /// Creations and removals (feature 006), omitted when there are none.
    #[serde(default, skip_serializing_if = "Vec::is_empty")]
    pub write_lifecycle: Vec<LifecycleWrite>,
    pub commit_time: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub evidence: Option<CommitEvidence>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub evaluated_history: Option<HistoryRef>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub authorization_context: Option<Json>,
}

impl CommitBundle {
    pub fn from_json(text: &str) -> R<Self> {
        let b: Self = behavior_core::canonical::decode_closed(text)
            .map_err(|e| StoreError::BundleInvalid(e.to_string()))?;
        b.hash()?;
        Ok(b)
    }
    pub fn governance_candidate(
        &self,
    ) -> R<behavior_verify::governance::trusted::GovernanceCandidate> {
        if self.format != TAG_COMMIT_BUNDLE_V2 {
            return Err(StoreError::Contract {
                code: "HISTORY_FORMAT_UPGRADE_REQUIRED",
                message: "candidate requires a v2 bundle with an exact history head".into(),
            });
        }
        let history = self
            .evaluated_history
            .as_ref()
            .ok_or_else(|| StoreError::BundleInvalid("missing evaluated_history".into()))?;
        history.validate()?;
        if history.state_ref() != self.evaluated_state || history.store != self.store {
            return Err(StoreError::BundleInvalid(
                "history/state/store basis differs".into(),
            ));
        }
        let content = serde_json::json!({"kind":"action","store":self.store,"evaluated_history":history,"behavior_version":self.behavior_version,"record":self.record,
            "entity_declarations":self.entity_declarations,"read_set":self.read_set,"read_facts":if self.read_facts.is_null(){serde_json::json!({})}else{self.read_facts.clone()},"write_set":self.write_set,"write_lifecycle":self.write_lifecycle});
        let transition = hash_of(
            behavior_verify::hashing::TAG_CANDIDATE_TRANSITION_V2,
            &content,
        )?;
        behavior_verify::governance::trusted::GovernanceCandidate::from_json(&serde_json::json!({"format":"behavior.governance_candidate.v2","content":content,"transition_hash":transition}).to_string())
            .map_err(|e|StoreError::BundleInvalid(e.to_string()))
    }
    pub fn with_trusted_evidence(
        &self,
        evidence: &behavior_verify::governance::trusted::EvidenceV2,
    ) -> R<Self> {
        let candidate = self.governance_candidate()?;
        if candidate.hash() != self.transition_hash
            || evidence.as_json()["authorization"]["content"]["candidate_transition_hash"]
                != self.transition_hash
        {
            return Err(StoreError::EvidenceMismatch(
                "evidence is for another exact candidate".into(),
            ));
        }
        let mut bundle = self.clone();
        bundle.evidence = Some(CommitEvidence::Trusted(Box::new(evidence.clone())));
        Ok(bundle)
    }
    pub fn hash(&self) -> R<String> {
        match self.format.as_str() {
            TAG_COMMIT_BUNDLE => {
                if self.evaluated_history.is_some()
                    || self.authorization_context.is_some()
                    || self
                        .evidence
                        .as_ref()
                        .is_some_and(|e| e.as_trusted().is_some())
                {
                    return Err(StoreError::BundleInvalid(
                        "legacy bundle contains v2 semantics".into(),
                    ));
                }
                hash_of(TAG_COMMIT_BUNDLE, self)
            }
            TAG_COMMIT_BUNDLE_V2 => {
                if self.governance_candidate()?.hash() != self.transition_hash {
                    return Err(StoreError::BundleInvalid(
                        "v2 candidate identity differs".into(),
                    ));
                }
                if self
                    .evidence
                    .as_ref()
                    .is_some_and(|e| e.as_legacy().is_some())
                {
                    return Err(StoreError::BundleInvalid(
                        "v2 bundle cannot contain structural legacy evidence".into(),
                    ));
                }
                hash_of(TAG_COMMIT_BUNDLE_V2, self)
            }
            _ => Err(StoreError::BundleInvalid(
                "unknown commit bundle format".into(),
            )),
        }
    }

    /// The same bundle with evidence attached (the transition hash is unchanged).
    pub fn with_evidence(&self, evidence: Evidence) -> CommitBundle {
        let mut b = self.clone();
        b.evidence = Some(evidence.into());
        b
    }
}

/// The outcome of one source requirement of a migration (feature 009).
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct RequirementOutcome {
    pub name: String,
    pub held: bool,
}

/// What a migration transition records (feature 009, FR-015, FR-019c, research R7): the
/// migration's identity, the source and target SchemaHashes, the target declarations, the schema
/// in force before it (absent: the genesis schema), the requirement outcomes, the reviewable
/// report, that runtime validation of the source and the target state passed, and any cited
/// verification.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct MigrationBundle {
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub format: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub candidate: Option<Json>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub evidence: Option<CommitEvidence>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub authorization_context: Option<Json>,
    pub migration_hash: String,
    pub source: String,
    pub target: String,
    pub target_declarations: BTreeMap<String, String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub previous_schema: Option<SchemaRef>,
    pub requirements: Vec<RequirementOutcome>,
    pub report: Json,
    pub source_validated: bool,
    pub target_validated: bool,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub verification: Option<Json>,
    pub commit_time: String,
}

impl MigrationBundle {
    pub fn hash(&self) -> R<String> {
        match self.format.as_deref() {
            None => {
                if self.candidate.is_some()
                    || self.evidence.is_some()
                    || self.authorization_context.is_some()
                {
                    return Err(StoreError::BundleInvalid(
                        "legacy migration contains v2 semantics".into(),
                    ));
                }
                hash_of(TAG_MIGRATION_BUNDLE, self)
            }
            Some(TAG_MIGRATION_BUNDLE_V2) => {
                let raw = self.candidate.as_ref().ok_or_else(|| {
                    StoreError::BundleInvalid("v2 migration lacks exact candidate".into())
                })?;
                let c = behavior_verify::governance::trusted::GovernanceCandidate::from_json(
                    &raw.to_string(),
                )
                .map_err(|e| StoreError::BundleInvalid(e.to_string()))?;
                if c.kind() != "migration"
                    || c.content()["migration_hash"] != self.migration_hash
                    || c.content()["source_schema"] != self.source
                    || c.content()["target_schema"] != self.target
                    || c.content()["requirements"] != serde_json::json!(self.requirements)
                    || c.content()["transformation"]["report"] != self.report
                    || behavior_core::StoreSchema::of(self.target_declarations.clone()).hash
                        != self.target
                    || !self.source_validated
                    || !self.target_validated
                    || self.verification.is_some()
                    || self
                        .evidence
                        .as_ref()
                        .is_some_and(|e| e.as_legacy().is_some())
                {
                    return Err(StoreError::BundleInvalid(
                        "migration candidate/validation/evidence differs".into(),
                    ));
                }
                hash_of(TAG_MIGRATION_BUNDLE_V2, self)
            }
            _ => Err(StoreError::BundleInvalid(
                "unsupported migration bundle format".into(),
            )),
        }
    }
}

/// The record kind of a migration transition (feature 009); action records have no `kind`.
pub const KIND_MIGRATION: &str = "migration";

/// A committed bundle: the commit object. Records form a hash chain from the genesis. An action
/// record carries its commit bundle; a migration record (feature 009, `kind: "migration"`)
/// carries its migration bundle instead, so action records keep their bytes.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct TransitionRecord {
    pub format: String,
    pub position: u64,
    pub previous_record: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub kind: Option<String>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub bundle: Option<CommitBundle>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub migration: Option<MigrationBundle>,
    pub bundle_hash: String,
    pub evaluated_against: StateRef,
    pub committed_on: StateRef,
    pub result_state: StateRef,
    pub new_versions: Vec<EntityVersion>,
    pub evidence_policy: String,
    pub authorization: Option<String>,
    /// Entities created by this transition, at revision 1 (feature 006).
    #[serde(default, skip_serializing_if = "Vec::is_empty")]
    pub created: Vec<EntityVersion>,
    /// Entities removed by this transition; their versions are kept (feature 006).
    #[serde(default, skip_serializing_if = "Vec::is_empty")]
    pub removed: Vec<RemovedEntity>,
    /// Changes of the derived reverse-reference index (feature 006).
    #[serde(default, skip_serializing_if = "Vec::is_empty")]
    pub ref_changes: Vec<RefChange>,
}

impl TransitionRecord {
    pub fn hash(&self) -> R<String> {
        self.check_kind()?;
        match self.format.as_str() {
            TAG_TRANSITION_RECORD => hash_of(TAG_TRANSITION_RECORD, self),
            TAG_TRANSITION_RECORD_V2 => hash_of(TAG_TRANSITION_RECORD_V2, self),
            _ => Err(StoreError::BundleInvalid(
                "unknown transition format".into(),
            )),
        }
    }

    /// The record is exactly one kind: an action record (no `kind`, a bundle, no migration) or a
    /// migration record (`kind: "migration"`, a migration bundle, no commit bundle).
    pub fn check_kind(&self) -> R<()> {
        let valid = match (
            self.format.as_str(),
            self.kind.as_deref(),
            &self.bundle,
            &self.migration,
        ) {
            (TAG_TRANSITION_RECORD, None, Some(b), None) => b.format == TAG_COMMIT_BUNDLE,
            (TAG_TRANSITION_RECORD, Some(KIND_MIGRATION), None, Some(m)) => m.format.is_none(),
            (TAG_TRANSITION_RECORD_V2, Some("action"), Some(b), None) => {
                b.hash()?;
                let h = b
                    .evaluated_history
                    .as_ref()
                    .ok_or_else(|| StoreError::BundleInvalid("missing evaluated history".into()))?;
                h.state_ref() == self.evaluated_against && h.record == self.previous_record
            }
            (TAG_TRANSITION_RECORD_V2, Some(KIND_MIGRATION), None, Some(m)) => {
                m.hash()?;
                let h = HistoryRef::from_json(
                    &m.candidate.as_ref().ok_or_else(|| {
                        StoreError::BundleInvalid("missing migration candidate".into())
                    })?["content"]["evaluated_history"]
                        .to_string(),
                )?;
                h.state_ref() == self.evaluated_against && h.record == self.previous_record
            }
            _ => false,
        };
        if !valid {
            return Err(StoreError::BundleInvalid(
                "event kind/format/history product differs".into(),
            ));
        }
        if self.format == TAG_TRANSITION_RECORD_V2
            && (self.evaluated_against != self.committed_on
                || self.committed_on.position.checked_add(1) != Some(self.position)
                || self.result_state.position != self.position)
        {
            return Err(StoreError::BundleInvalid(
                "v2 event position/history basis differs".into(),
            ));
        }
        Ok(())
    }

    /// Whether this is a migration record (feature 009).
    pub fn is_migration(&self) -> bool {
        self.kind.as_deref() == Some(KIND_MIGRATION)
    }
}

/// The first divergence found by a replay.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Divergence {
    pub position: u64,
    pub kind: String,
    pub expected: String,
    pub found: String,
}

/// The result of a data or behavior replay.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ReplayReport {
    pub format: String,
    pub kind: String,
    pub from: StateRef,
    pub to: StateRef,
    pub checked: u64,
    pub ok: bool,
    pub divergence: Option<Divergence>,
}

/// `store:<genesis>;state:<state id>;position:<n>`: binds a decision record to its store and
/// evaluated state (FR-019).
pub fn data_version(store: &str, at: &StateRef) -> String {
    format!("store:{store};state:{};position:{}", at.state, at.position)
}

/// An RFC 3339 UTC timestamp `YYYY-MM-DDTHH:MM:SSZ` (as in feature 002 governance).
pub fn valid_timestamp(s: &str) -> bool {
    let b = s.as_bytes();
    let digits = [0, 1, 2, 3, 5, 6, 8, 9, 11, 12, 14, 15, 17, 18];
    b.len() == 20
        && digits.iter().all(|&i| b[i].is_ascii_digit())
        && b[4] == b'-'
        && b[7] == b'-'
        && b[10] == b'T'
        && b[13] == b':'
        && b[16] == b':'
        && b[19] == b'Z'
}
