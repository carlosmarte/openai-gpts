# Post-Meeting Frameworks Reference

## Table of Contents

1. Meeting Type Classification
2. Project Lifecycle Phase Mapping
3. Action Item Frameworks (3 W's, SMART, DRI)
4. Responsibility Frameworks (RACI)
5. Decision Frameworks (Decision Log)
6. Reflection Frameworks (Plus/Delta, Post-Mortem, Retrospective Patterns)
7. Task Prioritization
8. Facilitation Techniques
9. Framework Selection Guide

---

## 1. Meeting Type Classification

| Type | Description | Key Post-Meeting Output |
|------|-------------|------------------------|
| Status Update | Regular check-in on ongoing work progress | Action items, blocker resolution, updated timelines |
| Strategy Session | Long-form discussion on direction, priorities, or major decisions | Decision log, strategic action items, parking lot items |
| Kickoff | Launch of a new project, initiative, or sprint | RACI matrix, full action item set, follow-up schedule |
| Retrospective | Reflection on completed work or sprint | Plus/Delta, improvement action items, lessons learned |
| 1:1 | Manager-report or peer-to-peer focused discussion | Personal action items, career/development notes, feedback |
| Client/External | Meeting with external stakeholders, vendors, or customers | Decision log, follow-up cadence (Pulse or sales), commitment tracking |
| Training | Knowledge transfer, onboarding, or skill development session | Spaced repetition schedule, resource distribution, assessment follow-up |

## 2. Project Lifecycle Phase Mapping

| Phase | Meeting Focus | Expected Post-Meeting Product |
|-------|--------------|-------------------------------|
| Initiation | Feasibility, stakeholder mapping, business case | Project charter, high-level proposal, stakeholder register |
| Planning | Objectives, timelines, budgets, risks, resources | Detailed project plan, risk register, resource allocation |
| Execution | Status updates, standups, cross-functional check-ins | Action items with DRI owners, blocker escalation, progress tracking |
| Monitoring & Control | Performance tracking, risk adjustment, scope management | Updated timelines, risk mitigation actions, change requests |
| Closure | Reflection, lessons learned, handoff | Post-mortem report, decision archive, knowledge transfer docs |

## 3. Action Item Frameworks

### 3.1 The 3 W's

Every action item must answer three questions:

- **Who:** The specific, individual owner responsible for execution. Never a team or department — always a named person.
- **What:** A clear, actionable description starting with a strong action verb. Use: Create, Review, Publish, Analyze, Submit, Schedule, Prepare, Deliver, Investigate, Resolve, Draft, Finalize, Coordinate, Present, Update. Avoid passive nouns like "website updates" or "marketing review."
- **When:** A concrete deadline as an absolute date (YYYY-MM-DD). Replace all vague timelines:
  - "ASAP" → specific date based on urgency assessment
  - "Soon" → specific date within the current week
  - "Next week" → specific date (e.g., Monday of next week)
  - "End of month" → specific date (last business day)
  - "After the holidays" → first business day after the break

### 3.2 SMART Criteria

Apply to every action item for validation:

| Criterion | Definition | Validation Question | Failure Example | Fixed Example |
|-----------|------------|--------------------|-----------------|--------------------|
| Specific | Zero room for interpretation on expected outcome | Can two people independently agree on what "done" looks like? | "Improve website" | "Redesign the pricing page header to include the annual plan comparison table" |
| Measurable | Explicit metric or definitive completion state | Can you objectively verify completion? | "Write content" | "Publish 3 blog posts to the company blog" |
| Achievable | Realistic given the assignee's bandwidth, access, and resources | Does the DRI have what they need to complete this? | "Rebuild the entire backend by Friday" (2 days) | "Complete API endpoint migration for the user service by Friday" |
| Relevant | Directly supports broader project goals or organizational strategy | Would removing this item impact the project's success? | "Organize team lunch" (in a sprint planning meeting) | "Schedule sprint demo with stakeholders" |
| Time-bound | Specific, motivating deadline based on project timeline | Is the deadline a real date, not a vague reference? | "Due whenever" | "Due 2025-04-18" |

### 3.3 DRI (Directly Responsible Individual)

Core principle: When a task is assigned to a group, no single person feels the imperative to execute it (diffusion of responsibility / bystander effect).

Rules:
- Every action item has exactly one DRI — a single named individual.
- Even cross-functional tasks requiring multiple contributors have one lead coordinator.
- The DRI owns the final outcome and is accountable to leadership.
- The DRI may delegate sub-tasks but retains accountability for the overall deliverable.
- If notes say "the team will handle X," flag this as **[VAGUE — NO DRI]** and ask who specifically owns it.

## 4. Responsibility Frameworks

### RACI Matrix

Use when action items involve multiple teams, departments, or stakeholders. Map each action item to four role categories:

| Role | Definition | Rules |
|------|------------|-------|
| **Responsible (R)** | The individual(s) who do the actual work | Can be multiple people for sub-tasks |
| **Accountable (A)** | The single person who ensures completion and makes final decisions | Exactly one person per item — aligns with DRI |
| **Consulted (C)** | Subject matter experts who provide input during execution | Two-way communication — they give advice, not just receive updates |
| **Informed (I)** | Stakeholders who need progress updates but do not execute | One-way communication — they receive status, not asked for input |

RACI Rules:
- Every action item must have exactly one A (Accountable).
- A and R can be the same person for simple tasks.
- Accountability cannot be delegated to a group.
- Minimize the number of C roles to avoid decision paralysis.
- Identify I roles to prevent information gaps without overloading participants.

### When to Generate a RACI Matrix

Generate when:
- The meeting involves 3+ distinct teams or departments
- Action items have cross-functional dependencies
- The meeting is a project kickoff or strategy session
- Notes mention handoffs between groups

Skip when:
- Single-team standup or status update
- 1:1 meeting
- All action items have clear, single owners with no cross-dependencies

## 5. Decision Frameworks

### Decision Log Anatomy

Every decision extracted from meeting notes must be documented with these fields:

| Field | Description | Example |
|-------|-------------|---------|
| Decision ID | Sequential identifier: D-001, D-002, ... | D-003 |
| Decision | Clear, declarative statement of what was decided | "Adopt PostgreSQL for the analytics data store" |
| Rationale | Why this choice was made — the specific reasoning, data, or constraint that drove it | "Query benchmarks showed 3x improvement for our aggregate-heavy workload" |
| Alternatives Considered | Other options discussed and why they were rejected | "MySQL (current — too slow), DynamoDB (cost at scale), BigQuery (latency)" |
| Owner | The individual with final authority over this decision | "Marcus Webb (VP Engineering)" |
| Review Trigger | A specific condition that signals when to reassess | "Reassess at 500K daily events or Q3 architecture review" |

Decision Extraction Rules:
- Capture both explicit decisions ("We decided to...") and implicit ones ("Let's go with...", "We'll stick with...", "That makes sense, let's do it").
- When rationale is not stated in notes, mark as **[RATIONALE NOT STATED — recommend capturing in follow-up]**.
- When alternatives are not mentioned, mark as **[NO ALTERNATIVES DOCUMENTED]**.
- When no review trigger is obvious, suggest one based on the decision's nature (date-based for time-sensitive, milestone-based for project-driven, threshold-based for metric-driven).

## 6. Reflection Frameworks

### 6.1 Plus/Delta (+/Δ) Micro-Assessment

A quick end-of-meeting debrief. Apply to every processed meeting as a meta-assessment:

- **Plus (+):** What specifically produced value during the session? What worked well and should continue?
- **Delta (Δ):** What one thing could be changed to improve the next session's process, outcome, or efficiency?

Assessment Sources (derived from meeting notes):
- Agenda structure and time allocation
- Decision velocity (how quickly were decisions reached?)
- Action item clarity (were commitments specific or vague?)
- Participant engagement signals (who spoke, who was silent?)
- Presence of decision-makers (were the right people in the room?)

### 6.2 Post-Mortem Structure

For meetings classified as retrospectives or project debriefs:

Principles:
- **Blameless culture is mandatory** — focus on "why" and "how" of systemic failures, never "who"
- Frame issues as process gaps, not personal failures
- Use neutral language: "The deployment process lacked a rollback step" not "John forgot to add rollback"

Structure:
1. Timeline reconstruction — plot milestones, friction points (losses), and successes (wins)
2. What went well — concrete, replicable practices
3. What went wrong — systemic issues, process gaps, resource constraints
4. Root cause analysis — ask "why" iteratively to reach underlying causes
5. Improvement action items — specific, tracked items with DRI and deadline

### 6.3 Agile Retrospective Patterns

| Pattern | Best For | Structure |
|---------|----------|-----------|
| **Start, Stop, Continue** | Action-oriented teams resistant to emotional discussion | Start: new practices to adopt; Stop: habits to discard; Continue: what's working |
| **Mad, Sad, Glad** | Surfacing hidden emotional frictions | Mad: frustrations; Sad: disappointments; Glad: pride/joy moments |
| **4Ls** (Liked, Learned, Lacked, Longed For) | Post-learning or complex novel projects | Reflects on experience, knowledge gaps, and wishes |
| **Sailboat** | Breaking habitual thinking, creative teams | Wind (forward momentum), Anchors (holding back), Icebergs (future risks) |

## 7. Task Prioritization

### Priority Tiers

| Priority | Definition | Implication |
|----------|------------|-------------|
| **Critical** | Blocking other cross-functional work; project cannot proceed without this | Execute immediately; escalate blockers within 24 hours |
| **High** | Important and time-sensitive; significant impact if delayed | Execute within the current sprint/week |
| **Medium** | Standard priority; contributes to project goals but not blocking | Execute within the planned timeline |
| **Low** | Complete when surplus bandwidth allows; nice-to-have | Schedule for future sprint or deprioritize if overloaded |

### Priority Assignment Signals

Detect priority from notes using these context clues:
- "Urgent," "blocking," "can't proceed without" → Critical
- "Important," "need this by," "deadline," "client-facing" → High
- Standard task language without urgency markers → Medium
- "When you get a chance," "nice to have," "stretch goal," "if time allows" → Low

## 8. Facilitation Techniques

Reference these when analyzing meeting effectiveness:

| Technique | Purpose | Application |
|-----------|---------|-------------|
| **Parking Lot** | Capture off-topic but valuable ideas without derailing discussion | Create a Parking Lot section in the post-meeting doc for these items |
| **Time-Boxing** | Strict time limits for discussions; if no decision, assign an action item | Note when time-boxed items generated action items vs. decisions |
| **Impact Matrix** | Rank alternatives against project criteria | Use to validate priority assignments |
| **Nine-Block Diagram** | Compare impact vs. effort for prioritization | Reference when action items need relative ranking |
| **Nominal Group Technique** | Individual writing before sharing to equalize participation | Note if meeting appeared to have balanced participation |

## 9. Framework Selection Guide

| Meeting Type | Frameworks to Apply | RACI? | Cadence Type |
|-------------|---------------------|-------|--------------|
| Status Update | 3 W's, SMART, DRI, Priority Tiers | Only if cross-team | Internal 1-3-7 |
| Strategy Session | Full suite (3 W's, SMART, DRI, Decision Log, Priority) | Yes | Internal 1-3-7 |
| Kickoff | Full suite + RACI | Yes (always) | Internal 1-3-7 |
| Retrospective | Plus/Delta, Post-Mortem, Retrospective Patterns, DRI for improvements | Only if cross-team | Internal 1-3-7 |
| 1:1 | 3 W's, SMART, DRI | No | Internal 1-3-7 (simplified) |
| Client/External | 3 W's, SMART, DRI, Decision Log | Yes | External Pulse or Sales |
| Training | 3 W's, SMART | No | Spaced Repetition 1-3-7 |
