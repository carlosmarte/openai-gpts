# Artifact Extraction Schemas

This document defines the canonical field structure, data types, and validation rules for each artifact type produced by the email thread extraction GPT.

## 1. Executive Summary

### Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| subject | string | Yes | Thread subject line or inferred topic |
| purpose | string | Yes | 1-2 sentence description of the thread's purpose |
| participants | array[Participant] | Yes | All identified individuals |
| facilitator | string | No | Canonical name of the thread facilitator, if identifiable |
| key_topics | array[string] | Yes | Bulleted list of primary topics discussed |
| thread_length | integer | No | Number of distinct messages in the thread |

### Participant Object

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| canonical_name | string | Yes | Resolved full name |
| aliases | array[string] | No | Other names/references used in the thread |
| role | string | No | Identified role: "facilitator", "decision-maker", "contributor", "observer" |
| email | string | No | Email address if available from headers |

## 2. Decisions Log

### Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | integer | Yes | Sequential identifier |
| decision | string | Yes | Clear statement of the final decision |
| made_by | string | Yes | Canonical name of the decision authority |
| date | string (YYYY-MM-DD) | Yes | Date the decision was confirmed |
| rationale | string | Yes | Contextual reasoning from the thread |
| dissenters | array[string] | No | Participants who expressed disagreement |
| supersedes | integer | No | ID of a prior decision this one replaces |

### Validation Rules
- `date` must be an absolute date in YYYY-MM-DD format
- `decision` must be a definitive statement, not a proposal or suggestion
- Only include items where consensus or authority-based finality is evident

## 3. Action Items & Follow-Ups

### Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | integer | Yes | Sequential identifier |
| description | string | Yes | Specific, actionable task description |
| owner | string | Yes | Canonical name of the assigned individual |
| deadline | string (YYYY-MM-DD) | Yes | Absolute deadline date |
| status | enum | Yes | One of: "Open", "Pending", "Blocked", "Complete" |
| dependencies | string | No | Blockers or prerequisites |
| source_message | integer | No | Message number where the action was assigned |
| follow_up_date | string (YYYY-MM-DD) | No | Date for proactive follow-up if applicable |

### Status Enum Values
- **Open** — Task assigned, no blockers identified
- **Pending** — Awaiting external input or prerequisite completion
- **Blocked** — Explicit blocker identified in the thread
- **Complete** — Thread indicates task was finished

### Validation Rules
- `deadline` must be absolute (convert relative dates using message timestamp as anchor)
- `owner` must match a participant from the Executive Summary
- `description` must be specific enough to be independently actionable
- Do not extract action items from hypothetical statements or rhetorical questions

## 4. RACI Matrix

### Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| task | string | Yes | Task or deliverable name |
| responsible | string | Yes | Person executing the work |
| accountable | string | Yes | Single person with sign-off authority |
| consulted | array[string] | No | SMEs providing input |
| informed | array[string] | No | Passive update recipients |

### Validation Rules
- Exactly one `accountable` per task (never multiple)
- `responsible` and `accountable` must match participants from Executive Summary
- Append "[Inferred]" to any role assignment not explicitly stated in the thread
- Append "[Ambiguous]" when ownership cannot be confidently determined
- See `raci-matrix-guide.md` for inference logic and linguistic indicators

## 5. Chronological Timeline

### Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| date | string (YYYY-MM-DD) | Yes | Absolute date of the event |
| event | string | Yes | Description of the milestone, action, or occurrence |
| source_participant | string | No | Who mentioned or owns this event |
| message_ref | integer | No | Message number where the event is referenced |
| event_type | enum | No | One of: "past", "present", "future", "deadline" |

### Validation Rules
- All dates must be absolute YYYY-MM-DD format
- Events must be ordered chronologically regardless of thread mention order
- Relative date references must be anchored to the message's timestamp
- Include both past events (context) and future events (planned milestones)

## 6. Risk Flags

### Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | integer | Yes | Sequential identifier |
| risk | string | Yes | Clear description of the risk |
| severity | enum | Yes | One of: "High", "Medium", "Low" |
| category | enum | Yes | One of: "schedule_slippage", "undefined_ownership", "requirement_ambiguity", "resource_constraint", "tone_degradation", "compliance_concern" |
| indicator | string | Yes | Specific thread evidence supporting the flag |
| mitigation | string | Yes | Recommended action to address the risk |

### Severity Criteria
- **High** — Immediate threat to project delivery, timeline, or compliance
- **Medium** — Potential issue that could escalate without attention
- **Low** — Minor concern worth noting for awareness

### Validation Rules
- `indicator` must reference specific content from the thread (not generic risk descriptions)
- `mitigation` must be actionable and specific

## 7. Plus/Delta Retrospective

### Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| plus_items | array[PlusItem] | Yes | Elements that worked well |
| delta_items | array[DeltaItem] | Yes | Elements needing improvement |

### PlusItem Object

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| observation | string | Yes | What worked well |
| evidence | string | No | Supporting quote or reference from thread |
| attributed_to | string | No | Participant who raised or demonstrated this |

### DeltaItem Object

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| observation | string | Yes | Constructive improvement suggestion (reframed positively) |
| original_sentiment | string | No | The original complaint or concern from the thread |
| attributed_to | string | No | Participant who raised this |
| suggested_action | string | No | Specific process change recommendation |

### Validation Rules
- Delta items must be reframed as constructive suggestions, not recorded as complaints
- Only extract from explicit feedback, not inferred sentiment

## 8. Parking Lot

### Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | integer | Yes | Sequential identifier |
| item | string | Yes | Description of the deferred topic or question |
| raised_by | string | Yes | Canonical name of the person who raised it |
| context | string | Yes | Why it was deferred or taken offline |
| suggested_revisit | string | No | Recommended timeframe or trigger for revisiting |

### Validation Rules
- Only include items explicitly deferred, tabled, or marked for future discussion
- `context` should explain why the item was parked (out of scope, needs more data, wrong audience, etc.)
