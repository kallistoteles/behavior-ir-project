//! The store semantics over a host backend (research R2, R6–R9): genesis, consistent-snapshot
//! evaluation, and guarded, atomic, idempotent commits with whole-state optimistic concurrency.

use std::collections::{BTreeMap, BTreeSet};
use std::sync::{Arc, Mutex};

#[cfg(test)]
mod creation_tests;
mod incremental;
mod initialization;
#[cfg(test)]
mod local_validation;
mod replay_evidence;

use serde_json::{Map, Value as Json, json};

use behavior_core::intent::{IntentError, IntentRejection};
use behavior_core::read::{
    ReadExecution, ReadReplayProfile, ReadSource, check_read_intent, compare_prepared_read_replay,
    evaluate_read_with, execute_prepared_read_replay_with, execute_read_replay_with,
    prepare_read_replay, reproduce_read_transport_refusal, resolve,
};
use behavior_core::record::ReplayResult;
use behavior_core::semantic::module::{Module, ParamRole};
use behavior_core::semantic::types::Type;
use behavior_core::{
    EvaluationFacts, FactError, IndexPlan, QueryRequest, RefEdge, StoreSchema, decode_entity,
    evaluate_with, index_hint, schema,
};
use behavior_verify::hashing::{TAG_TRANSITION, document_hash};

use crate::documents::{
    CommitBundle, DeclarationDiff, EntityKey, EntityVersion, Evidence, Genesis, Head,
    KIND_MIGRATION, LifecycleWrite, MigrationBundle, R, ReadEntry, RefChange, RemovedEntity,
    Require, RequirementOutcome, SchemaRef, StateRef, StoreError, TAG_COMMIT_BUNDLE, TAG_GENESIS,
    TAG_TRANSITION_RECORD, TransitionRecord, WriteEntry, data_version, valid_timestamp,
};
use crate::muhash::Accumulator;
use crate::{Backend, BackendError, CasOutcome};

// Recorded profiles are checked Core values, never caller-selected strings.
#[derive(Clone, Copy)]
enum ExecutionMode<'a> {
    Fresh,
    ArchivedRead(&'a ReadReplayProfile),
    Replay,
}

/// The result of an evaluation against the store: the decision record, and a commit bundle only
/// for allowed decisions.
#[derive(Debug, Clone)]
pub struct Evaluation {
    pub record: Json,
    pub bundle: Option<CommitBundle>,
}

/// Boundary evidence plus an optional head action candidate; invocation is read-only.
#[derive(Debug, Clone)]
pub struct Invocation {
    pub record: behavior_core::invocation::InvocationRecord,
    pub bundle: Option<CommitBundle>,
}

/// An engine-produced migration candidate. Preparation is read-only; commit
/// independently rederives the exact candidate before checking governance.
#[derive(Debug, Clone)]
pub struct PreparedMigration {
    history: crate::documents::HistoryRef,
    candidate: behavior_verify::governance::trusted::GovernanceCandidate,
    commit_time: String,
    outcome: behavior_core::migration::Migrated,
    parent_versions: BTreeMap<EntityKey, EntityVersion>,
}
impl PreparedMigration {
    pub fn governance_candidate(
        &self,
    ) -> R<behavior_verify::governance::trusted::GovernanceCandidate> {
        Ok(self.candidate.clone())
    }
}
impl<B: Backend> Store<B> {
    pub fn commit_with_context(
        &mut self,
        module: &Module,
        parent: &StateRef,
        bundle: &CommitBundle,
        context: &behavior_verify::governance::trusted::AuthorizationContextV2,
    ) -> R<Committed> {
        self.commit_impl(module, parent, bundle, Some(context))
    }
    pub fn export_seed_at(
        &self,
        module: &Module,
        at: &crate::documents::HistoryRef,
    ) -> R<crate::documents::SnapshotExport> {
        let versions = self.validated_versions(module, at)?;
        Ok(crate::documents::SnapshotExport {
            format: "behavior.snapshot_export.v1".into(),
            source_history: at.clone(),
            schema: schema(module).hash,
            state: at.state.clone(),
            seed: versions
                .into_values()
                .map(|v| crate::documents::SeedEntity {
                    entity: v.entity,
                    value: v.value,
                })
                .collect(),
        })
    }

    // Validate content-addressed membership as well as Valid_B(S). The complete
    // keys/version universe is a backend contract; optional indexes are not used.
    fn validated_versions(
        &self,
        module: &Module,
        at: &crate::documents::HistoryRef,
    ) -> R<BTreeMap<EntityKey, EntityVersion>> {
        self.versions_for(module, at, DecisionPurpose::Current)
    }

    fn versions_for(
        &self,
        module: &Module,
        at: &crate::documents::HistoryRef,
        purpose: DecisionPurpose,
    ) -> R<BTreeMap<EntityKey, EntityVersion>> {
        at.validate()?;
        if self.history_at(at.position)? != *at {
            return Err(StoreError::Contract {
                code: "HISTORY_MISMATCH",
                message: "snapshot basis is not the exact canonical history event".into(),
            });
        }
        let at_schema = self.bind_schema(module, at.position)?;
        let state = StateRef {
            state: at.state.clone(),
            position: at.position,
        };
        match purpose {
            DecisionPurpose::Current => {
                self.validate_snapshot(module, &state, &at_schema)?;
            }
            DecisionPurpose::Historical => {
                self.snapshot_identity(module, &state, &at_schema)?;
                self.validate_snapshot_full(module, at.position)?;
            }
        }
        let mut versions = BTreeMap::new();
        let mut acc = Accumulator::empty();
        for entity in at_schema.declarations.keys() {
            for k in self
                .backend
                .keys_at(entity, at.position)
                .map_err(backend_err)?
            {
                if versions.contains_key(&k) {
                    continue;
                }
                if k.entity != *entity {
                    return Err(invalid("snapshot key has a different entity type"));
                }
                let v = self
                    .backend
                    .version_at(&k, at.position)
                    .map_err(backend_err)?
                    .ok_or_else(|| invalid("snapshot member missing"))?;
                let canonical =
                    decode_entity(module, entity, &v.value).map_err(|p| invalid(p.join("; ")))?;
                if v.key() != k
                    || id_of(&canonical)? != k.id
                    || canonical != v.value
                    || v.revision == 0
                    || v.created_at > at.position
                    || !exists_at(&self.backend, &k, at.position).map_err(backend_err)?
                {
                    return Err(invalid("snapshot value/identity/revision is inconsistent"));
                }
                let declaration = at_schema
                    .declarations
                    .get(entity)
                    .ok_or_else(|| invalid("snapshot declaration missing"))?;
                if v.content(declaration).hash()? != v.content_hash {
                    return Err(invalid("snapshot content hash differs"));
                }
                acc.insert(&v.content_hash)?;
                versions.insert(k, v);
            }
        }
        if acc.state_id()? != at.state {
            return Err(invalid("snapshot content does not reproduce StateId"));
        }
        Ok(versions)
    }
    pub fn current_history(&self) -> R<crate::documents::HistoryRef> {
        let head = self.head()?;
        self.history_with_head(head.state_ref.position, &head)
    }
    pub fn history_at(&self, position: u64) -> R<crate::documents::HistoryRef> {
        self.history_with_head(position, &self.head()?)
    }
    pub(crate) fn history_with_head(
        &self,
        position: u64,
        head: &Head,
    ) -> R<crate::documents::HistoryRef> {
        if position > head.state_ref.position {
            return Err(StoreError::Contract {
                code: "INVALID_HISTORY_REF",
                message: "position is beyond the captured head".into(),
            });
        }
        let (state, record) = if position == 0 {
            let mut acc = Accumulator::empty();
            for seed in &self.genesis.seed {
                let id = id_of(&seed.value)?;
                let declaration = self
                    .genesis
                    .entity_declarations
                    .get(&seed.entity)
                    .ok_or_else(|| invalid("genesis seed has no declaration"))?;
                let value = if self.genesis.evidence_policy.as_trusted().is_some() {
                    seed.value.clone()
                } else {
                    self.backend
                        .version_at(&key(&seed.entity, &id), 0)
                        .map_err(backend_err)?
                        .ok_or_else(|| invalid("genesis seed version missing"))?
                        .value
                };
                let content = crate::documents::EntityContent {
                    entity: seed.entity.clone(),
                    declaration: declaration.clone(),
                    id,
                    value,
                };
                acc.insert(&content.hash()?)?;
            }
            (acc.state_id()?, self.store_id.clone())
        } else {
            let event = self
                .backend
                .record(position)
                .map_err(backend_err)?
                .ok_or_else(|| invalid("committed history event missing"))?;
            event.check_kind()?;
            if event.position != position
                || event.result_state.position != position
                || event.committed_on.position.checked_add(1) != Some(position)
            {
                return Err(invalid("history event position differs"));
            }
            let previous = if position == 1 {
                self.store_id.clone()
            } else {
                self.backend
                    .record(position - 1)
                    .map_err(backend_err)?
                    .ok_or_else(|| invalid("history parent missing"))?
                    .hash()?
            };
            if event.previous_record != previous {
                return Err(invalid("history parent hash differs"));
            }
            (event.result_state.state.clone(), event.hash()?)
        };
        let history = crate::documents::HistoryRef {
            format: "behavior.history_ref.v1".into(),
            store: self.store_id.clone(),
            state,
            position,
            record,
        };
        history.validate()?;
        if position == head.state_ref.position
            && (history.state_ref() != head.state_ref || history.record != head.last_record)
        {
            return Err(invalid(
                "captured head differs from canonical committed history",
            ));
        }
        Ok(history)
    }
    pub fn prepare_migration(
        &self,
        source: &Module,
        target: &Module,
        migration: &behavior_core::migration::Migration,
        commit_time: &str,
        at: Option<&crate::documents::HistoryRef>,
    ) -> R<PreparedMigration> {
        self.prepare_migration_for(
            source,
            target,
            migration,
            commit_time,
            at,
            DecisionPurpose::Current,
        )
    }

    /// Historical reproduction validates the same complete parent without
    /// attaching reusable current validation authority to an archived operation.
    pub(crate) fn prepare_migration_archived(
        &self,
        source: &Module,
        target: &Module,
        migration: &behavior_core::migration::Migration,
        commit_time: &str,
        at: Option<&crate::documents::HistoryRef>,
    ) -> R<PreparedMigration> {
        self.prepare_migration_for(
            source,
            target,
            migration,
            commit_time,
            at,
            DecisionPurpose::Historical,
        )
    }

    #[allow(clippy::too_many_arguments)]
    fn prepare_migration_for(
        &self,
        source: &Module,
        target: &Module,
        migration: &behavior_core::migration::Migration,
        commit_time: &str,
        at: Option<&crate::documents::HistoryRef>,
        purpose: DecisionPurpose,
    ) -> R<PreparedMigration> {
        if !valid_timestamp(commit_time) {
            return Err(invalid("commit time is not canonical Gregorian UTC"));
        }
        let history = match at {
            Some(h) => h.clone(),
            None => self.current_history()?,
        };
        let current = self.bind_schema(source, history.position)?;
        // apply_migration also checks schemas first, then the exact resolved pair.
        if current.hash != migration.source_schema() || !migration.matches_behaviors(source, target)
        {
            return Err(invalid(
                "migration source schema or exact resolved behavior pair differs",
            ));
        }
        let parent_versions = self.versions_for(source, &history, purpose)?;
        let entities = parent_versions
            .values()
            .map(|v| behavior_core::migration::SourceEntity {
                entity: v.entity.clone(),
                value: v.value.clone(),
            })
            .collect::<Vec<_>>();
        let outcome =
            behavior_core::migration::apply_migration(migration, source, target, &entities)
                .map_err(StoreError::Migration)?;
        let mut writes = Vec::new();
        for entity in &outcome.entities {
            let old = parent_versions
                .get(&key(&entity.entity, &entity.id))
                .ok_or_else(|| invalid("migration changed entity identity"))?;
            let before = old
                .value
                .as_object()
                .ok_or_else(|| invalid("source is not a typed product"))?;
            let after = entity
                .value
                .as_object()
                .ok_or_else(|| invalid("target is not a typed product"))?;
            for field in before.keys().chain(after.keys()).collect::<BTreeSet<_>>() {
                if before.get(field) != after.get(field) {
                    writes.push(WriteEntry {
                        entity: entity.entity.clone(),
                        id: entity.id.clone(),
                        field: field.clone(),
                        old: before.get(field).cloned().unwrap_or(Json::Null),
                        new: after.get(field).cloned().unwrap_or(Json::Null),
                    });
                }
            }
        }
        writes.sort_by(|a, b| (&a.entity, &a.id, &a.field).cmp(&(&b.entity, &b.id, &b.field)));
        let reads = parent_versions
            .values()
            .map(|v| ReadEntry {
                entity: v.entity.clone(),
                id: v.id.clone(),
                revision: v.revision,
                fields: v
                    .value
                    .as_object()
                    .map(|o| o.keys().cloned().collect())
                    .unwrap_or_default(),
            })
            .collect::<Vec<_>>();
        let transformation = json!({"migration_hash":migration.hash(),"entities":outcome.entities.iter().map(|e|json!({"entity":e.entity,"id":e.id,"value":e.value,"migrated":e.migrated})).collect::<Vec<_>>(),"report":outcome.report});
        let content = json!({"kind":"migration","store":self.store_id,"evaluated_history":history,"migration_hash":migration.hash(),"source_behavior":source.behavior_version(),"target_behavior":target.behavior_version(),
            "source_schema":current.hash,"target_schema":schema(target).hash,"entity_declarations":current.declarations,"read_set":reads,"read_facts":{},"write_set":writes,"write_lifecycle":[],
            "requirements":outcome.requirements,"transformation":transformation,"validations":{"source_validated":true,"target_validated":true}});
        let hash = document_hash(
            behavior_verify::hashing::TAG_CANDIDATE_TRANSITION_V2,
            &content,
        )
        .map_err(|e| invalid(e.to_string()))?;
        let candidate=behavior_verify::governance::trusted::GovernanceCandidate::from_json(&json!({"format":"behavior.governance_candidate.v2","content":content,"transition_hash":hash}).to_string()).map_err(trusted_err)?;
        Ok(PreparedMigration {
            history,
            candidate,
            commit_time: commit_time.into(),
            outcome,
            parent_versions,
        })
    }
    #[allow(clippy::too_many_arguments)]
    pub fn commit_prepared_migration(
        &mut self,
        source: &Module,
        target: &Module,
        migration: &behavior_core::migration::Migration,
        prepared: &PreparedMigration,
        evidence: Option<&behavior_verify::governance::trusted::EvidenceV2>,
        context: Option<&behavior_verify::governance::trusted::AuthorizationContextV2>,
    ) -> R<Committed> {
        if !migration.matches_behaviors(source, target)
            || prepared.candidate.subject()
                != json!({"migration_hash":migration.hash(),"source_behavior":source.behavior_version(),"target_behavior":target.behavior_version(),"source_schema":schema(source).hash,"target_schema":schema(target).hash})
        {
            return Err(invalid("prepared migration exact behavior pair differs"));
        }
        let v2 = self.genesis.evidence_policy.as_trusted().is_some();
        let next =
            prepared
                .history
                .position
                .checked_add(1)
                .ok_or_else(|| StoreError::Contract {
                    code: "HISTORY_POSITION_EXHAUSTED",
                    message: "history position cannot advance".into(),
                })?;
        let existing = if v2 {
            self.backend.record(next).map_err(backend_err)?
        } else {
            None
        };
        let historical = existing
            .as_ref()
            .and_then(|event| event.migration.as_ref())
            .is_some_and(|bundle| bundle.candidate.as_ref() == Some(&prepared.candidate.as_json()));
        let again = self.prepare_migration_for(
            source,
            target,
            migration,
            &prepared.commit_time,
            Some(&prepared.history),
            if historical {
                DecisionPurpose::Historical
            } else {
                DecisionPurpose::Current
            },
        )?;
        if again.candidate.as_json() != prepared.candidate.as_json() {
            return Err(invalid(
                "prepared migration does not reproduce against its exact snapshot",
            ));
        }
        let expected_evidence = evidence
            .cloned()
            .map(|e| crate::documents::CommitEvidence::Trusted(Box::new(e)));
        // Recovery uses the original archived context and event, even after later commits.
        if v2
            && let Some(event) = existing
            && let Some(mb) = event.migration.as_ref()
            && mb.candidate.as_ref() == Some(&prepared.candidate.as_json())
        {
            event.check_kind()?;
            if (expected_evidence.is_some() && mb.evidence != expected_evidence)
                || event.previous_record != prepared.history.record
                || event.committed_on != prepared.history.state_ref()
                || event.bundle_hash != mb.hash()?
            {
                return Err(invalid(
                    "migration recovery differs from the original complete event",
                ));
            }
            let q = archived_context(mb.evidence.as_ref(), mb.authorization_context.as_ref())?;
            let auth = check_archived_trusted_evidence(
                &prepared.candidate,
                &self.genesis,
                mb.evidence.as_ref(),
                q.as_ref(),
                &mb.commit_time,
            )?;
            if auth != event.authorization || self.history_at(next)?.record != event.hash()? {
                return Err(invalid("migration recovered authorization/history differs"));
            }
            return Ok(Committed {
                record_id: event.hash()?,
                result_state: event.result_state,
                already: true,
                evidence_trust: auth.as_ref().map(|_| "authenticated"),
            });
        }
        if !v2 {
            if self.genesis.evidence_policy.for_migration().0 == Require::CommitAuthorization {
                return Err(StoreError::Contract {
                    code: "TRUSTED_GOVERNANCE_UPGRADE_REQUIRED",
                    message: "fresh required-governance migration needs v2 adoption".into(),
                });
            }
            if evidence.is_some() {
                return Err(invalid("trusted evidence cannot be used in legacy history"));
            }
            if self.current_history()? != prepared.history {
                return Err(StoreError::Contract {
                    code: "HISTORY_CONFLICT",
                    message: "prepared migration parent changed".into(),
                });
            }
            return self.migrate(migration, source, target, &prepared.commit_time, None);
        }
        let head = self.head()?;
        if self.history_with_head(head.state_ref.position, &head)? != prepared.history {
            return Err(StoreError::Contract {
                code: "HISTORY_CONFLICT",
                message: "prepared migration exact parent changed".into(),
            });
        }
        let auth = check_trusted_evidence(
            &behavior_verify::governance::trusted::GovernanceSubject::Migration(
                migration, source, target,
            ),
            &prepared.candidate,
            &self.genesis,
            expected_evidence.as_ref(),
            context,
            &prepared.commit_time,
        )?;
        let q = if evidence.is_some() {
            Some(
                context
                    .ok_or_else(|| invalid("trusted migration context missing"))?
                    .as_json(),
            )
        } else {
            None
        };
        self.commit_migration_outcome(
            migration,
            source,
            target,
            &head,
            &again.parent_versions,
            again.outcome,
            &prepared.commit_time,
            None,
            Some((prepared.candidate.as_json(), expected_evidence, q, auth)),
        )
    }
}

/// Canonical v2 genesis begins a content-addressed lineage without rewriting
/// historical policy or events. Store::create establishes full seed validity.
pub fn genesis_v2_for(
    module: &Module,
    policy: behavior_verify::governance::trusted::EvidencePolicyV2,
    seed: Vec<crate::documents::SeedEntity>,
) -> R<Genesis> {
    let mut canonical = Vec::new();
    let mut seen = BTreeSet::new();
    for item in seed {
        let value = decode_entity(module, &item.entity, &item.value)
            .map_err(|p| StoreError::GenesisInvalid(p.join("; ")))?;
        let id = id_of(&value)?;
        if !seen.insert((item.entity.clone(), id)) {
            return Err(StoreError::GenesisInvalid(
                "duplicate typed seed identity".into(),
            ));
        }
        canonical.push(crate::documents::SeedEntity {
            entity: item.entity,
            value,
        });
    }
    canonical.sort_by(|a, b| {
        (&a.entity, a.value["id"].as_str()).cmp(&(&b.entity, b.value["id"].as_str()))
    });
    let genesis = Genesis {
        format: crate::documents::TAG_GENESIS_V2.into(),
        evidence_policy: crate::documents::EvidencePolicyDocument::Trusted(policy),
        entity_declarations: declarations(module),
        seed: canonical,
    };
    genesis.hash()?;
    Ok(genesis)
}

/// Backend operations finish fallibly before entering the Core resolver. Its
/// infallible existence API must never turn a storage failure into absence.
struct InvocationResolver<'a> {
    values: BTreeMap<behavior_core::invocation::TypedIdentity, &'a Json>,
    data_version: String,
}

/// Live commits establish current validity; historical reproduction discharges
/// the obligations of immutable evidence without publishing a current certificate.
#[derive(Clone, Copy)]
enum DecisionPurpose {
    Current,
    Historical,
}
impl behavior_core::invocation::Resolver for InvocationResolver<'_> {
    fn exists(&self, key: &behavior_core::invocation::EntityKey) -> bool {
        self.values.contains_key(key)
    }
    fn value(&self, key: &behavior_core::invocation::EntityKey) -> Option<Json> {
        self.values.get(key).map(|value| (*value).clone())
    }
    fn data_version(&self) -> String {
        self.data_version.clone()
    }
}

/// A successful commit.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Committed {
    pub record_id: String,
    pub result_state: StateRef,
    /// The same transition had already been committed (FR-009).
    pub already: bool,
    /// `Some("structural")` when a commit authorization was bound: a structural guarantee within
    /// the current trust boundary, not proof of who issued it (FR-023).
    pub evidence_trust: Option<&'static str>,
}

/// Engine-owned store semantics over any [`Backend`]. The genesis and the store identity never
/// change, so they are read and hashed once (a commit's cost must not grow with the seed).
pub struct Store<B: Backend> {
    backend: B,
    genesis: std::sync::Arc<Genesis>,
    store_id: String,
    /// The genesis schema (feature 009), computed once like the store identity.
    genesis_schema: SchemaRef,
    /// Engine-owned evidence, bounded to one immutable snapshot. Not part of persistence.
    validated: Mutex<Option<ValidatedSnapshot>>,
}

// Certificates are private reconstructible evidence for the corrected validator.
// Historical replay never creates a certificate for its archived execution profile.
const CURRENT_VALIDATION_PROFILE: &str = "behavior.complete_resulting_state.v1";

#[derive(Clone, PartialEq, Eq)]
struct SnapshotIdentity {
    history: crate::documents::HistoryRef,
    schema: SchemaRef,
    // Equality checks canonical admitted content, not merely a cryptographic digest.
    behavior: String,
    validation_profile: &'static str,
}

struct ValidatedSnapshot {
    identity: SnapshotIdentity,
    facts: Arc<SeedFacts>,
    prepared: Option<Arc<behavior_core::eval::prepared::PreparedSnapshot>>,
    checked: Option<behavior_core::eval::prepared::CheckedEvaluation>,
}

fn prepare_snapshot(
    module: &Module,
    facts: &SeedFacts,
) -> Option<Arc<behavior_core::eval::prepared::PreparedSnapshot>> {
    #[cfg(test)]
    if incremental::reference_enabled() {
        return None;
    }
    if !incremental::dependency::supported_module(module) {
        return None;
    }
    // This optional optimization cannot add a new refusal to Store validation.
    behavior_core::eval::prepared::PreparedSnapshot::new(module, facts)
        .ok()
        .flatten()
        .map(Arc::new)
}

fn backend_err(e: BackendError) -> StoreError {
    StoreError::Backend(e.0)
}

fn invalid(msg: impl Into<String>) -> StoreError {
    StoreError::BundleInvalid(msg.into())
}

/// The semantic declaration hash of every entity of `module` (its store schema, feature 009).
pub fn declarations(module: &Module) -> BTreeMap<String, String> {
    behavior_core::schema::declarations(module)
}

/// The genesis schema of a store whose identity is `store_id` (the genesis hash).
fn genesis_schema_of(genesis: &Genesis, store_id: &str) -> SchemaRef {
    let s = StoreSchema::of(genesis.entity_declarations.clone());
    SchemaRef {
        hash: s.hash,
        declarations: s.declarations,
        since: 0,
        migration_record: store_id.to_string(),
    }
}

/// `SCHEMA_MISMATCH` between the store's schema at a position and a module's (FR-005).
pub fn schema_mismatch(store: &SchemaRef, module: &StoreSchema) -> StoreError {
    StoreError::SchemaMismatch {
        store: store.hash.clone(),
        module: module.hash.clone(),
        differing: DeclarationDiff::between(&store.declarations, &module.declarations),
    }
}

/// A genesis for `module`'s entity declarations with the given evidence policy and seed.
pub fn genesis_for(
    module: &Module,
    evidence_policy: crate::documents::EvidencePolicy,
    seed: Vec<crate::documents::SeedEntity>,
) -> Genesis {
    Genesis {
        format: TAG_GENESIS.into(),
        evidence_policy: evidence_policy.into(),
        entity_declarations: declarations(module),
        seed,
    }
}

/// Whether `key` exists at `position`: some version at or before it, and not removed at or
/// before it (feature 006, research R9).
pub fn exists_at<B: Backend + ?Sized>(
    backend: &B,
    key: &EntityKey,
    position: u64,
) -> Result<bool, BackendError> {
    Ok(backend.version_at(key, position)?.is_some()
        && backend.removed_at(key)?.is_none_or(|r| r > position))
}

/// Evaluation facts answered by the backend as of one position: the same snapshot as the bound
/// entities' `version_at` reads (feature 006, research R3).
pub struct StoreFacts<'a, B: Backend + ?Sized> {
    pub backend: &'a B,
    pub position: u64,
}

fn key(entity: &str, id: &str) -> EntityKey {
    EntityKey {
        entity: entity.to_string(),
        id: id.to_string(),
    }
}

impl<B: Backend + ?Sized> StoreFacts<'_, B> {
    /// The candidates an index plan names, or `None` if the backend lacks an index it needs.
    fn candidates(&self, t: &str, plan: &IndexPlan) -> Result<Option<Vec<EntityKey>>, FactError> {
        Ok(match plan {
            IndexPlan::Eq { field, value } => self
                .backend
                .keys_by_field_at(t, field, value, self.position)
                .map_err(|e| FactError(e.0))?,
            IndexPlan::Union(a, b) => match (self.candidates(t, a)?, self.candidates(t, b)?) {
                (Some(mut x), Some(y)) => {
                    x.extend(y);
                    x.sort();
                    x.dedup();
                    Some(x)
                }
                _ => None,
            },
        })
    }
}

impl<B: Backend + ?Sized> EvaluationFacts for StoreFacts<'_, B> {
    fn exists(&self, entity: &str, id: &str) -> Result<bool, FactError> {
        exists_at(self.backend, &key(entity, id), self.position).map_err(|e| FactError(e.0))
    }
    fn used(&self, entity: &str, id: &str) -> Result<bool, FactError> {
        self.backend
            .used_at(&key(entity, id), self.position)
            .map_err(|e| FactError(e.0))
    }
    fn incoming(&self, entity: &str, id: &str) -> Result<Vec<RefEdge>, FactError> {
        self.backend
            .incoming_at(&key(entity, id), self.position)
            .map_err(|e| FactError(e.0))
    }
    /// Evaluates the query over the entities of its type as of the position (feature 007): an
    /// indexable equality narrows the candidates, and every candidate is re-checked.
    fn query(&self, q: &QueryRequest<'_>) -> Result<Vec<String>, FactError> {
        let t = q.node.entity();
        let hinted = match index_hint(q.node, q.env) {
            Some(plan) => self.candidates(t, &plan)?,
            None => None,
        };
        let candidates = match hinted {
            Some(keys) => keys,
            None => self
                .backend
                .keys_at(t, self.position)
                .map_err(|e| FactError(e.0))?,
        };
        let mut out = Vec::new();
        for k in candidates {
            let Some(v) = self
                .backend
                .version_at(&k, self.position)
                .map_err(|e| FactError(e.0))?
            else {
                continue;
            };
            if q.matches(&v.value)? {
                out.push(k.id);
            }
        }
        Ok(out)
    }
    /// One version read for the whole entity (feature 010, research R8).
    fn entity(&self, entity: &str, id: &str) -> Result<Json, FactError> {
        self.backend
            .version_at(&key(entity, id), self.position)
            .map_err(|e| FactError(e.0))?
            .map(|v| v.value)
            .ok_or_else(|| FactError(format!("{entity}#{id} is not in the state")))
    }
    fn field(&self, entity: &str, id: &str, field: &str) -> Result<Json, FactError> {
        self.backend
            .version_at(&key(entity, id), self.position)
            .map_err(|e| FactError(e.0))?
            .and_then(|v| v.value.get(field).cloned())
            .ok_or_else(|| FactError(format!("{entity}#{id}.{field} is not in the state")))
    }
}

/// Evaluation facts of a genesis: the seed is the whole universe and the whole history.
struct SeedFacts {
    keys: BTreeSet<EntityKey>,
    incoming: BTreeMap<EntityKey, Vec<RefEdge>>,
    values: BTreeMap<EntityKey, Json>,
}

impl SeedFacts {
    fn new(versions: &[EntityVersion], keys: &BTreeSet<EntityKey>, refs: &[RefChange]) -> Self {
        let mut incoming: BTreeMap<EntityKey, Vec<RefEdge>> = BTreeMap::new();
        for r in refs {
            incoming.entry(r.target.clone()).or_default().push(RefEdge {
                entity: r.source.entity.clone(),
                id: r.source.id.clone(),
                field: r.field.clone(),
            });
        }
        SeedFacts {
            keys: keys.clone(),
            incoming,
            values: versions
                .iter()
                .map(|v| (v.key(), v.value.clone()))
                .collect(),
        }
    }
}

impl EvaluationFacts for SeedFacts {
    fn exists(&self, entity: &str, id: &str) -> Result<bool, FactError> {
        Ok(self.keys.contains(&key(entity, id)))
    }
    fn used(&self, entity: &str, id: &str) -> Result<bool, FactError> {
        Ok(self.keys.contains(&key(entity, id)))
    }
    fn incoming(&self, entity: &str, id: &str) -> Result<Vec<RefEdge>, FactError> {
        Ok(self
            .incoming
            .get(&key(entity, id))
            .cloned()
            .unwrap_or_default())
    }
    fn query(&self, q: &QueryRequest<'_>) -> Result<Vec<String>, FactError> {
        #[cfg(feature = "validation-work")]
        behavior_core::eval::work::note(|w| w.store_value_rows += self.values.len());
        let mut out = Vec::new();
        for (k, v) in self
            .values
            .iter()
            .filter(|(k, _)| k.entity == q.node.entity())
        {
            if q.matches(v)? {
                out.push(k.id.clone());
            }
        }
        Ok(out)
    }
    fn field(&self, entity: &str, id: &str, field: &str) -> Result<Json, FactError> {
        self.values
            .get(&key(entity, id))
            .and_then(|v| v.get(field))
            .cloned()
            .ok_or_else(|| FactError(format!("{entity}#{id}.{field} is not in the seed")))
    }
}

/// Facts from the complete snapshot already validated for this computation. Only identity
/// lifetime is historical rather than a function of the live snapshot.
struct SnapshotFacts<'a, B: Backend> {
    snapshot: &'a SeedFacts,
    backend: &'a B,
    position: u64,
}

impl<B: Backend> EvaluationFacts for SnapshotFacts<'_, B> {
    fn exists(&self, entity: &str, id: &str) -> Result<bool, FactError> {
        self.snapshot.exists(entity, id)
    }
    fn used(&self, entity: &str, id: &str) -> Result<bool, FactError> {
        self.backend
            .used_at(&key(entity, id), self.position)
            .map_err(|e| FactError(e.0))
    }
    fn incoming(&self, entity: &str, id: &str) -> Result<Vec<RefEdge>, FactError> {
        self.snapshot.incoming(entity, id)
    }
    fn query(&self, q: &QueryRequest<'_>) -> Result<Vec<String>, FactError> {
        self.snapshot.query(q)
    }
    fn entity(&self, entity: &str, id: &str) -> Result<Json, FactError> {
        self.snapshot
            .values
            .get(&key(entity, id))
            .cloned()
            .ok_or_else(|| FactError(format!("{entity}#{id} is not in the state")))
    }
    fn field(&self, entity: &str, id: &str, field: &str) -> Result<Json, FactError> {
        self.snapshot
            .values
            .get(&key(entity, id))
            .and_then(|v| v.get(field))
            .cloned()
            .ok_or_else(|| FactError(format!("{entity}#{id}.{field} is not in the state")))
    }
}

/// The reference-field values of an entity value: `(field, target type, target id)` for every
/// `Ref` field that holds an identity.
pub fn references_of(module: &Module, entity: &str, value: &Json) -> Vec<(String, EntityKey)> {
    module
        .entity(entity)
        .map(|item| {
            item.reference_fields()
                .filter_map(|(f, target)| {
                    value[f].as_str().map(|id| (f.to_string(), key(target, id)))
                })
                .collect()
        })
        .unwrap_or_default()
}

/// The entity types an action touches: its state entities and the types it creates.
fn touched_types(
    module: &Module,
    action: &behavior_core::semantic::module::ActionItem,
) -> BTreeSet<String> {
    let mut out: BTreeSet<String> = action
        .params()
        .iter()
        .filter(|p| matches!(p.role(), ParamRole::State | ParamRole::Read))
        .filter_map(|p| match p.ty() {
            Type::Entity(e) => Some(e.clone()),
            _ => None,
        })
        .collect();
    out.extend(action.creates().iter().map(|c| c.entity().to_string()));
    // Queried types are read too (feature 007): their declarations must match the store's.
    out.extend(behavior_core::queried_types(module, action));
    out
}

/// The lifecycle writes of a decision record (feature 006), in record order.
fn lifecycle_writes(record: &Json) -> R<Vec<LifecycleWrite>> {
    let mut out = Vec::new();
    for l in record["lifecycle"].as_array().into_iter().flatten() {
        let field = |k: &str| {
            l[k].as_str()
                .map(str::to_string)
                .ok_or_else(|| invalid(format!("lifecycle entry without `{k}`")))
        };
        out.push(LifecycleWrite {
            op: field("op")?,
            entity: field("entity")?,
            id: field("id")?,
        });
    }
    Ok(out)
}

fn id_of(value: &Json) -> R<String> {
    value["id"]
        .as_str()
        .map(str::to_string)
        .ok_or_else(|| invalid("an entity needs a string `id`"))
}

impl<B: Backend> Store<B> {
    /// Creates or recovers the exact original initialization, validating its seed
    /// under `module` before any publication. Equivalent retry preserves later
    /// history and migrations; `module` describes the original schema.
    /// A complete foreign lineage yields `STORE_CREATION_CONFLICT`. Operational
    /// failure does not imply rollback. Only verified exact position-zero evidence
    /// can populate the private seed-validity cache; advanced recovery stays cold.
    pub fn create(mut backend: B, module: &Module, genesis: Genesis) -> R<Self> {
        let candidate = initialization::ValidatedInitialization::validate(module, genesis)?;
        if let Some(published_genesis) = backend.genesis().map_err(backend_err)? {
            return Self::recover_initialization(backend, module, candidate, published_genesis);
        }
        // Absence is scoped to that read. The host must serialize the actual
        // check/publication against other initializers and commits.
        if let Err(primary) = backend.create(
            &candidate.genesis,
            &candidate.head,
            &candidate.versions,
            &candidate.refs,
        ) {
            // One bounded classification, never a retry. Equivalent, incomplete
            // or unavailable evidence cannot erase an operational primary error.
            if let Ok(Some(genesis)) = backend.genesis()
                && genesis != candidate.genesis
                && let Ok(observed) = Self::unverified(backend, genesis)
                && observed.inspect_publication().is_ok()
            {
                return Err(Self::creation_conflict());
            }
            return Err(backend_err(primary));
        }
        let published_genesis = backend.genesis().map_err(backend_err)?.ok_or_else(|| {
            initialization::incomplete("creation acknowledged without published genesis")
        })?;
        Self::recover_initialization(backend, module, candidate, published_genesis)
    }

    fn creation_conflict() -> StoreError {
        StoreError::Contract {
            code: "STORE_CREATION_CONFLICT",
            message: "target contains a different complete original creation".into(),
        }
    }

    fn recover_initialization(
        backend: B,
        module: &Module,
        candidate: initialization::ValidatedInitialization,
        published_genesis: Genesis,
    ) -> R<Self> {
        let store = Self::unverified(backend, published_genesis)?;
        let published = store.inspect_publication()?;
        if *store.genesis != candidate.genesis || store.store_id != candidate.head.last_record {
            return Err(Self::creation_conflict());
        }
        candidate.verify(&store, &published)?;
        store.attach_initial_validation(module, candidate, &published)?;
        Ok(store)
    }

    // Construction alone confers no validity or completeness authority.
    fn unverified(backend: B, genesis: Genesis) -> R<Self> {
        let store_id = genesis.hash()?;
        Ok(Self {
            backend,
            validated: Mutex::new(None),
            genesis_schema: genesis_schema_of(&genesis, &store_id),
            genesis: Arc::new(genesis),
            store_id,
        })
    }

    fn attach_initial_validation(
        &self,
        module: &Module,
        candidate: initialization::ValidatedInitialization,
        published: &initialization::PublishedInitialization,
    ) -> R<()> {
        // Equal content at a later position does not certify the committed history.
        if published.head != candidate.head {
            return Ok(());
        }
        let certificate = ValidatedSnapshot {
            identity: SnapshotIdentity {
                history: crate::documents::HistoryRef {
                    format: "behavior.history_ref.v1".into(),
                    store: self.store_id.clone(),
                    state: published.head.state_ref.state.clone(),
                    position: 0,
                    record: self.store_id.clone(),
                },
                schema: self.genesis_schema.clone(),
                behavior: behavior_core::serialize::to_wire_json(module),
                validation_profile: CURRENT_VALIDATION_PROFILE,
            },
            prepared: prepare_snapshot(module, &candidate.facts),
            checked: None,
            facts: Arc::new(candidate.facts),
        };
        *self.validation_cache()? = Some(certificate);
        Ok(())
    }

    /// Opens a structurally complete published Store, with a cold validity cache.
    /// Legacy typed normalization and complete Ref semantics remain Backend premises.
    pub fn open(backend: B) -> R<Self> {
        let genesis = backend
            .genesis()
            .map_err(backend_err)?
            .ok_or_else(|| StoreError::Backend("the store has not been created".into()))?;
        let store = Self::unverified(backend, genesis)?;
        store.inspect_publication()?;
        Ok(store)
    }

    pub fn backend(&self) -> &B {
        &self.backend
    }

    pub fn backend_mut(&mut self) -> &mut B {
        // Caller access can change storage outside the engine's validity derivation.
        *self.validated.get_mut().unwrap_or_else(|p| p.into_inner()) = None;
        self.validated.clear_poison();
        &mut self.backend
    }

    pub fn into_backend(self) -> B {
        self.backend
    }

    pub fn genesis(&self) -> R<Genesis> {
        Ok((*self.genesis).clone())
    }

    /// The store identity (the genesis hash).
    pub fn store_id(&self) -> R<String> {
        Ok(self.store_id.clone())
    }

    fn head(&self) -> R<Head> {
        self.backend
            .head()
            .map_err(backend_err)?
            .ok_or_else(|| StoreError::Backend("no head".into()))
    }

    /// The current state.
    pub fn current(&self) -> R<StateRef> {
        Ok(self.head()?.state_ref)
    }

    /// The schema in force at the head: the last migration's, or the genesis schema.
    fn head_schema(&self, head: &Head) -> R<SchemaRef> {
        match &head.schema {
            Some(s) => Ok(s.clone()),
            None => Ok(self.genesis_schema.clone()),
        }
    }

    /// The schema in force at `position` (FR-002): found by walking back from the head through
    /// migration records only, never by scanning ordinary records (research R3).
    pub(crate) fn schema_at_position(&self, position: u64) -> R<SchemaRef> {
        let head = self.head()?;
        let mut s = self.head_schema(&head)?;
        while s.since > position {
            s = self.previous_schema(&s)?;
        }
        Ok(s)
    }

    /// The schema in force before the migration that introduced `s` (the migration record at
    /// `s.since` names it; absent there means the genesis schema).
    fn previous_schema(&self, s: &SchemaRef) -> R<SchemaRef> {
        let rec = self
            .backend
            .record(s.since)
            .map_err(backend_err)?
            .ok_or_else(|| StoreError::Backend(format!("record {} missing", s.since)))?;
        match &rec.migration {
            Some(m) if rec.is_migration() => match &m.previous_schema {
                Some(p) => Ok(p.clone()),
                None => Ok(self.genesis_schema.clone()),
            },
            _ => Err(StoreError::Backend(format!(
                "the record at position {} does not introduce a schema",
                s.since
            ))),
        }
    }

    /// The schema under which state `at` of this store is valid (FR-001, FR-002).
    pub fn schema_at(&self, at: &StateRef) -> R<SchemaRef> {
        if self.state_at(at.position)? != *at {
            return Err(StoreError::EntityNotFound(format!(
                "{} at position {} is not a state of this store",
                at.state, at.position
            )));
        }
        self.schema_at_position(at.position)
    }

    /// Every schema this store has had, oldest first, each with the position it applies from.
    pub fn schema_history(&self) -> R<Vec<SchemaRef>> {
        let head = self.head()?;
        let mut s = self.head_schema(&head)?;
        let mut out = vec![s.clone()];
        while s.since > 0 {
            s = self.previous_schema(&s)?;
            out.push(s.clone());
        }
        out.reverse();
        Ok(out)
    }

    /// The store's schema at `position`, which `module` must declare exactly (FR-005).
    fn bind_schema(&self, module: &Module, position: u64) -> R<SchemaRef> {
        let at = self.schema_at_position(position)?;
        let m = schema(module);
        if m.hash != at.hash {
            return Err(schema_mismatch(&at, &m));
        }
        Ok(at)
    }

    /// Bind exact history without walking schemas introduced by later events.
    fn snapshot_identity(
        &self,
        module: &Module,
        at: &StateRef,
        schema: &SchemaRef,
    ) -> R<SnapshotIdentity> {
        let record = if at.position == 0 {
            self.store_id.clone()
        } else {
            let record = self
                .backend
                .record(at.position)
                .map_err(backend_err)?
                .ok_or_else(|| invalid("snapshot history record missing"))?;
            if record.position != at.position || record.result_state != *at {
                return Err(invalid("snapshot history does not match state reference"));
            }
            record.hash()?
        };
        Ok(SnapshotIdentity {
            history: crate::documents::HistoryRef {
                format: "behavior.history_ref.v1".into(),
                store: self.store_id.clone(),
                state: at.state.clone(),
                position: at.position,
                record,
            },
            schema: schema.clone(),
            behavior: behavior_core::serialize::to_wire_json(module),
            validation_profile: CURRENT_VALIDATION_PROFILE,
        })
    }

    fn validation_cache(&self) -> R<std::sync::MutexGuard<'_, Option<ValidatedSnapshot>>> {
        self.validated
            .lock()
            .map_err(|_| StoreError::Backend("snapshot validation cache poisoned".into()))
    }

    fn validate_snapshot(
        &self,
        module: &Module,
        at: &StateRef,
        schema: &SchemaRef,
    ) -> R<Arc<SeedFacts>> {
        let identity = self.snapshot_identity(module, at, schema)?;
        #[cfg(test)]
        if incremental::reference_enabled() {
            let facts = Arc::new(self.validate_snapshot_full(module, at.position)?);
            *self.validation_cache()? = Some(ValidatedSnapshot {
                identity,
                facts: Arc::clone(&facts),
                prepared: None,
                checked: None,
            });
            return Ok(facts);
        }
        if let Some(cached) = self
            .validation_cache()?
            .as_ref()
            .filter(|c| c.identity == identity)
        {
            return Ok(Arc::clone(&cached.facts));
        }
        let facts = Arc::new(self.validate_snapshot_full(module, at.position)?);
        *self.validation_cache()? = Some(ValidatedSnapshot {
            identity,
            prepared: prepare_snapshot(module, &facts),
            checked: None,
            facts: Arc::clone(&facts),
        });
        Ok(facts)
    }

    fn prepared_for(
        &self,
        snapshot: &Arc<SeedFacts>,
    ) -> Option<(
        Arc<behavior_core::eval::prepared::PreparedSnapshot>,
        Option<behavior_core::eval::prepared::CheckedEvaluation>,
    )> {
        #[cfg(test)]
        if incremental::reference_enabled() {
            return None;
        }
        let cache = self.validated.lock().ok()?;
        let cached = cache.as_ref().filter(|c| Arc::ptr_eq(&c.facts, snapshot))?;
        Some((
            Arc::clone(cached.prepared.as_ref()?),
            cached.checked.clone(),
        ))
    }
    fn retain_checked(
        &self,
        snapshot: &Arc<SeedFacts>,
        checked: behavior_core::eval::prepared::CheckedEvaluation,
    ) {
        if let Ok(mut cache) = self.validated.lock()
            && let Some(cached) = cache.as_mut().filter(|c| Arc::ptr_eq(&c.facts, snapshot))
        {
            cached.checked = Some(checked);
        }
    }

    /// Reference implementation: always materializes and checks the complete universe.
    fn validate_snapshot_full(&self, module: &Module, position: u64) -> R<SeedFacts> {
        let mut keys = BTreeSet::new();
        let mut versions = Vec::new();
        let mut references = Vec::new();
        for entity in module.entities().keys() {
            for k in self
                .backend
                .keys_at(entity, position)
                .map_err(backend_err)?
            {
                if k.entity != *entity {
                    return Err(invalid("STATE_INVALID: wrong typed snapshot key"));
                }
                if !keys.insert(k.clone()) {
                    continue;
                }
                let v = self
                    .backend
                    .version_at(&k, position)
                    .map_err(backend_err)?
                    .ok_or_else(|| invalid("STATE_INVALID: snapshot member has no value"))?;
                if v.key() != k
                    || self
                        .backend
                        .removed_at(&k)
                        .map_err(backend_err)?
                        .is_some_and(|r| r <= position)
                {
                    return Err(invalid("STATE_INVALID: inconsistent snapshot identity"));
                }
                references.extend(references_of(module, entity, &v.value).into_iter().map(
                    |(field, target)| RefChange {
                        target,
                        source: k.clone(),
                        field,
                        op: "add".into(),
                    },
                ));
                versions.push(v);
            }
        }
        let facts = SeedFacts::new(&versions, &keys, &references);
        let values = versions
            .iter()
            .map(|v| ((v.entity.clone(), v.id.clone()), v.value.clone()))
            .collect();
        #[cfg(test)]
        incremental::note_full_parent(versions.len());
        behavior_core::eval::check_behavior_snapshot(module, &values, &facts)
            .map_err(|p| invalid(format!("STATE_INVALID: {}", p.join("; "))))?;
        Ok(facts)
    }

    /// The state at `position` of this store's history.
    pub fn state_at(&self, position: u64) -> R<StateRef> {
        let head = self.head()?;
        if position == head.state_ref.position {
            return Ok(head.state_ref);
        }
        if position > head.state_ref.position {
            return Err(StoreError::EntityNotFound(format!(
                "position {position} is beyond the head"
            )));
        }
        let rec = self
            .backend
            .record(position + 1)
            .map_err(backend_err)?
            .ok_or_else(|| StoreError::Backend(format!("record {} missing", position + 1)))?;
        Ok(rec.committed_on)
    }

    /// The version of `key` valid at state `at` of this store.
    pub fn load(&self, key: &EntityKey, at: &StateRef) -> R<EntityVersion> {
        if self.state_at(at.position)? != *at {
            return Err(StoreError::EntityNotFound(format!(
                "{} at position {} is not a state of this store",
                at.state, at.position
            )));
        }
        if !exists_at(&self.backend, key, at.position).map_err(backend_err)? {
            return Err(StoreError::EntityNotFound(key.to_string()));
        }
        self.backend
            .version_at(key, at.position)
            .map_err(backend_err)?
            .ok_or_else(|| StoreError::EntityNotFound(key.to_string()))
    }

    /// Reads (feature 010): evaluates `source` against one exact state of this store, `at` or the
    /// head (read once), and returns its record. A read never writes: it takes `&self`, and every
    /// write of the backend needs `&mut` (FR-012). `bindings` maps each `state` parameter to an
    /// entity id; an id that does not exist at the position gives an `INVALID_BINDING` record.
    /// A schema mismatch, or a position that is not a state of this store, is an error with no
    /// record (FR-009, FR-013).
    /// Superseded by the unified capability intent (feature 012); frozen.
    pub fn read(
        &self,
        module: &Module,
        source: &ReadSource,
        bindings: &BTreeMap<String, String>,
        input: &Json,
        context: &Json,
        at: Option<&StateRef>,
    ) -> R<ReadExecution> {
        self.read_mode(
            module,
            source,
            bindings,
            input,
            context,
            at,
            ExecutionMode::Fresh,
        )
    }

    #[allow(clippy::too_many_arguments)]
    fn read_mode(
        &self,
        module: &Module,
        source: &ReadSource,
        bindings: &BTreeMap<String, String>,
        input: &Json,
        context: &Json,
        at: Option<&StateRef>,
        mode: ExecutionMode<'_>,
    ) -> R<ReadExecution> {
        let at = match at {
            None => self.head()?.state_ref,
            Some(a) => {
                if self.state_at(a.position)? != *a {
                    return Err(StoreError::EntityNotFound(format!(
                        "{} at position {} is not a state of this store",
                        a.state, a.position
                    )));
                }
                a.clone()
            }
        };
        let at_schema = self.bind_schema(module, at.position)?;
        let snapshot = self.validate_snapshot(module, &at, &at_schema)?;
        let mut state = Map::new();
        if let Some(read) = resolve(module, source) {
            for b in bindings.keys() {
                let is_state = read
                    .params()
                    .iter()
                    .any(|p| p.name() == b && p.role() == ParamRole::State);
                if !is_state {
                    return Err(invalid(format!(
                        "`{b}` is not a state parameter of read `{}`",
                        read.name()
                    )));
                }
            }
            for p in read.params() {
                let (ParamRole::State, Type::Entity(entity)) = (p.role(), p.ty()) else {
                    continue;
                };
                let Some(id) = bindings.get(p.name()) else {
                    continue;
                };
                let key = EntityKey {
                    entity: entity.clone(),
                    id: id.clone(),
                };
                let value = snapshot.values.get(&key).cloned();
                // An identity that does not exist is bound by id alone; evaluation refuses it.
                state.insert(
                    p.name().to_string(),
                    value.unwrap_or_else(|| json!({"id": id})),
                );
            }
        }
        let request = json!({
            "data_version": data_version(&self.store_id, &at),
            "state": state,
            "input": input,
            "context": context,
        });
        let facts = SnapshotFacts {
            snapshot: &snapshot,
            backend: &self.backend,
            position: at.position,
        };
        match mode {
            ExecutionMode::Fresh | ExecutionMode::Replay => Ok(evaluate_read_with(
                module,
                source,
                &request.to_string(),
                &facts,
            )),
            ExecutionMode::ArchivedRead(profile) => {
                execute_read_replay_with(module, source, &request.to_string(), &facts, profile)
                    .map_err(|error| invalid(error.to_string()))
            }
        }
    }

    /// A read intent (feature 010) against this store, at `at` or the head: the capability
    /// boundary for untrusted callers. The intent is validated against the declared read, and
    /// every target must exist at the position (`UNKNOWN_TARGET`); all problems are listed
    /// before anything is evaluated. Context comes from the host.
    /// Superseded by the unified capability intent (feature 012); frozen.
    pub fn read_intent(
        &self,
        module: &Module,
        intent: &str,
        context: &Json,
        at: Option<&StateRef>,
    ) -> R<Result<ReadExecution, IntentRejection>> {
        let at = match at {
            None => self.head()?.state_ref,
            Some(a) => {
                if self.state_at(a.position)? != *a {
                    return Err(StoreError::EntityNotFound(format!(
                        "{} at position {} is not a state of this store",
                        a.state, a.position
                    )));
                }
                a.clone()
            }
        };
        let (parsed, mut errors) = check_read_intent(module, intent, None);
        if let Some(i) = &parsed
            && let Some(read) = module.read(&i.capability)
        {
            for (param, id) in &i.targets {
                let Some(Type::Entity(entity)) = read
                    .params()
                    .iter()
                    .find(|p| p.name() == param && p.role() == ParamRole::State)
                    .map(|p| p.ty())
                else {
                    continue;
                };
                let key = EntityKey {
                    entity: entity.clone(),
                    id: id.clone(),
                };
                if !exists_at(&self.backend, &key, at.position).map_err(backend_err)? {
                    errors.push(IntentError {
                        code: "UNKNOWN_TARGET".into(),
                        message: format!("{key} does not exist at the read's state"),
                        path: format!("targets.{param}"),
                    });
                }
            }
        }
        let intent = match parsed {
            Some(i) if errors.is_empty() => i,
            _ => return Ok(Err(IntentRejection::of(errors))),
        };
        self.read(
            module,
            &ReadSource::Declared(intent.capability),
            &intent.targets,
            &intent.input,
            context,
            Some(&at),
        )
        .map(Ok)
    }

    /// Replays a read record against this store (FR-011): the record's `data_version` must name
    /// a state of this store; the read is evaluated again at that position, with facts derived
    /// from the store, and compared byte for byte. Differences, including a foreign store or
    /// state, are reported in the result; only backend failures are errors.
    pub fn replay_read(&self, module: &Module, record: &str) -> R<ReplayResult> {
        let prepared = match prepare_read_replay(module, record) {
            Ok(prepared) => prepared,
            Err(diff) => return Ok(ReplayResult::mismatch(diff.to_string())),
        };
        let dv = prepared.data_version();
        let Some(at) = self.state_of_data_version(dv)? else {
            return Ok(ReplayResult::mismatch(format!(
                "data_version: \"{dv}\" is not a state of this store"
            )));
        };
        let historical = (|| {
            // Preserve Store prevalidation and its prerequisite order even when
            // Core proves that the attempted request never reached evaluation.
            let at_schema = self.bind_schema(module, at.position)?;
            let snapshot = self.validate_snapshot(module, &at, &at_schema)?;
            self.verify_replay_history(&at)?;
            match reproduce_read_transport_refusal(module, &prepared) {
                Ok(Some(reproduced)) => return Ok(reproduced.replay_result()),
                Err(diff) => return Ok(ReplayResult::mismatch(diff.to_string())),
                Ok(None) => {}
            }
            let mut state = Map::new();
            for (param, identity) in prepared
                .store_bindings(module)
                .map_err(|error| invalid(error.to_string()))?
            {
                let key = EntityKey {
                    entity: identity.entity,
                    id: identity.id,
                };
                state.insert(
                    param,
                    snapshot
                        .values
                        .get(&key)
                        .cloned()
                        .unwrap_or_else(|| json!({"id":key.id})),
                );
            }
            let facts = SnapshotFacts {
                snapshot: &snapshot,
                backend: &self.backend,
                position: at.position,
            };
            let execution =
                execute_prepared_read_replay_with(module, &prepared, Json::Object(state), &facts)
                    .map_err(|error| invalid(error.to_string()))?;
            Ok(compare_prepared_read_replay(&prepared, &execution))
        })();
        match historical {
            Ok(result) => Ok(result),
            Err(StoreError::Backend(m)) => Err(StoreError::Backend(m)),
            Err(e) => Ok(ReplayResult::mismatch(format!("the read was refused: {e}"))),
        }
    }

    /// Replays unified invocation evidence against the recorded store position.
    pub fn replay_invocation(&self, module: &Module, record: &str) -> R<ReplayResult> {
        use behavior_core::invocation::{
            compare_invocation_replay_evidence, complete_invocation_replay,
            prepare_invocation_replay, reproduce_invocation_replay,
        };
        let prepared = match prepare_invocation_replay(module, record) {
            Ok(prepared) => prepared,
            Err(diff) => return Ok(ReplayResult::mismatch(diff.to_string())),
        };
        let reproduced = match reproduce_invocation_replay(module, &prepared) {
            Ok(reproduced) => reproduced,
            Err(diff) => return Ok(ReplayResult::mismatch(diff.to_string())),
        };
        let dv = reproduced.data_version();
        let Some(at) = self.state_of_data_version(dv)? else {
            return Ok(ReplayResult::mismatch(format!(
                "data_version: `{dv}` is not a state of this store"
            )));
        };
        let historical = (|| {
            reproduced
                .check_module(module)
                .map_err(|error| invalid(error.to_string()))?;
            // Schema mismatch keeps priority over additional event/content reads.
            let at_schema = self.bind_schema(module, at.position)?;
            if reproduced.is_archived_refusal() || reproduced.requested().is_none() {
                self.verify_replay_history(&at)?;
                let answers = self.replay_evidence_answers(
                    module,
                    &at_schema,
                    &at,
                    reproduced.evidence_requests(),
                )?;
                compare_invocation_replay_evidence(module, &reproduced, &answers)
                    .map_err(|error| invalid(error.to_string()))?;
                return Ok(reproduced.replay_result());
            }
            let requested = reproduced
                .requested()
                .ok_or_else(|| invalid("reproduced invocation has no decoded request"))?;
            if reproduced.is_archived_action() {
                self.verify_replay_history(&at)?;
                // Core already established the wrapper's requested bindings,
                // alias/type rules and relation to the inner state. Historical
                // rederivation checks those captured values and facts against
                // actual surviving versions under the immutable decision profile.
                self.rederive_archived(
                    module,
                    &at_schema,
                    &at,
                    &reproduced.stored()["outcome"]["record"],
                )?;
                return Ok(reproduced.replay_result());
            }
            // Ordinary Store routes retain full parent prevalidation, including
            // resolution refusals labelled DECODE such as UNKNOWN_CAPABILITY.
            self.validate_snapshot(module, &at, &at_schema)?;
            self.verify_replay_history(&at)?;
            if reproduced.is_resolution_refusal() {
                let answers = self.replay_evidence_answers(
                    module,
                    &at_schema,
                    &at,
                    reproduced.evidence_requests(),
                )?;
                compare_invocation_replay_evidence(module, &reproduced, &answers)
                    .map_err(|error| invalid(error.to_string()))?;
                // Truth of the performed binding statuses proves the same
                // refusal. A differing resolution cannot reach body evaluation.
                return Ok(reproduced.replay_result());
            }
            let mode = match reproduced.read_profile() {
                Some(profile) => ExecutionMode::ArchivedRead(profile),
                None => ExecutionMode::Replay,
            };
            let actual = self.invoke_mode(
                module,
                requested,
                "1970-01-01T00:00:00Z",
                None,
                Some(&at),
                mode,
            )?;
            complete_invocation_replay(&reproduced, actual.record)
                .map_err(|error| invalid(error.to_string()))
        })();
        match historical {
            Ok(result) => Ok(result),
            Err(StoreError::Backend(message)) => Err(StoreError::Backend(message)),
            Err(error) => {
                let boundary = if reproduced.is_archived_action() {
                    "historical invocation"
                } else if reproduced.is_archived_refusal() {
                    "decode evidence"
                } else {
                    "invocation"
                };
                Ok(ReplayResult::mismatch(format!(
                    "{boundary} was refused: {error}"
                )))
            }
        }
    }

    /// The state a `data_version` names, if it is a state of this store.
    fn state_of_data_version(&self, dv: &str) -> R<Option<StateRef>> {
        let parts: Vec<&str> = dv.split(';').collect();
        let [store, state, position] = parts.as_slice() else {
            return Ok(None);
        };
        let (Some(store), Some(state), Some(position)) = (
            store.strip_prefix("store:"),
            state.strip_prefix("state:"),
            position
                .strip_prefix("position:")
                .and_then(|p| p.parse::<u64>().ok()),
        ) else {
            return Ok(None);
        };
        if store != self.store_id || position > self.head()?.state_ref.position {
            return Ok(None);
        }
        let at = self.state_at(position)?;
        Ok((at.state == state).then_some(at))
    }

    /// Evaluates `action` against one consistent snapshot: the head is read once and every bound
    /// state entity as of that position (FR-018). `bindings` maps each state parameter to an
    /// entity id; input and context are host-supplied. Allowed decisions get a commit bundle.
    #[allow(clippy::too_many_arguments)]
    /// Superseded by the unified capability intent (feature 012); frozen.
    pub fn evaluate(
        &self,
        module: &Module,
        action: &str,
        bindings: &BTreeMap<String, String>,
        input: &Json,
        context: &Json,
        commit_time: &str,
        evidence: Option<Evidence>,
    ) -> R<Evaluation> {
        if !valid_timestamp(commit_time) {
            return Err(invalid(format!(
                "commit time `{commit_time}` is not RFC 3339 UTC"
            )));
        }
        let head = self.head()?;
        let at = head.state_ref.clone();
        // Exact store-schema binding, before anything is evaluated (FR-005).
        let at_schema = self.bind_schema(module, at.position)?;
        let snapshot = self.validate_snapshot(module, &at, &at_schema)?;
        let store = self.store_id.clone();
        let a = module
            .action(action)
            .ok_or_else(|| invalid(format!("unknown action `{action}`")))?;
        let mut state = Map::new();
        let mut loaded: BTreeMap<String, EntityVersion> = BTreeMap::new();
        for p in a.params() {
            if !matches!(p.role(), ParamRole::State | ParamRole::Read) {
                continue;
            }
            let Type::Entity(entity) = p.ty() else {
                continue;
            };
            let id = bindings.get(p.name()).ok_or_else(|| {
                StoreError::EntityNotFound(format!("no binding for state parameter `{}`", p.name()))
            })?;
            let key = EntityKey {
                entity: entity.clone(),
                id: id.clone(),
            };
            if !exists_at(&self.backend, &key, at.position).map_err(backend_err)? {
                return Err(StoreError::EntityNotFound(key.to_string()));
            }
            let v = self
                .backend
                .version_at(&key, at.position)
                .map_err(backend_err)?
                .ok_or_else(|| StoreError::EntityNotFound(key.to_string()))?;
            state.insert(p.name().to_string(), v.value.clone());
            loaded.insert(p.name().to_string(), v);
        }
        for b in bindings.keys() {
            if !loaded.contains_key(b) {
                return Err(invalid(format!(
                    "`{b}` is not a state parameter of `{action}`"
                )));
            }
        }
        let request = json!({
            "action": action,
            "data_version": data_version(&store, &at),
            "state": state,
            "input": input,
            "context": context,
        });
        let facts = SnapshotFacts {
            snapshot: &snapshot,
            backend: &self.backend,
            position: at.position,
        };
        // Preserve the ordinary path's original allocation lifetime through
        // bundle construction. Early destruction here changes allocator reuse
        // across complete snapshots without changing their semantic content.
        let _ordinary_record;
        let (record, observed) = if let Some((prepared, _)) = self.prepared_for(&snapshot) {
            _ordinary_record = None;
            let checked = prepared.evaluate(module, &request.to_string(), &facts);
            let result = (
                checked.record().as_json().clone(),
                checked.observed().clone(),
            );
            self.retain_checked(&snapshot, checked);
            result
        } else {
            let (record, observed) = evaluate_with(module, &request.to_string(), &facts);
            let raw = record.as_json().clone();
            _ordinary_record = Some(record);
            (raw, observed)
        };
        if record["result"] != "ALLOW" {
            return Ok(Evaluation {
                record,
                bundle: None,
            });
        }
        let bundle = self.bundle_from_evaluation(
            module,
            a,
            at,
            &at_schema,
            &loaded,
            record,
            &observed,
            commit_time,
            evidence,
            None,
        )?;
        Ok(Evaluation {
            record: bundle.record.clone(),
            bundle: Some(bundle),
        })
    }

    #[allow(clippy::too_many_arguments)]
    fn bundle_from_evaluation(
        &self,
        module: &Module,
        action: &behavior_core::semantic::module::ActionItem,
        at: StateRef,
        at_schema: &SchemaRef,
        loaded: &BTreeMap<String, EntityVersion>,
        record: Json,
        observed: &behavior_core::eval::Observed,
        commit_time: &str,
        evidence: Option<Evidence>,
        evaluated_hash: Option<&str>,
    ) -> R<CommitBundle> {
        #[cfg(test)]
        replay_tests::note_bundle();
        let mut touched = BTreeMap::new();
        for entity in touched_types(module, action) {
            if let Some(d) = at_schema.declarations.get(&entity) {
                touched.insert(entity, d.clone());
            }
        }
        let v2 = self.genesis.evidence_policy.as_trusted().is_some();
        let history = if v2 {
            Some(self.history_at(at.position)?)
        } else {
            None
        };
        let mut lifecycle = lifecycle_writes(&record)?;
        if v2 {
            lifecycle.sort();
        }
        let mut bundle = CommitBundle {
            format: if v2 {
                crate::documents::TAG_COMMIT_BUNDLE_V2
            } else {
                TAG_COMMIT_BUNDLE
            }
            .into(),
            evaluated_state: at,
            behavior_version: module.behavior_version(),
            store: self.store_id.clone(),
            transition_hash: match evaluated_hash {
                Some(hash) => hash.into(),
                None => transition_hash(&record)?,
            },
            entity_declarations: touched,
            read_set: read_set(&observed.fields, loaded),
            write_set: write_set(&record)?,
            read_facts: facts_json(&observed.facts),
            write_lifecycle: lifecycle,
            record,
            commit_time: commit_time.into(),
            evidence: evidence.map(Into::into),
            evaluated_history: history,
            authorization_context: None,
        };
        if v2 {
            bundle.transition_hash = bundle.governance_candidate()?.hash().into();
        }
        Ok(bundle)
    }

    pub fn invoke_intent(
        &self,
        module: &Module,
        text: &str,
        context: &Json,
        commit_time: &str,
        at: Option<&StateRef>,
    ) -> R<Invocation> {
        self.invoke_intent_mode(module, text, context, commit_time, at, ExecutionMode::Fresh)
    }

    fn invoke_intent_mode(
        &self,
        module: &Module,
        text: &str,
        context: &Json,
        commit_time: &str,
        at: Option<&StateRef>,
        mode: ExecutionMode<'_>,
    ) -> R<Invocation> {
        let head = self.head()?;
        let at = at.cloned().unwrap_or(head.state_ref);
        if self.state_at(at.position)? != at {
            return Err(invalid("invocation position is not a state of this store"));
        }
        self.bind_schema(module, at.position)?;
        let prepared = behavior_core::invocation::prepare_intent(
            module,
            text,
            context,
            &data_version(&self.store_id, &at),
        )
        .map_err(|e| invalid(e.to_string()))?;
        match prepared {
            Err(record) => Ok(Invocation {
                record,
                bundle: None,
            }),
            Ok((requested, metadata)) => {
                let mut result =
                    self.invoke_mode(module, &requested, commit_time, None, Some(&at), mode)?;
                result.record =
                    behavior_core::invocation::with_intent_metadata(result.record, metadata)
                        .map_err(|e| invalid(e.to_string()))?;
                Ok(result)
            }
        }
    }

    /// Resolve one exact snapshot, record every semantic refusal, and return a
    /// candidate only for an ALLOW action evaluated at the captured head.
    pub fn invoke(
        &self,
        module: &Module,
        requested: &behavior_core::invocation::RequestedInvocation,
        commit_time: &str,
        evidence: Option<Evidence>,
        at: Option<&StateRef>,
    ) -> R<Invocation> {
        self.invoke_mode(
            module,
            requested,
            commit_time,
            evidence,
            at,
            ExecutionMode::Fresh,
        )
    }

    fn invoke_mode(
        &self,
        module: &Module,
        requested: &behavior_core::invocation::RequestedInvocation,
        commit_time: &str,
        evidence: Option<Evidence>,
        at: Option<&StateRef>,
        mode: ExecutionMode<'_>,
    ) -> R<Invocation> {
        use behavior_core::invocation::{capability_params, invoke_resolved, refusal_record};
        let head = self.head()?;
        let at = at.cloned().unwrap_or_else(|| head.state_ref.clone());
        // The captured head already names this store's exact current snapshot;
        // historical positions still undergo full state-reference validation.
        if at != head.state_ref && self.state_at(at.position)? != at {
            return Err(invalid("invocation position is not a state of this store"));
        }
        let at_schema = self.bind_schema(module, at.position)?;
        let snapshot = self.validate_snapshot(module, &at, &at_schema)?;
        let mut loaded = BTreeMap::new();
        if let Some((_, params)) = capability_params(module, requested.capability()) {
            for param in params {
                let (ParamRole::State, Type::Entity(entity)) = (param.role(), param.ty()) else {
                    continue;
                };
                let Some(identity) = requested
                    .bindings()
                    .get(param.name())
                    .filter(|i| i.entity == *entity)
                else {
                    continue;
                };
                let key = EntityKey {
                    entity: entity.clone(),
                    id: identity.id.clone(),
                };
                if exists_at(&self.backend, &key, at.position).map_err(backend_err)? {
                    let version = self
                        .backend
                        .version_at(&key, at.position)
                        .map_err(backend_err)?
                        .ok_or_else(|| {
                            StoreError::Backend(format!(
                                "existing {key} has no version at {}",
                                at.position
                            ))
                        })?;
                    loaded.insert(param.name().to_owned(), version);
                }
            }
        }
        let resolver = InvocationResolver {
            values: loaded
                .iter()
                .filter_map(|(name, version)| {
                    requested
                        .bindings()
                        .get(name)
                        .map(|identity| (identity.clone(), &version.value))
                })
                .collect(),
            data_version: data_version(&self.store_id, &at),
        };
        let resolved = match behavior_core::invocation::resolve(module, requested, &resolver) {
            Ok(resolved) => resolved,
            Err(refusal) => {
                return Ok(Invocation {
                    record: refusal_record(
                        module,
                        &requested.as_json(),
                        &resolver.data_version,
                        refusal,
                    )
                    .map_err(|e| invalid(e.to_string()))?,
                    bundle: None,
                });
            }
        };
        let facts = SnapshotFacts {
            snapshot: &snapshot,
            backend: &self.backend,
            position: at.position,
        };
        let (record, observed) = match mode {
            ExecutionMode::Fresh | ExecutionMode::Replay => {
                invoke_resolved(module, resolved, &facts).map_err(|e| invalid(e.to_string()))?
            }
            ExecutionMode::ArchivedRead(profile) => {
                behavior_core::invocation::invoke_resolved_read_replay(
                    module, resolved, &facts, profile,
                )
                .map_err(|error| invalid(error.to_string()))?
            }
        };
        // Only fresh invocation can construct commit authority. Replay still
        // establishes the same historical snapshot/bindings/facts and record.
        let bundle = if matches!(mode, ExecutionMode::Fresh)
            && at == head.state_ref
            && record.as_json()["kind"] == "action"
        {
            match record.inner_record().filter(|r| r["result"] == "ALLOW") {
                Some(inner) => {
                    if !valid_timestamp(commit_time) {
                        return Err(invalid("invalid invocation commit time"));
                    }
                    let action = module
                        .action(requested.capability())
                        .ok_or_else(|| invalid("resolved action missing"))?;
                    Some(self.bundle_from_evaluation(
                        module,
                        action,
                        at,
                        &at_schema,
                        &loaded,
                        inner.clone(),
                        &observed,
                        commit_time,
                        evidence,
                        record.as_json()["outcome"]["record_id"].as_str(),
                    )?)
                }
                None => None,
            }
        } else {
            None
        };
        Ok(Invocation { record, bundle })
    }

    /// Commits `bundle` on `expected_parent` (research R8): idempotency, whole-state conflict,
    /// validation with engine-derived dependencies, the evidence policy, then the backend's atomic
    /// compare-and-set.
    pub fn commit(
        &mut self,
        module: &Module,
        expected_parent: &StateRef,
        bundle: &CommitBundle,
    ) -> R<Committed> {
        self.commit_impl(module, expected_parent, bundle, None)
    }
    fn commit_impl(
        &mut self,
        module: &Module,
        expected_parent: &StateRef,
        bundle: &CommitBundle,
        context: Option<&behavior_verify::governance::trusted::AuthorizationContextV2>,
    ) -> R<Committed> {
        let v2 = self.genesis.evidence_policy.as_trusted().is_some();
        if v2 != (bundle.format == crate::documents::TAG_COMMIT_BUNDLE_V2) {
            return Err(invalid("bundle/genesis format pairing differs"));
        }
        let mut archived_bundle = bundle.clone();
        let genesis = std::sync::Arc::clone(&self.genesis);
        let store = self.store_id.clone();
        if ![TAG_COMMIT_BUNDLE, crate::documents::TAG_COMMIT_BUNDLE_V2]
            .contains(&bundle.format.as_str())
        {
            return Err(invalid(format!("bundle format `{}`", bundle.format)));
        }
        if bundle.store != store {
            return Err(invalid("the bundle was evaluated against another store"));
        }
        // Exact store-schema binding at the evaluated position, before the module is used
        // (FR-005).
        let at_schema = self.bind_schema(module, bundle.evaluated_state.position)?;
        if bundle.record["result"] != "ALLOW" {
            return Err(StoreError::NothingToCommit(format!(
                "the decision is {}",
                bundle.record["result"]
            )));
        }
        if bundle.transition_hash
            != if v2 {
                bundle.governance_candidate()?.hash().to_string()
            } else {
                transition_hash(&bundle.record)?
            }
        {
            return Err(invalid("the transition hash does not match the record"));
        }
        // 0. The module must be the exact content-addressed behavior version that produced the
        //    decision: hash(module) == bundle.behavior_version == record.behavior_version, checked
        //    before the module is used for anything.
        let version = module.behavior_version();
        if version != bundle.behavior_version
            || bundle.record["behavior_version"] != bundle.behavior_version.as_str()
        {
            return Err(invalid(format!(
                "the module is behavior {version}; the bundle and its record were made by {} and {}",
                bundle.behavior_version, bundle.record["behavior_version"]
            )));
        }
        let parent = &bundle.evaluated_state;
        let next_position = parent
            .position
            .checked_add(1)
            .ok_or_else(|| StoreError::Contract {
                code: "HISTORY_POSITION_EXHAUSTED",
                message: "history position cannot advance".into(),
            })?;
        // 1. Idempotency: a transition evaluated at p can only have become record p + 1.
        if let Some(r) = self.backend.record(next_position).map_err(backend_err)?
            && r.committed_on == *parent
            && r.bundle
                .as_ref()
                .is_some_and(|b| b.transition_hash == bundle.transition_hash)
        {
            let original = r
                .bundle
                .as_ref()
                .ok_or_else(|| invalid("recovered event lacks bundle"))?;
            if bundle
                .authorization_context
                .as_ref()
                .is_some_and(|q| Some(q) != original.authorization_context.as_ref())
            {
                return Err(invalid("recovery context differs from archived context"));
            }
            let mut incoming = bundle.clone();
            incoming.authorization_context = original.authorization_context.clone();
            // Retry time is not candidate semantics. Recovery validates the
            // original complete committed event under its original context.
            incoming.commit_time = original.commit_time.clone();
            if incoming.evidence.is_none() {
                incoming.evidence = original.evidence.clone();
            }
            if incoming != *original
                || expected_parent != parent
                || r.bundle_hash != original.hash()?
                || r.previous_record
                    != if v2 {
                        bundle
                            .evaluated_history
                            .as_ref()
                            .ok_or_else(|| invalid("missing exact parent"))?
                            .record
                            .clone()
                    } else {
                        self.history_at(parent.position)?.record
                    }
            {
                return Err(invalid(
                    "idempotent recovery differs from the original complete bundle/history event",
                ));
            }
            r.check_kind()?;
            let original_id = r.hash()?;
            if self.history_at(r.position)?.record != original_id {
                return Err(invalid(
                    "recovered event is not canonical committed history",
                ));
            }
            if v2 {
                self.rederive_archived(module, &at_schema, parent, &original.record)?;
                check_reproduced_decision_evidence(
                    module,
                    &original.record,
                    &original.governance_candidate()?,
                    &genesis,
                    original.evidence.as_ref(),
                    original
                        .authorization_context
                        .as_ref()
                        .map(|q| {
                            let policy = original
                                .evidence
                                .as_ref()
                                .and_then(|e| e.as_trusted())
                                .ok_or_else(|| invalid("archived context has no trusted policy"))?;
                            behavior_verify::governance::trusted::AuthorizationContextV2::from_json(
                                &q.to_string(),
                                policy.execution_policy(),
                            )
                            .map_err(trusted_err)
                        })
                        .transpose()?
                        .as_ref(),
                    &original.commit_time,
                )?;
            }
            return Ok(Committed {
                record_id: original_id,
                result_state: r.result_state.clone(),
                already: true,
                evidence_trust: r
                    .authorization
                    .as_ref()
                    .map(|_| if v2 { "authenticated" } else { "structural" }),
            });
        }
        if !v2 && genesis.evidence_policy.require() == Require::CommitAuthorization {
            return Err(StoreError::Contract {
                code: "TRUSTED_GOVERNANCE_UPGRADE_REQUIRED",
                message: "fresh required-governance writes need explicit adoption into v2 history"
                    .into(),
            });
        }
        if !v2 && behavior_core::serialize::to_wire_value(module)["ir_version"] == "0.8" {
            return Err(StoreError::Contract {
                code: "HISTORY_FORMAT_UPGRADE_REQUIRED",
                message: "Wire 0.8 requires a v2 genesis".into(),
            });
        }
        // 2. Consistency and whole-state conflict.
        if expected_parent != parent {
            return Err(invalid(
                "the expected parent is not the state the bundle was evaluated against",
            ));
        }
        let head = self.head()?;
        if head.state_ref != *parent {
            return Err(self.conflict(&head, parent));
        }
        if v2 {
            let actual = self.history_with_head(parent.position, &head)?;
            if bundle.evaluated_history.as_ref() != Some(&actual) {
                return Err(StoreError::Contract {
                    code: "HISTORY_CONFLICT",
                    message: "candidate's exact committed parent differs".into(),
                });
            }
        }
        // 3. Validation.
        if bundle.record["data_version"] != data_version(&store, parent).as_str() {
            return Err(invalid("the record is not bound to this store and state"));
        }
        if !valid_timestamp(&bundle.commit_time) {
            return Err(invalid("commit time is not RFC 3339 UTC"));
        }
        // Declarations: derived from the action's entity parameters, never taken from the bundle.
        // Every touched entity must be declared by the store's schema at the parent (which the
        // module declares exactly), and the bundle's list must be exactly that set.
        let action_name = bundle.record["action"]["name"].as_str().unwrap_or_default();
        let action = module
            .action(action_name)
            .ok_or_else(|| invalid(format!("unknown action `{action_name}`")))?;
        let mut touched = BTreeMap::new();
        for entity in touched_types(module, action) {
            let Some(d) = at_schema.declarations.get(&entity) else {
                return Err(StoreError::EntityDeclarationMismatch(format!(
                    "`{entity}` is not an entity type of the store's schema"
                )));
            };
            touched.insert(entity, d.clone());
        }
        if bundle.entity_declarations != touched {
            return Err(invalid(
                "the bundle's entity declarations are not the action's",
            ));
        }
        let (parent_versions, derived_reads, derived_writes, derived_facts) =
            self.rederive(module, &at_schema, parent, &bundle.record)?;
        if derived_facts != bundle.read_facts {
            return Err(invalid(
                "the read facts are not the ones the evaluation observed at the parent",
            ));
        }
        let mut lifecycle = lifecycle_writes(&bundle.record)?;
        if v2 {
            lifecycle.sort();
        }
        if lifecycle != bundle.write_lifecycle {
            return Err(invalid("the lifecycle writes are not the evaluation's"));
        }
        if derived_reads != bundle.read_set {
            return Err(invalid(
                "the read set is not the one the evaluation observed",
            ));
        }
        if derived_writes != bundle.write_set {
            return Err(invalid("the write set is not the evaluation's changes"));
        }
        for r in &bundle.read_set {
            let key = EntityKey {
                entity: r.entity.clone(),
                id: r.id.clone(),
            };
            match parent_versions.get(&key) {
                Some(v) if v.revision == r.revision => {}
                _ => {
                    return Err(invalid(format!(
                        "{key}: revision does not match the parent"
                    )));
                }
            }
        }
        let evidence_policy = genesis.evidence_policy.hash()?;
        let authorization = if v2 {
            let candidate = bundle.governance_candidate()?;
            let identity = check_trusted_evidence(
                &behavior_verify::governance::trusted::GovernanceSubject::Module(module),
                &candidate,
                &genesis,
                bundle.evidence.as_ref(),
                context,
                &bundle.commit_time,
            )?;
            if bundle.evidence.is_some() {
                let q = context
                    .ok_or_else(|| StoreError::Contract {
                        code: "CONTEXT_REQUIRED",
                        message: "fresh trusted evidence needs independent context".into(),
                    })?
                    .as_json();
                if bundle
                    .authorization_context
                    .as_ref()
                    .is_some_and(|old| old != &q)
                {
                    return Err(StoreError::Contract {
                        code: "CONTEXT_MISMATCH",
                        message: "caller archived context differs from supplied context".into(),
                    });
                }
                archived_bundle.authorization_context = Some(q);
            } else if bundle.authorization_context.is_some() {
                return Err(invalid("authorization context without governed evidence"));
            }
            identity
        } else {
            crate::store::check_evidence(&genesis, bundle)?
        };
        // 4. Build the new versions, state and record.
        let position = next_position;
        let mut new_values: BTreeMap<EntityKey, Json> = BTreeMap::new();
        for w in &bundle.write_set {
            let key = EntityKey {
                entity: w.entity.clone(),
                id: w.id.clone(),
            };
            let Some(old) = parent_versions.get(&key) else {
                return Err(StoreError::EntityUniverseChanged(format!(
                    "{key} is not in the parent state"
                )));
            };
            if old.value.get(&w.field) != Some(&w.old) {
                return Err(invalid(format!(
                    "{key}.{}: old value does not match",
                    w.field
                )));
            }
            let value = new_values.entry(key).or_insert_with(|| old.value.clone());
            value[&w.field] = w.new.clone();
        }
        let mut acc = Accumulator::from_hex(&head.acc_num, &head.acc_den)?;
        let mut new_versions = Vec::new();
        let mut ref_changes: Vec<RefChange> = Vec::new();
        let edge = |target: EntityKey, source: &EntityKey, field: &str, op: &str| RefChange {
            target,
            source: source.clone(),
            field: field.to_string(),
            op: op.to_string(),
        };
        for (key, value) in new_values {
            let old = &parent_versions[&key];
            if old.value == value {
                continue;
            }
            // Retargeted references change the derived index.
            let before = references_of(module, &key.entity, &old.value);
            let after = references_of(module, &key.entity, &value);
            for (f, t) in &before {
                if !after.contains(&(f.clone(), t.clone())) {
                    ref_changes.push(edge(t.clone(), &key, f, "drop"));
                }
            }
            for (f, t) in &after {
                if !before.contains(&(f.clone(), t.clone())) {
                    ref_changes.push(edge(t.clone(), &key, f, "add"));
                }
            }
            let decl = at_schema.declarations.get(&key.entity).ok_or_else(|| {
                StoreError::EntityDeclarationMismatch(format!("`{}`", key.entity))
            })?;
            let mut v = EntityVersion {
                content_hash: String::new(),
                entity: key.entity.clone(),
                id: key.id.clone(),
                revision: old
                    .revision
                    .checked_add(1)
                    .ok_or_else(|| StoreError::Contract {
                        code: "ENTITY_REVISION_EXHAUSTED",
                        message: format!("{key}: revision cannot advance"),
                    })?,
                created_at: position,
                value,
            };
            v.content_hash = v.content(decl).hash()?;
            acc.remove(&old.content_hash)?;
            acc.insert(&v.content_hash)?;
            new_versions.push(v);
        }
        // Lifecycle (feature 006): creations and removals, in record order.
        let mut created = Vec::new();
        let mut removed = Vec::new();
        let mut removals = Vec::new();
        for l in bundle.record["lifecycle"].as_array().into_iter().flatten() {
            let (Some(op), Some(entity), Some(id)) =
                (l["op"].as_str(), l["entity"].as_str(), l["id"].as_str())
            else {
                return Err(invalid("malformed lifecycle entry"));
            };
            let k = key(entity, id);
            let decl = at_schema
                .declarations
                .get(entity)
                .ok_or_else(|| StoreError::EntityDeclarationMismatch(format!("`{entity}`")))?;
            match op {
                "create" => {
                    if self
                        .backend
                        .used_at(&k, parent.position)
                        .map_err(backend_err)?
                    {
                        return Err(StoreError::EntityIdAlreadyUsed(format!(
                            "{k} was already used; an identity names one lifetime"
                        )));
                    }
                    let mut v = EntityVersion {
                        content_hash: String::new(),
                        entity: entity.to_string(),
                        id: id.to_string(),
                        revision: 1,
                        created_at: position,
                        value: l["value"].clone(),
                    };
                    v.content_hash = v.content(decl).hash()?;
                    acc.insert(&v.content_hash)?;
                    for (f, t) in references_of(module, entity, &v.value) {
                        ref_changes.push(edge(t, &k, &f, "add"));
                    }
                    created.push(v);
                }
                "remove" => {
                    if !exists_at(&self.backend, &k, parent.position).map_err(backend_err)? {
                        return Err(StoreError::EntityNotFound(format!(
                            "{k} does not exist at the parent"
                        )));
                    }
                    let old = parent_versions
                        .get(&k)
                        .cloned()
                        .ok_or_else(|| invalid(format!("{k} is not bound by the action")))?;
                    if old.value != l["value"] {
                        return Err(invalid(format!("{k}: removed value does not match")));
                    }
                    acc.remove(&old.content_hash)?;
                    for (f, t) in references_of(module, entity, &old.value) {
                        ref_changes.push(edge(t, &k, &f, "drop"));
                    }
                    removed.push(RemovedEntity {
                        entity: entity.to_string(),
                        id: id.to_string(),
                        last_revision: old.revision,
                        last_content_hash: old.content_hash.clone(),
                    });
                    removals.push(k);
                }
                other => return Err(invalid(format!("unknown lifecycle op `{other}`"))),
            }
        }
        ref_changes.sort();
        self.check_integrity(parent.position, &removals, &created, &ref_changes)?;
        let result_state = StateRef {
            state: acc.state_id()?,
            position,
        };
        let bundle_hash = archived_bundle.hash()?;
        let record = TransitionRecord {
            format: if v2 {
                crate::documents::TAG_TRANSITION_RECORD_V2
            } else {
                TAG_TRANSITION_RECORD
            }
            .into(),
            position,
            previous_record: head.last_record.clone(),
            kind: if v2 { Some("action".into()) } else { None },
            bundle: Some(archived_bundle),
            migration: None,
            bundle_hash,
            evaluated_against: parent.clone(),
            committed_on: parent.clone(),
            result_state: result_state.clone(),
            new_versions: new_versions.clone(),
            evidence_policy,
            authorization,
            created: created.clone(),
            removed,
            ref_changes: ref_changes.clone(),
        };
        let record_id = record.hash()?;
        let (n, d) = acc.normalize()?.to_hex();
        let new_head = Head {
            state_ref: result_state.clone(),
            acc_num: n,
            acc_den: d,
            last_record: record_id.clone(),
            schema: head.schema.clone(),
        };
        let carry = self.validate_incremental_child_at(
            module,
            parent,
            &at_schema,
            &record,
            Some((&head.last_record, &record_id)),
        )?;
        // 5. The atomic compare-and-set.
        let mut versions = new_versions;
        versions.extend(created);
        match self
            .backend
            .commit(
                &head.last_record,
                &versions,
                &removals,
                &ref_changes,
                &record,
                &new_head,
            )
            .map_err(backend_err)?
        {
            CasOutcome::Applied => {
                self.carry_incremental_child(carry, &new_head, &versions, &removals, &ref_changes);
                Ok(Committed {
                    record_id,
                    result_state,
                    already: false,
                    evidence_trust: record
                        .authorization
                        .as_ref()
                        .map(|_| if v2 { "authenticated" } else { "structural" }),
                })
            }
            CasOutcome::HeadMoved => {
                let now = self.head()?;
                Err(self.conflict(&now, parent))
            }
        }
    }

    /// Applies `migration` from `source` to `target` as one atomic transition at the next position
    /// (feature 009, FR-011, research R6). The store's current schema must be the migration's
    /// source; every entity at the head is read, the migration is applied to that complete,
    /// immutable universe (source validation, requirements, entity-local transforms, target
    /// validation, none of which any policy can skip), and the new versions, reference-index
    /// changes, migration record and a head naming the new schema are committed with one
    /// compare-and-set.
    pub fn migrate(
        &mut self,
        migration: &behavior_core::migration::Migration,
        source: &Module,
        target: &Module,
        commit_time: &str,
        evidence: Option<Evidence>,
    ) -> R<Committed> {
        if self.genesis.evidence_policy.as_trusted().is_some() {
            if evidence.is_some() {
                return Err(invalid(
                    "v2 migration cannot accept unsigned legacy evidence",
                ));
            }
            let prepared = self.prepare_migration(source, target, migration, commit_time, None)?;
            return self
                .commit_prepared_migration(source, target, migration, &prepared, None, None);
        }
        if self.genesis.evidence_policy.for_migration().0 == Require::CommitAuthorization {
            return Err(StoreError::Contract {
                code: "TRUSTED_GOVERNANCE_UPGRADE_REQUIRED",
                message: "fresh required-governance migration needs v2 adoption".into(),
            });
        }
        use behavior_core::migration::{MigrationRefusal, SourceEntity, apply_migration};
        if !valid_timestamp(commit_time) {
            return Err(invalid(format!(
                "commit time `{commit_time}` is not RFC 3339 UTC"
            )));
        }
        let head = self.head()?;
        let parent = head.state_ref.clone();
        let current = self.head_schema(&head)?;
        if current.hash != migration.source_schema() {
            return Err(StoreError::Migration(MigrationRefusal {
                code: "MIGRATION_SCHEMA_MISMATCH",
                message: format!(
                    "the store's current schema is {}; migration {} applies to {}",
                    current.hash,
                    migration.hash(),
                    migration.source_schema()
                ),
                rule: None,
                entities: Vec::new(),
                count: 0,
            }));
        }
        // The complete source universe at the head.
        let mut parent_versions: BTreeMap<EntityKey, EntityVersion> = BTreeMap::new();
        let mut entities = Vec::new();
        for t in current.declarations.keys() {
            let mut keys = self
                .backend
                .keys_at(t, parent.position)
                .map_err(backend_err)?;
            keys.sort();
            for k in keys {
                let v = self
                    .backend
                    .version_at(&k, parent.position)
                    .map_err(backend_err)?
                    .ok_or_else(|| StoreError::EntityNotFound(k.to_string()))?;
                entities.push(SourceEntity {
                    entity: k.entity.clone(),
                    value: v.value.clone(),
                });
                parent_versions.insert(k, v);
            }
        }
        let out =
            apply_migration(migration, source, target, &entities).map_err(StoreError::Migration)?;
        self.commit_migration_outcome(
            migration,
            source,
            target,
            &head,
            &parent_versions,
            out,
            commit_time,
            evidence.as_ref(),
            None,
        )
    }

    #[allow(clippy::too_many_arguments, clippy::type_complexity)]
    fn commit_migration_outcome(
        &mut self,
        migration: &behavior_core::migration::Migration,
        source: &Module,
        target: &Module,
        head: &Head,
        parent_versions: &BTreeMap<EntityKey, EntityVersion>,
        out: behavior_core::migration::Migrated,
        commit_time: &str,
        legacy_evidence: Option<&Evidence>,
        trusted: Option<(
            Json,
            Option<crate::documents::CommitEvidence>,
            Option<Json>,
            Option<String>,
        )>,
    ) -> R<Committed> {
        let parent = head.state_ref.clone();
        let current = self.head_schema(head)?;
        let (_, target_schema) = migration.schemas();
        let evidence_policy = self.genesis.evidence_policy.hash()?;
        let authorization = match &trusted {
            Some(t) => t.3.clone(),
            None => self.migration_evidence(legacy_evidence, migration, &parent)?,
        };
        let verification = legacy_evidence
            .map(|e| e.authorization["verification"].clone())
            .filter(|v| !v.is_null());
        // New versions under the target declarations, and the reference-index changes.
        let position = parent
            .position
            .checked_add(1)
            .ok_or_else(|| StoreError::Contract {
                code: "HISTORY_POSITION_EXHAUSTED",
                message: "history position cannot advance".into(),
            })?;
        let mut acc = Accumulator::from_hex(&head.acc_num, &head.acc_den)?;
        let mut new_versions = Vec::new();
        let mut ref_changes: Vec<RefChange> = Vec::new();
        for m in out.entities.iter().filter(|m| m.migrated) {
            let k = key(&m.entity, &m.id);
            let old = parent_versions
                .get(&k)
                .ok_or_else(|| StoreError::EntityNotFound(k.to_string()))?;
            let decl = target_schema
                .declarations
                .get(&m.entity)
                .ok_or_else(|| StoreError::EntityDeclarationMismatch(format!("`{}`", m.entity)))?;
            let mut v = EntityVersion {
                content_hash: String::new(),
                entity: m.entity.clone(),
                id: m.id.clone(),
                revision: old
                    .revision
                    .checked_add(1)
                    .ok_or_else(|| StoreError::Contract {
                        code: "ENTITY_REVISION_EXHAUSTED",
                        message: "entity revision cannot advance".into(),
                    })?,
                created_at: position,
                value: m.value.clone(),
            };
            v.content_hash = v.content(decl).hash()?;
            acc.remove(&old.content_hash)?;
            acc.insert(&v.content_hash)?;
            let before = references_of(source, &k.entity, &old.value);
            let after = references_of(target, &k.entity, &v.value);
            for (f, t) in &before {
                if !after.contains(&(f.clone(), t.clone())) {
                    ref_changes.push(RefChange {
                        target: t.clone(),
                        source: k.clone(),
                        field: f.clone(),
                        op: "drop".into(),
                    });
                }
            }
            for (f, t) in &after {
                if !before.contains(&(f.clone(), t.clone())) {
                    ref_changes.push(RefChange {
                        target: t.clone(),
                        source: k.clone(),
                        field: f.clone(),
                        op: "add".into(),
                    });
                }
            }
            new_versions.push(v);
        }
        ref_changes.sort();
        let result_state = StateRef {
            state: acc.state_id()?,
            position,
        };
        let bundle = MigrationBundle {
            format: trusted
                .as_ref()
                .map(|_| crate::documents::TAG_MIGRATION_BUNDLE_V2.into()),
            candidate: trusted.as_ref().map(|t| t.0.clone()),
            evidence: trusted.as_ref().and_then(|t| t.1.clone()),
            authorization_context: trusted.as_ref().and_then(|t| t.2.clone()),
            migration_hash: migration.hash(),
            source: current.hash.clone(),
            target: target_schema.hash.clone(),
            target_declarations: target_schema.declarations.clone(),
            previous_schema: head.schema.clone(),
            requirements: out
                .requirements
                .iter()
                .map(|r| RequirementOutcome {
                    name: r.name.clone(),
                    held: r.held,
                })
                .collect(),
            report: out.report.clone(),
            source_validated: true,
            target_validated: true,
            verification,
            commit_time: commit_time.to_string(),
        };
        let record = TransitionRecord {
            format: if trusted.is_some() {
                crate::documents::TAG_TRANSITION_RECORD_V2.into()
            } else {
                TAG_TRANSITION_RECORD.into()
            },
            position,
            previous_record: head.last_record.clone(),
            kind: Some(KIND_MIGRATION.into()),
            bundle: None,
            bundle_hash: bundle.hash()?,
            migration: Some(bundle),
            evaluated_against: parent.clone(),
            committed_on: parent.clone(),
            result_state: result_state.clone(),
            new_versions: new_versions.clone(),
            evidence_policy,
            authorization,
            created: Vec::new(),
            removed: Vec::new(),
            ref_changes: ref_changes.clone(),
        };
        let record_id = record.hash()?;
        let (n, d) = acc.normalize()?.to_hex();
        let new_head = Head {
            state_ref: result_state.clone(),
            acc_num: n,
            acc_den: d,
            last_record: record_id.clone(),
            schema: Some(SchemaRef {
                hash: target_schema.hash.clone(),
                declarations: target_schema.declarations.clone(),
                since: position,
                migration_record: record_id.clone(),
            }),
        };
        match self
            .backend
            .commit(
                &head.last_record,
                &new_versions,
                &[],
                &ref_changes,
                &record,
                &new_head,
            )
            .map_err(backend_err)?
        {
            CasOutcome::Applied => Ok(Committed {
                record_id,
                result_state,
                already: false,
                evidence_trust: record.authorization.as_ref().map(|_| {
                    if trusted.is_some() {
                        "authenticated"
                    } else {
                        "structural"
                    }
                }),
            }),
            CasOutcome::HeadMoved => {
                let now = self.head()?;
                Err(self.conflict(&now, &parent))
            }
        }
    }

    /// The governance evidence a migration needs under the store's evidence policy (FR-019b):
    /// its `migration` section, or what actions need. Returns the bound authorization's hash.
    fn migration_evidence(
        &self,
        evidence: Option<&Evidence>,
        migration: &behavior_core::migration::Migration,
        parent: &StateRef,
    ) -> R<Option<String>> {
        let (require, trusted) = self.genesis.evidence_policy.for_migration();
        match (evidence, require) {
            (None, Require::None) => Ok(None),
            (None, Require::CommitAuthorization) => Err(StoreError::EvidenceRequired(format!(
                "evidence policy {} requires a commit authorization for migrations",
                self.genesis.evidence_policy.hash()?
            ))),
            (Some(e), _) => evidence::check_migration(
                &data_version(&self.store_id, parent),
                migration,
                trusted,
                e,
            )
            .map(Some),
        }
    }

    /// Referential integrity on S' (feature 006, research R6): no surviving reference to a removed
    /// identity, and every added reference points at an entity that exists in S'.
    fn check_integrity(
        &self,
        parent: u64,
        removals: &[EntityKey],
        created: &[EntityVersion],
        changes: &[RefChange],
    ) -> R<()> {
        let removed: BTreeSet<&EntityKey> = removals.iter().collect();
        for t in removals {
            let mut incoming: BTreeSet<(String, String, String)> = self
                .backend
                .incoming_at(t, parent)
                .map_err(backend_err)?
                .into_iter()
                .map(|e| (e.entity, e.id, e.field))
                .collect();
            for c in changes.iter().filter(|c| c.target == *t) {
                let e = (
                    c.source.entity.clone(),
                    c.source.id.clone(),
                    c.field.clone(),
                );
                if c.op == "add" {
                    incoming.insert(e);
                } else {
                    incoming.remove(&e);
                }
            }
            if !incoming.is_empty() {
                let list: Vec<String> = incoming
                    .iter()
                    .map(|(e, id, f)| format!("{e}#{id}.{f}"))
                    .collect();
                return Err(StoreError::DanglingReference(format!(
                    "removing {t} leaves references to it: {}",
                    list.join(", ")
                )));
            }
        }
        for c in changes.iter().filter(|c| c.op == "add") {
            let alive = created.iter().any(|v| v.key() == c.target)
                || (!removed.contains(&c.target)
                    && exists_at(&self.backend, &c.target, parent).map_err(backend_err)?);
            if !alive {
                return Err(StoreError::DanglingReference(format!(
                    "{}.{} refers to {}, which does not exist",
                    c.source, c.field, c.target
                )));
            }
        }
        Ok(())
    }

    /// `STATE_CONFLICT` with the entities written since `parent`.
    fn conflict(&self, head: &Head, parent: &StateRef) -> StoreError {
        let mut changed = BTreeSet::new();
        for pos in (parent.position + 1)..=head.state_ref.position {
            if let Ok(Some(r)) = self.backend.record(pos) {
                if let Some(b) = &r.bundle {
                    for w in &b.write_set {
                        changed.insert(key(&w.entity, &w.id));
                    }
                    for l in &b.write_lifecycle {
                        changed.insert(key(&l.entity, &l.id));
                    }
                }
                // A migration rewrites every entity of its changed types (feature 009).
                for v in &r.new_versions {
                    changed.insert(v.key());
                }
            }
        }
        StoreError::StateConflict {
            current: head.state_ref.clone(),
            changed: changed.into_iter().collect(),
        }
    }

    /// Re-evaluates a decision record against the parent state: checks that its state section is
    /// the parent's content and that it reproduces byte for byte, and derives the read and write
    /// sets from the evaluation (FR-020).
    #[allow(clippy::type_complexity)]
    pub(crate) fn rederive(
        &self,
        module: &Module,
        at_schema: &SchemaRef,
        parent: &StateRef,
        record: &Json,
    ) -> R<(
        BTreeMap<EntityKey, EntityVersion>,
        Vec<ReadEntry>,
        Vec<WriteEntry>,
        Json,
    )> {
        self.rederive_for(module, at_schema, parent, record, DecisionPurpose::Current)
    }

    #[allow(clippy::type_complexity)]
    pub(crate) fn rederive_archived(
        &self,
        module: &Module,
        at_schema: &SchemaRef,
        parent: &StateRef,
        record: &Json,
    ) -> R<(
        BTreeMap<EntityKey, EntityVersion>,
        Vec<ReadEntry>,
        Vec<WriteEntry>,
        Json,
    )> {
        self.rederive_for(
            module,
            at_schema,
            parent,
            record,
            DecisionPurpose::Historical,
        )
    }

    #[allow(clippy::type_complexity)]
    fn rederive_for(
        &self,
        module: &Module,
        at_schema: &SchemaRef,
        parent: &StateRef,
        record: &Json,
        purpose: DecisionPurpose,
    ) -> R<(
        BTreeMap<EntityKey, EntityVersion>,
        Vec<ReadEntry>,
        Vec<WriteEntry>,
        Json,
    )> {
        if schema(module).hash != at_schema.hash {
            return Err(schema_mismatch(at_schema, &schema(module)));
        }
        if matches!(purpose, DecisionPurpose::Current)
            && (record["record_version"] != "0.8"
                || record["validation_profile"] != CURRENT_VALIDATION_PROFILE)
        {
            return Err(invalid(
                "live commit requires the current validation profile",
            ));
        }
        // Replay supplies the schema established by walking this historical prefix;
        // consulting the head here would let later corrupt migrations taint earlier events.
        // The old Store already required full parent validity. Keep that proof
        // obligation, but do not promote archived validation into current cache state.
        let snapshot = if matches!(purpose, DecisionPurpose::Historical) {
            if record["record_version"] == "0.8" {
                // Retain the exact frame check previously performed by the
                // current cache path, but do not mint a current certificate.
                self.snapshot_identity(module, parent, at_schema)?;
            }
            Arc::new(self.validate_snapshot_full(module, parent.position)?)
        } else {
            self.validate_snapshot(module, parent, at_schema)?
        };
        let declarations = &at_schema.declarations;
        let action_name = record["action"]["name"]
            .as_str()
            .ok_or_else(|| invalid("the record has no action"))?;
        let a = module
            .action(action_name)
            .ok_or_else(|| invalid(format!("unknown action `{action_name}`")))?;
        let mut parent_versions = BTreeMap::new();
        let mut loaded = BTreeMap::new();
        for p in a.params() {
            if !matches!(p.role(), ParamRole::State | ParamRole::Read) {
                continue;
            }
            let Type::Entity(entity) = p.ty() else {
                continue;
            };
            if !declarations.contains_key(entity) {
                return Err(StoreError::EntityDeclarationMismatch(format!(
                    "`{entity}` is not an entity of this store"
                )));
            }
            let value = &record["state"][p.name()];
            let key = EntityKey {
                entity: entity.clone(),
                id: id_of(value)?,
            };
            if !exists_at(&self.backend, &key, parent.position).map_err(backend_err)? {
                return Err(StoreError::EntityUniverseChanged(format!(
                    "{key} is not in the parent state"
                )));
            }
            let v = self
                .backend
                .version_at(&key, parent.position)
                .map_err(backend_err)?
                .ok_or_else(|| {
                    StoreError::EntityUniverseChanged(format!("{key} is not in the parent state"))
                })?;
            if v.value != *value {
                return Err(invalid(format!(
                    "{key}: the record's state is not the parent's"
                )));
            }
            loaded.insert(p.name().to_string(), v.clone());
            parent_versions.insert(key, v);
        }
        // Facts are re-derived at the parent: a record whose facts differ does not reproduce.
        let facts = SnapshotFacts {
            snapshot: &snapshot,
            backend: &self.backend,
            position: parent.position,
        };
        let reproduced = if matches!(purpose, DecisionPurpose::Current)
            && let Some((prepared, hint)) = self.prepared_for(&snapshot)
        {
            behavior_core::record::reproduce_prepared(
                module,
                &record.to_string(),
                &facts,
                &prepared,
                hint.as_ref(),
            )
            .map(|checked| {
                let result = checked.observed().clone();
                self.retain_checked(&snapshot, checked);
                result
            })
        } else {
            behavior_core::record::reproduce_observed_with(module, &record.to_string(), &facts)
                .map(|(_, observed)| observed)
        };
        let observed = reproduced.map_err(|e| {
            invalid(format!(
                "the record does not reproduce under its behavior version: {e}"
            ))
        })?;
        Ok((
            parent_versions,
            read_set(&observed.fields, &loaded),
            write_set(record)?,
            facts_json(&observed.facts),
        ))
    }
}

#[cfg(test)]
#[path = "store/replay_tests.rs"]
mod replay_tests;

/// The transition's semantic identity: the feature-002 transition hash of the decision record
/// (excludes commit time and evidence).
pub fn transition_hash(record: &Json) -> R<String> {
    document_hash(TAG_TRANSITION, record).map_err(|e| invalid(e.to_string()))
}

/// The observed facts as a bundle's `read_facts` (absent when empty).
fn facts_json(f: &behavior_core::Facts) -> Json {
    if f.is_empty() {
        return Json::Null;
    }
    let mut j = f.to_json();
    // Each query instance carries the hash of its members (feature 007, FR-014/FR-015).
    if let Some(Json::Array(queries)) = j.get_mut("queries") {
        for q in queries {
            let members = q["members"].clone();
            let h = document_hash(TAG_QUERY_RESULT, &members).unwrap_or_default();
            if let Json::Object(m) = q {
                m.insert("result_hash".into(), json!(h));
            }
        }
    }
    j
}

/// The domain tag of a query result hash.
pub const TAG_QUERY_RESULT: &str = behavior_verify::hashing::TAG_QUERY_RESULT;

/// Observed reads of state parameters, grouped per entity with its revision at the evaluated state.
fn read_set(
    observed: &BTreeSet<(String, String)>,
    loaded: &BTreeMap<String, EntityVersion>,
) -> Vec<ReadEntry> {
    let mut per: BTreeMap<EntityKey, (u64, BTreeSet<String>)> = BTreeMap::new();
    for (param, field) in observed {
        if let Some(v) = loaded.get(param) {
            per.entry(v.key())
                .or_insert_with(|| (v.revision, BTreeSet::new()))
                .1
                .insert(field.clone());
        }
    }
    per.into_iter()
        .map(|(k, (revision, fields))| ReadEntry {
            entity: k.entity,
            id: k.id,
            revision,
            fields: fields.into_iter().collect(),
        })
        .collect()
}

/// The written cells of a decision record's changes (parameter names dropped).
fn write_set(record: &Json) -> R<Vec<WriteEntry>> {
    let mut out = Vec::new();
    for c in record["changes"].as_array().into_iter().flatten() {
        out.push(WriteEntry {
            entity: c["entity"]
                .as_str()
                .ok_or_else(|| invalid("change without entity"))?
                .into(),
            id: c["id"]
                .as_str()
                .ok_or_else(|| invalid("change without string id"))?
                .into(),
            field: c["field"]
                .as_str()
                .ok_or_else(|| invalid("change without field"))?
                .into(),
            old: c["old"].clone(),
            new: c["new"].clone(),
        });
    }
    out.sort_by(|a, b| (&a.entity, &a.id, &a.field).cmp(&(&b.entity, &b.id, &b.field)));
    Ok(out)
}

/// Enforces the store's evidence policy and returns the bound authorization's hash (research R9).
pub(crate) fn check_evidence(genesis: &Genesis, bundle: &CommitBundle) -> R<Option<String>> {
    match (&bundle.evidence, genesis.evidence_policy.require()) {
        (None, Require::None) => Ok(None),
        (None, Require::CommitAuthorization) => Err(StoreError::EvidenceRequired(format!(
            "evidence policy {} requires a commit authorization",
            genesis.evidence_policy.hash()?
        ))),
        (Some(e), _) => crate::store::evidence::check(
            genesis,
            bundle,
            e.as_legacy().ok_or_else(|| {
                StoreError::EvidenceMismatch("v2 evidence needs the trusted checker".into())
            })?,
        )
        .map(Some),
    }
}

pub(crate) mod evidence {
    use super::*;
    use behavior_verify::governance::{decode_policy, waiver_hash};
    use behavior_verify::hashing::{TAG_AUTHORIZATION, TAG_VERIFICATION};

    fn mismatch(msg: impl Into<String>) -> StoreError {
        StoreError::EvidenceMismatch(msg.into())
    }

    fn text(v: &Json) -> R<String> {
        behavior_core::canonical::to_canonical_string(v).map_err(|e| mismatch(e.to_string()))
    }

    fn check_component(name: &str, value: &Json) -> R<()> {
        behavior_core::canonical::to_canonical_string(value)
            .map(|_| ())
            .map_err(|e| mismatch(format!("{name}: {e}")))
    }

    /// Supplied components must be canonical before hashing excludes metadata.
    fn check_components(e: &Evidence) -> R<()> {
        check_component("authorization", &e.authorization)?;
        if let Some(policy) = &e.execution_policy {
            check_component("execution_policy", policy)?;
        }
        if let Some(attestation) = &e.attestation {
            check_component("attestation", attestation)?;
        }
        for (i, waiver) in e.waivers.iter().enumerate() {
            check_component(&format!("waivers[{i}]"), waiver)?;
        }
        Ok(())
    }

    /// Checks supplied evidence against the bundle and the store's policy (research R9) and
    /// returns the authorization's hash. The authorization must be well formed and match this
    /// exact transition (which binds the store and the evaluated state through `data_version`);
    /// cited documents, when supplied, must hash to what it cites. This is a structural guarantee
    /// within the current trust boundary: who issued the authorization is not proven (FR-023).
    pub(crate) fn check(genesis: &Genesis, bundle: &CommitBundle, e: &Evidence) -> R<String> {
        check_components(e)?;
        let auth = &e.authorization;
        let actual = sealed(auth)?;
        if auth.get("kind").is_some() {
            return Err(mismatch("the authorization is not for an action"));
        }
        if auth["transition_hash"] != bundle.transition_hash.as_str() {
            return Err(mismatch("the authorization is for another transition"));
        }
        if auth["behavior_version"] != bundle.behavior_version.as_str() {
            return Err(mismatch(
                "the authorization is for another behavior version",
            ));
        }
        cited(
            genesis
                .evidence_policy
                .as_legacy()
                .ok_or_else(|| mismatch("v2 policy cannot use the structural checker"))?
                .trusted_execution_policies
                .as_ref(),
            e,
        )?;
        Ok(actual)
    }

    /// Checks migration evidence (feature 009): the authorization must be for this migration on
    /// this store state (`data_version`), from a trusted execution policy, citing the supplied
    /// documents.
    pub(crate) fn check_migration(
        data_version: &str,
        migration: &behavior_core::migration::Migration,
        trusted: Option<&Vec<String>>,
        e: &Evidence,
    ) -> R<String> {
        check_components(e)?;
        let auth = &e.authorization;
        let actual = sealed(auth)?;
        if auth["kind"] != "migration" {
            return Err(mismatch("the authorization is not for a migration"));
        }
        if auth["migration_hash"] != migration.hash().as_str() {
            return Err(mismatch("the authorization is for another migration"));
        }
        if auth["data_version"] != data_version {
            return Err(mismatch("the authorization is for another store or state"));
        }
        cited(trusted, e)?;
        Ok(actual)
    }

    /// The authorization's hash, if it matches its content and allows the commit.
    fn sealed(auth: &Json) -> R<String> {
        let claimed = auth["hash"].as_str().unwrap_or_default();
        let actual = document_hash(TAG_AUTHORIZATION, auth).map_err(|x| mismatch(x.to_string()))?;
        if claimed != actual {
            return Err(mismatch(
                "the authorization's hash does not match its content",
            ));
        }
        if auth["decision"] != "allow" {
            return Err(mismatch(format!(
                "the authorization's decision is {}",
                auth["decision"]
            )));
        }
        Ok(actual)
    }

    /// The execution policy is trusted, and every supplied document is the one cited.
    fn cited(trusted: Option<&Vec<String>>, e: &Evidence) -> R<()> {
        let auth = &e.authorization;
        let policy_hash = auth["policy_hash"].as_str().unwrap_or_default();
        if let Some(allowed) = trusted
            && !allowed.iter().any(|p| p == policy_hash)
        {
            return Err(mismatch(format!(
                "execution policy {policy_hash} is not trusted by this store"
            )));
        }
        if let Some(p) = &e.execution_policy {
            let decoded = decode_policy(&text(p)?).map_err(|x| mismatch(x.to_string()))?;
            if decoded.hash != policy_hash {
                return Err(mismatch(
                    "the supplied execution policy is not the one cited",
                ));
            }
        }
        if let Some(a) = &e.attestation {
            let mut stripped = a.clone();
            if let Some(Json::Array(checks)) = stripped.get_mut("checks") {
                for c in checks {
                    if let Json::Object(cm) = c {
                        cm.remove("cached");
                    }
                }
            }
            let h =
                document_hash(TAG_VERIFICATION, &stripped).map_err(|x| mismatch(x.to_string()))?;
            if a["hash"] != h.as_str() || auth["verification"]["attestation_hash"] != h.as_str() {
                return Err(mismatch("the supplied attestation is not the one cited"));
            }
        }
        if !e.waivers.is_empty() {
            let mut supplied = BTreeSet::new();
            for w in &e.waivers {
                supplied.insert(waiver_hash(&text(w)?).map_err(|x| mismatch(x.to_string()))?);
            }
            let cited: BTreeSet<String> = auth["waivers_used"]
                .as_array()
                .into_iter()
                .flatten()
                .filter_map(|u| u["waiver_hash"].as_str().map(str::to_string))
                .collect();
            if supplied != cited {
                return Err(mismatch("the supplied waivers are not the ones cited"));
            }
        }
        Ok(())
    }
}

fn trusted_err(e: behavior_verify::governance::trusted::TrustedError) -> StoreError {
    StoreError::Contract {
        code: if e.code == "AUTHORIZATION_REFUSED" {
            "POLICY_REFUSED"
        } else {
            e.code
        },
        message: e.message,
    }
}
pub(crate) fn check_trusted_evidence(
    subject: &behavior_verify::governance::trusted::GovernanceSubject<'_>,
    candidate: &behavior_verify::governance::trusted::GovernanceCandidate,
    genesis: &Genesis,
    evidence: Option<&crate::documents::CommitEvidence>,
    context: Option<&behavior_verify::governance::trusted::AuthorizationContextV2>,
    time: &str,
) -> R<Option<String>> {
    check_profiled_trusted_evidence(
        EvidencePurpose::Current(subject),
        candidate,
        genesis,
        evidence,
        context,
        time,
    )
}

enum EvidencePurpose<'a> {
    Current(&'a behavior_verify::governance::trusted::GovernanceSubject<'a>),
    Archived,
}

/// Called only after reproducing the exact committed decision at its historical
/// schema/position. Archived signatures authenticate the original proof, never
/// upgrade it to authority for a new current candidate.
pub(crate) fn check_reproduced_decision_evidence(
    module: &Module,
    record: &Json,
    candidate: &behavior_verify::governance::trusted::GovernanceCandidate,
    genesis: &Genesis,
    evidence: Option<&crate::documents::CommitEvidence>,
    context: Option<&behavior_verify::governance::trusted::AuthorizationContextV2>,
    time: &str,
) -> R<Option<String>> {
    let behavior = module.behavior_version();
    if record["behavior_version"] != behavior
        || candidate.subject() != json!({"behavior_hash":behavior})
    {
        return Err(invalid(
            "reproduced historical decision differs from its exact admitted subject",
        ));
    }
    match record["record_version"].as_str() {
        Some("0.4" | "0.5" | "0.6" | "0.7" | "0.8") => {
            check_archived_trusted_evidence(candidate, genesis, evidence, context, time)
        }
        _ => Err(invalid("unknown reproduced decision profile")),
    }
}

/// Only callers that already matched and reproduced exact committed history
/// may use this purpose. Actual fresh commits retain check_trusted_evidence.
pub(crate) fn check_archived_trusted_evidence(
    candidate: &behavior_verify::governance::trusted::GovernanceCandidate,
    genesis: &Genesis,
    evidence: Option<&crate::documents::CommitEvidence>,
    context: Option<&behavior_verify::governance::trusted::AuthorizationContextV2>,
    time: &str,
) -> R<Option<String>> {
    check_profiled_trusted_evidence(
        EvidencePurpose::Archived,
        candidate,
        genesis,
        evidence,
        context,
        time,
    )
}

fn check_profiled_trusted_evidence(
    purpose: EvidencePurpose<'_>,
    candidate: &behavior_verify::governance::trusted::GovernanceCandidate,
    genesis: &Genesis,
    evidence: Option<&crate::documents::CommitEvidence>,
    context: Option<&behavior_verify::governance::trusted::AuthorizationContextV2>,
    time: &str,
) -> R<Option<String>> {
    let policy = genesis
        .evidence_policy
        .as_trusted()
        .ok_or_else(|| invalid("trusted checker requires v2 evidence policy"))?;
    let required = if candidate.kind() == "migration" {
        policy.migration_requires_authorization()
    } else {
        policy.requires_authorization()
    };
    if required && context.is_none() {
        return Err(StoreError::Contract {
            code: "CONTEXT_REQUIRED",
            message: "fresh governed writes require independent full authorization context".into(),
        });
    }
    match evidence {
        None if !required => Ok(None),
        None => Err(StoreError::EvidenceRequired(
            "required trusted authorization is absent".into(),
        )),
        Some(e) => {
            let e = e.as_trusted().ok_or_else(|| {
                StoreError::EvidenceMismatch(
                    "v2 policy cannot accept unsigned structural authorization".into(),
                )
            })?;
            let q = context.ok_or_else(|| StoreError::Contract {
                code: "CONTEXT_REQUIRED",
                message: "trusted evidence requires independently supplied context".into(),
            })?;
            q.validate_commit_time(time).map_err(trusted_err)?;
            match purpose {
                EvidencePurpose::Current(subject) => {
                    behavior_verify::governance::trusted::validate_trusted_authorization(
                        subject, candidate, policy, e, q,
                    )
                }
                EvidencePurpose::Archived => {
                    behavior_verify::governance::trusted::validate_archived_authorization(
                        candidate, policy, e, q,
                    )
                }
            }
            .map_err(trusted_err)?;
            Ok(Some(e.authorization().hash().into()))
        }
    }
}

pub(crate) fn archived_context(
    evidence: Option<&crate::documents::CommitEvidence>,
    raw: Option<&Json>,
) -> R<Option<behavior_verify::governance::trusted::AuthorizationContextV2>> {
    raw.map(|q| {
        let policy = evidence
            .and_then(|e| e.as_trusted())
            .ok_or_else(|| invalid("archived context has no trusted evidence policy"))?;
        behavior_verify::governance::trusted::AuthorizationContextV2::from_json(
            &q.to_string(),
            policy.execution_policy(),
        )
        .map_err(trusted_err)
    })
    .transpose()
}
