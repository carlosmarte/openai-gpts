# RACI Matrix Inference Guide

## Role Definitions

### Responsible (R)
The individual(s) who perform the actual work to complete the task. They execute the deliverable and are directly accountable for the output quality.

### Accountable (A)
The single individual who has final sign-off authority and ultimate ownership of the task's completion. There must be exactly one Accountable person per task — this constraint prevents diffusion of responsibility.

### Consulted (C)
Subject matter experts whose input is actively sought before or during task execution. Communication is two-way: they provide expertise, review drafts, or validate approaches.

### Informed (I)
Stakeholders who receive updates on progress or outcomes. Communication is one-way: they are kept in the loop but do not contribute to execution or decisions.

## Linguistic Indicators by Role

### Responsible Indicators

| Pattern | Example | Confidence |
|---------|---------|------------|
| First-person commitment verbs | "I will handle the vendor outreach" | High |
| Direct assignment by authority | "Can you take the lead on this?" | High |
| Self-volunteering | "I can draft that by Friday" | High |
| Active task ownership | "I'm working on the budget revision" | High |
| Delegation acceptance | "Sure, I'll take care of it" | High |

### Accountable Indicators

| Pattern | Example | Confidence |
|---------|---------|------------|
| Final approval language | "Send it to me for final review" | High |
| Budget/resource authority | "I've approved the additional spend" | High |
| Delegation initiation | "I need someone to own the rollout" | High |
| Sign-off statements | "Approved — proceed as planned" | High |
| Escalation target | "Loop me in if there are blockers" | Medium |
| Thread initiator + senior role | Original sender who delegates tasks | Medium |

### Consulted Indicators

| Pattern | Example | Confidence |
|---------|---------|------------|
| Explicit input requests | "What are your thoughts on this approach?" | High |
| Review requests | "Can you review Section 3 before we finalize?" | High |
| Expert tagging | "Adding Sarah from Legal for her perspective" | High |
| Opinion solicitation | "Do you see any issues with this timeline?" | Medium |
| Two-way exchange | Back-and-forth discussion on a technical point | Medium |

### Informed Indicators

| Pattern | Example | Confidence |
|---------|---------|------------|
| CC/BCC placement | Participant appears only in CC line | High |
| FYI language | "FYI — here's where we landed" | High |
| Passive update phrases | "Just keeping you in the loop" | High |
| Distribution list recipients | Sent to a team alias without direct address | Medium |
| No active participation | Participant never replies in the thread | Medium |

## Deduction Rules

### Rule 1: Single Accountable Constraint
Every task must have exactly one Accountable owner. If multiple people appear to share accountability, identify the most senior or the one with explicit sign-off authority. Flag the ambiguity with [Ambiguous] if truly unresolvable.

### Rule 2: Responsible ≠ Accountable (by default)
The person doing the work and the person with sign-off authority are typically different. Only assign R and A to the same person when the thread clearly shows one individual both executing and approving.

### Rule 3: Delegation Chain Resolution
When Person A delegates to Person B who sub-delegates to Person C:
- Person C = Responsible (executes the work)
- Person B = Accountable (delegated authority, owns the outcome)
- Person A = Informed or Accountable at a higher level (depending on sign-off requirements)

### Rule 4: CC-Line Default
Participants who appear only in CC lines and never contribute actively default to Informed unless the thread explicitly requests their input.

### Rule 5: Facilitator Role
The thread facilitator (person driving the agenda, summarizing, or managing flow) is typically Accountable for meeting outcomes but may not be Responsible for specific tasks.

## Worked Examples

### Example 1: Clear Assignment

> **From: Maria (Director)**
> "David, can you finalize the Q3 budget proposal and send it to me for sign-off by March 15? CC: Finance team"

| Task | R | A | C | I |
|------|---|---|---|---|
| Finalize Q3 budget proposal | David | Maria | — | Finance team |

**Reasoning:** David is directly assigned the work (R). Maria requests final sign-off (A). Finance team is CC'd without active role (I).

### Example 2: Ambiguous Ownership

> **From: Alex:** "Someone needs to update the client deck before Thursday."
> **From: Jordan:** "I can help with the data slides."
> **From: Alex:** "Great. Let's also get input from the design team."

| Task | R | A | C | I |
|------|---|---|---|---|
| Update client deck | Jordan [Partial] | Alex [Inferred] | Design team | — |

**Reasoning:** Jordan volunteers for part of the work (R, partial). Alex initiated the request and implicitly owns the outcome (A, inferred). Design team is consulted. The incomplete ownership is flagged.

### Example 3: Multi-Stakeholder Thread

> **From: VP Sales (To: Product Lead, CC: Engineering, Marketing)**
> "We need to align on the feature launch date. Product — what's your timeline? Engineering — any blockers?"
> **From: Product Lead:** "We're targeting April 1. Need eng confirmation."
> **From: Eng Manager:** "We can hit April 1 if we freeze scope by March 10."

| Task | R | A | C | I |
|------|---|---|---|---|
| Finalize feature launch date | Product Lead | VP Sales | Eng Manager | Marketing |

**Reasoning:** Product Lead proposes and drives the timeline (R). VP Sales initiated alignment and holds authority (A). Eng Manager provides conditional input (C). Marketing is CC'd only (I).
