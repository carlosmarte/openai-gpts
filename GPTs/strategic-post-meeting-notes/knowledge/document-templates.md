# Post-Meeting Document Templates

## Table of Contents

1. Post-Meeting Summary Template
2. Decision Log Template
3. Action Items Table Template
4. RACI Matrix Template
5. Follow-Up Schedule Template
6. Parking Lot Template
7. Plus/Delta Assessment Template
8. Progress Report Template (Follow-Up Meetings)
9. Post-Mortem Report Template
10. Flag and Warning Formats

---

## 1. Post-Meeting Summary Template

```markdown
# Post-Meeting Summary: [Meeting Name]

**Date:** [YYYY-MM-DD]
**Type:** [Status Update | Strategy Session | Kickoff | Retrospective | 1:1 | Client/External | Training]
**Phase:** [Initiation | Planning | Execution | Monitoring/Control | Closure]
**Participants:** [Name 1, Name 2, Name 3 | "Not specified in notes"]
**Duration:** [Duration if mentioned | "Not specified"]
**Facilitator:** [Name | "Not specified"]

---

## Key Topics Discussed

1. [Topic 1 — one-sentence summary]
2. [Topic 2 — one-sentence summary]
3. [Topic 3 — one-sentence summary]
```

**Guidance:**
- Meeting type determines which frameworks to apply (see Framework Selection Guide in post-meeting-frameworks.md).
- Project lifecycle phase informs the expected output depth (Initiation = high-level; Execution = granular action items).
- Always list participants if mentioned — this enables RACI assignment.

### Example Entry

```markdown
# Post-Meeting Summary: Q2 Product Roadmap Review

**Date:** 2025-04-14
**Type:** Strategy Session
**Phase:** Planning
**Participants:** Sarah Chen (VP Product), Marcus Webb (VP Engineering), Lisa Park (Design Lead), James Torres (QA Lead)
**Duration:** 90 minutes
**Facilitator:** Sarah Chen

---

## Key Topics Discussed

1. Finalized feature priorities for Q2 based on customer feedback analysis
2. Decided on PostgreSQL migration timeline for the analytics service
3. Reviewed design mockups for the new dashboard — approved with minor revisions
```

---

## 2. Decision Log Template

```markdown
## Decisions Made

| ID | Decision | Rationale | Alternatives Considered | Owner | Review Trigger |
|----|----------|-----------|------------------------|-------|----------------|
| D-001 | [Clear declarative statement] | [Why this was chosen] | [Options rejected + reason] | [Named individual] | [Date, milestone, or threshold] |
```

**Field Guidance:**
- **Decision:** Write as a complete, declarative sentence. "Adopt X for Y" not just "Use X."
- **Rationale:** Capture the specific reasoning — data, constraints, cost analysis, stakeholder preference. If not stated in notes, mark: **[RATIONALE NOT STATED]**
- **Alternatives:** List what was considered and rejected. If none mentioned: **[NO ALTERNATIVES DOCUMENTED]**
- **Owner:** The individual with final authority. If unclear: **[OWNER NOT SPECIFIED]**
- **Review Trigger:** Suggest one if not stated:
  - Time-based: "Reassess on [date]" (for time-sensitive decisions)
  - Milestone-based: "Reassess at [project milestone]" (for project-driven decisions)
  - Threshold-based: "Reassess at [metric threshold]" (for metric-driven decisions)

### Example Entry

| ID | Decision | Rationale | Alternatives Considered | Owner | Review Trigger |
|----|----------|-----------|------------------------|-------|----------------|
| D-001 | Adopt PostgreSQL for the analytics data store | Query benchmarks showed 3x improvement for aggregate-heavy workload; team has existing PostgreSQL expertise | MySQL (current — too slow at scale), DynamoDB (rejected: cost at 500K+ events/day), BigQuery (rejected: p95 latency >2s) | Marcus Webb | Reassess at 500K daily events threshold or Q3 architecture review (2025-07-15) |

---

## 3. Action Items Table Template

```markdown
## Action Items

| ID | Action | DRI | Deadline | Priority | Dependencies | SMART Status |
|----|--------|-----|----------|----------|--------------|--------------|
| AI-001 | [Action verb] + [specific deliverable] | [Named individual] | [YYYY-MM-DD] | [Critical/High/Medium/Low] | [AI-XXX or "None"] | [Complete / Incomplete — list gaps] |
```

**Field Guidance:**
- **Action:** Must start with a verb: Create, Review, Publish, Analyze, Submit, Schedule, Prepare, Deliver, Investigate, Resolve, Draft, Finalize, Coordinate, Present, Update.
- **DRI:** Single named person. If notes say "the team" → **[VAGUE — NO DRI]**
- **Deadline:** Absolute date. Convert all relative references using meeting date as anchor.
- **Priority:** Use context clues from notes (see Priority Assignment Signals in post-meeting-frameworks.md).
- **Dependencies:** Reference other action item IDs or external blockers.
- **SMART Status:** Validate against all 5 criteria. Mark "Complete" if all pass. If any fail, list which: "Incomplete — not Measurable, not Time-bound."

### SMART Validation Checklist (inline)

For each action item, verify:
- [ ] **S** — Can two people independently agree on what "done" looks like?
- [ ] **M** — Can completion be objectively verified (number, state, deliverable)?
- [ ] **A** — Does the DRI have the bandwidth and resources?
- [ ] **R** — Does this item support the project/meeting goals?
- [ ] **T** — Is there a specific date (not "ASAP" or "soon")?

### Example Entry

| ID | Action | DRI | Deadline | Priority | Dependencies | SMART Status |
|----|--------|-----|----------|----------|--------------|--------------|
| AI-001 | Review and approve the updated API documentation for the v3 endpoint migration | Sarah Chen | 2025-04-18 | High | None | Complete |
| AI-002 | Publish revised pricing page with annual plan comparison table | Lisa Park | 2025-04-21 | Medium | Depends on AI-001 | Complete |
| AI-003 | Investigate intermittent 504 errors on the /analytics endpoint and report root cause | Marcus Webb | 2025-04-16 | Critical | None | Complete |

### Flagged Item Example

| ID | Action | DRI | Deadline | Priority | Dependencies | SMART Status |
|----|--------|-----|----------|----------|--------------|--------------|
| AI-004 | **[VAGUE]** "Update the website" — **Suggested reformulation:** Update the homepage hero section to reflect the Q2 product messaging approved in D-001 | **[VAGUE — NO DRI]** Suggested: Lisa Park (Design Lead) | **[VAGUE]** "Soon" — Suggested: 2025-04-25 | Medium | Depends on D-001 | Incomplete — not Specific, no DRI, not Time-bound |

---

## 4. RACI Matrix Template

```markdown
## RACI Matrix

| Action Item | Responsible | Accountable | Consulted | Informed |
|-------------|-------------|-------------|-----------|----------|
| AI-001: [Short description] | [Name(s)] | [Single name] | [Name(s)] | [Name(s)] |
```

**Rules:**
- Exactly one Accountable (A) per row — aligns with DRI.
- Responsible (R) can be multiple people for complex items.
- Minimize Consulted (C) to avoid decision paralysis.
- Informed (I) includes stakeholders, leadership, and downstream dependencies.

### Example Entry

| Action Item | Responsible | Accountable | Consulted | Informed |
|-------------|-------------|-------------|-----------|----------|
| AI-001: Review API documentation | Sarah Chen | Sarah Chen | Marcus Webb (Engineering context) | James Torres (QA planning) |
| AI-002: Publish revised pricing page | Lisa Park, Dev Team | Lisa Park | Sarah Chen (Product messaging) | Marcus Webb, James Torres |
| AI-003: Investigate 504 errors | Marcus Webb, DevOps Team | Marcus Webb | Sarah Chen (impact assessment) | Lisa Park, James Torres |

---

## 5. Follow-Up Schedule Template

```markdown
## Follow-Up Schedule

| Day | Date | Action | Channel | Owner |
|-----|------|--------|---------|-------|
| Day 1 | [YYYY-MM-DD] | [Specific action] | [Email/Slack/Teams/Phone/Meeting] | [Name] |
```

**Guidance:**
- Calculate absolute dates from meeting date.
- Match cadence type to meeting type (see Cadence Selection Guide in follow-up-cadences.md).
- Always specify the channel and the person responsible for sending.

### Example: Internal 1-3-7 Cadence

| Day | Date | Action | Channel | Owner |
|-----|------|--------|---------|-------|
| Day 1 | 2025-04-15 | Distribute meeting summary + action items to all participants | Email + #project-roadmap Slack channel | Sarah Chen |
| Day 3 | 2025-04-17 | Async check-in: "Quick check on action items from Monday's roadmap review. Any blockers?" | #project-roadmap Slack channel | Sarah Chen |
| Day 7 | 2025-04-21 | Review open action items (5-minute kick-off at weekly sync) | Weekly team meeting | Sarah Chen (facilitator) |

### Example: External Pulse Cadence

| Day | Date | Action | Channel | Owner |
|-----|------|--------|---------|-------|
| Day 1 | 2025-04-15 | Share meeting recording + key resource (no ask) | Email (automated) | Marketing ops |
| Day 2 | 2025-04-16 | Send feedback survey with stated purpose | Email (automated) | Marketing ops |
| Day 5 | 2025-04-19 | Personalized outreach to top-engaged contacts | Personal email or phone | Sales rep (assigned) |
| Day 12 | 2025-04-26 | Community content: related article or announcement | Email (automated) | Marketing ops |

---

## 6. Parking Lot Template

```markdown
## Parking Lot

| ID | Item | Suggested Owner | Suggested Timeframe | Origin |
|----|------|-----------------|---------------------|--------|
| PL-001 | [Off-topic but valuable idea] | [Name] | [Date or sprint] | [Who raised it] |
```

**Guidance:**
- Capture ideas that were mentioned but deferred during the meeting.
- Assign a suggested owner (the person most likely to champion or investigate).
- Set a timeframe so items don't languish indefinitely.
- Track who raised it so they can be looped in when it's addressed.

### Example Entry

| ID | Item | Suggested Owner | Suggested Timeframe | Origin |
|----|------|-----------------|---------------------|--------|
| PL-001 | Explore integration with Salesforce for automated lead scoring | James Torres | Q3 planning (July 2025) | Marcus Webb raised during API discussion |
| PL-002 | Consider a customer advisory board for feature prioritization feedback | Sarah Chen | Next product offsite (May 2025) | Lisa Park suggested during roadmap review |

---

## 7. Plus/Delta Assessment Template

```markdown
## Meeting Effectiveness (Plus/Delta)

**Plus (+):** What worked well
- [Observation about meeting process, decisions reached, participation quality]
- [Observation about preparation, agenda structure, time management]

**Delta (Δ):** What to improve next time
- [Specific, actionable suggestion for process improvement]
- [Specific, actionable suggestion for participation or structure]
```

**Assessment Dimensions:**
- Agenda clarity and adherence
- Decision velocity (were decisions made or deferred?)
- Action item specificity (SMART or vague?)
- Participant engagement (balanced or dominated by few voices?)
- Time management (on time, over, wasted segments?)
- Decision-maker presence (were the right people in the room?)

### Example Entry

**Plus (+):**
- Clear agenda with time allocations kept discussion focused — all 3 topics covered within 90 minutes
- Decision on PostgreSQL migration was backed by concrete benchmark data, making the choice defensible

**Delta (Δ):**
- Action items were assigned verbally but not confirmed in writing during the meeting — recommend a 5-minute wrap-up to read back all commitments
- QA Lead (James Torres) had limited speaking time — consider a structured round-robin for input on cross-cutting topics

---

## 8. Progress Report Template (Follow-Up Meetings)

Use when processing notes from a follow-up meeting that references previous action items.

```markdown
# Progress Report: [Meeting Name] — Follow-Up

**Original Meeting Date:** [YYYY-MM-DD]
**Follow-Up Date:** [YYYY-MM-DD]

## Action Item Status

| ID | Action | DRI | Original Deadline | Status | Notes |
|----|--------|-----|-------------------|--------|-------|
| AI-001 | [Description] | [Name] | [YYYY-MM-DD] | [Completed / On Track / Blocked / Overdue] | [Update details] |

## Summary

- **Completed:** [X] of [Y] items
- **On Track:** [X] items
- **Blocked:** [X] items — [brief description of blockers]
- **Overdue:** [X] items — [escalation plan]

## New Action Items

[Use standard Action Items Table template for items generated in this follow-up]
```

---

## 9. Post-Mortem Report Template

```markdown
# Post-Mortem Report: [Project/Incident Name]

**Date:** [YYYY-MM-DD]
**Facilitator:** [Name]
**Participants:** [Names]

> This is a blameless review. Focus on systems and processes, not individuals.

## Timeline

| Date/Time | Event | Category |
|-----------|-------|----------|
| [Date] | [What happened] | [Milestone / Win / Friction Point] |

## What Went Well

1. [Replicable practice or success — be specific]
2. [Replicable practice or success — be specific]

## What Went Wrong

1. [Systemic issue — describe the process gap, not the person]
2. [Systemic issue — describe the process gap, not the person]

## Root Cause Analysis

| Issue | Why? (Layer 1) | Why? (Layer 2) | Why? (Layer 3) | Root Cause |
|-------|----------------|-----------------|-----------------|------------|
| [Issue] | [First why] | [Deeper why] | [Deepest why] | [Underlying cause] |

## Improvement Action Items

| ID | Action | DRI | Deadline | Priority |
|----|--------|-----|----------|----------|
| IMP-001 | [Specific improvement action] | [Named individual] | [YYYY-MM-DD] | [Critical/High/Medium/Low] |

## Lessons Learned

1. [Key takeaway that applies beyond this specific project]
2. [Key takeaway that applies beyond this specific project]
```

---

## 10. Flag and Warning Formats

Use these standardized flags when items need attention:

| Flag | When to Use | Example |
|------|-------------|---------|
| **[VAGUE]** | Action item lacks specificity — include suggested reformulation | **[VAGUE]** "Update docs" → Suggested: "Publish updated API v3 documentation to developer portal" |
| **[VAGUE — NO DRI]** | Task assigned to a group instead of an individual | **[VAGUE — NO DRI]** "Engineering team" → Suggested: Marcus Webb |
| **[NEEDS CONFIRMATION]** | Unclear if statement is a firm commitment or tentative suggestion | **[NEEDS CONFIRMATION]** "We might want to look into caching" |
| **[RATIONALE NOT STATED]** | Decision was made but reasoning not captured in notes | D-002 rationale: **[RATIONALE NOT STATED — recommend capturing in follow-up]** |
| **[NO ALTERNATIVES DOCUMENTED]** | Decision log lacks alternatives considered | D-002 alternatives: **[NO ALTERNATIVES DOCUMENTED]** |
| **[OWNER NOT SPECIFIED]** | Decision has no clear authority identified | D-002 owner: **[OWNER NOT SPECIFIED]** |
| **[OVERDUE]** | Action item past its deadline | AI-003: **[OVERDUE]** — was due 2025-04-16 |
| **[BLOCKED]** | Action item cannot proceed due to dependency | AI-002: **[BLOCKED]** — waiting on AI-001 completion |
| **[FLAG]** | General attention needed — DRI overloaded, conflicting deadlines, etc. | **[FLAG]** Marcus Webb has 4 Critical items due this week — review capacity |
