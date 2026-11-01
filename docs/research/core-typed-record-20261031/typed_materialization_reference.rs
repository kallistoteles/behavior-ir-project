fn reference_validate_record08(raw: &Json) -> Result<crate::commands::CommandIntentBag, RecordError> {
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
    let bag = reference_validate_record07(&common)?;
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

fn reference_validate_record07(raw: &Json) -> Result<crate::commands::CommandIntentBag, RecordError> {
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
