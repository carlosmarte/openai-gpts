# Extraction Framework — Forward Planning Strategist

Use this framework to systematically analyze any planning document. Extract findings across all applicable categories, prioritized by impact on execution.

---

## Group 1: Core Planning Extraction

### 1. Problem

Extract the stated pain point, who experiences it, what is not working, and the impact of leaving it unsolved.

**Look for:** Workflow gaps, inconsistencies, inefficiencies, user complaints, business impact statements.

**Pushback:**
- Is the problem statement specific enough to drive a focused solution?
- Is the impact quantified or just asserted?
- Are we solving the root cause or a symptom?

### 2. Objective

Extract the desired outcome, what should improve, and what success enables.

**Look for:** Target improvements, user or business outcomes, speed/quality/safety/scale goals.

**Pushback:**
- Is the objective measurable?
- Does the objective align with the stated problem?
- Are we optimizing for the right outcome?

### 3. Scope

Extract what is in scope and out of scope for the current version.

**Look for:** Defined user groups, workflows, knowledge sources, output types, actions, evaluation loops. Also look for exclusions and deferrals.

**Pushback:**
- Is the scope realistic under current constraints?
- Is anything labeled "out of scope" that is actually foundational?
- Are we deferring core requirements by calling them "phase 2"?

### 4. Success Criteria

Extract how success will be measured.

**Look for:** Adoption metrics, quality metrics, efficiency metrics, consistency metrics, trust metrics, safety metrics. Look for baselines and targets.

**Pushback:**
- Do we have baseline measurements today?
- Are success criteria specific enough to be falsifiable?
- What metric would tell us early that the plan is failing?

### 5. Deliverables

Extract what the project must produce.

**Look for:** Documents, designs, instruction sets, knowledge strategies, guardrails, templates, test cases, rollout plans, feedback processes, ownership models.

**Pushback:**
- Is there a deliverable for every key decision area?
- Who owns each deliverable?
- Are operational deliverables (support, training, maintenance) included or missing?

### 6. Effort Summary

Extract effort estimates by workstream.

**Look for:** Discovery, design, knowledge setup, validation, rollout, maintenance effort levels. Look for sizing (small/medium/large) or time estimates.

**Pushback:**
- What evidence supports these estimates?
- Is discovery effort underestimated?
- Does the effort model account for iteration and rework?

---

## Group 2: Risk and Challenge Extraction

### 7. Assumptions

Extract stated assumptions, unstated assumptions, and fragile assumptions.

**Look for:** Dependencies on timing, outside teams, vendors, budget, technical feasibility, user behavior, or organizational readiness that are treated as facts without evidence.

**Pushback:**
- What evidence supports this assumption?
- What happens if this assumption fails?
- Is there a fallback path?

### 8. Dependencies

Extract all dependency types: upstream, downstream, cross-team, approval, infrastructure, vendor, data, policy/compliance.

**Look for:** External teams, APIs, services, approvals, data sources, infrastructure, vendor deliverables, policy decisions that must be resolved before work can proceed.

**Pushback:**
- Which dependency is on the critical path?
- Which dependency is least controlled by the team?
- Which dependency has no committed owner or date?

### 9. Constraints

Extract time, budget, staffing, platform, legal/security/compliance, tooling, organizational, and operational support constraints.

**Look for:** Hard deadlines, budget caps, team size limitations, platform restrictions, regulatory requirements, tool limitations.

**Pushback:**
- Is the scope realistic under current constraints?
- Which constraint most threatens delivery quality?
- Are we planning as if ideal conditions exist?

### 10. Gaps and Unknowns

Extract missing requirements, undefined workflows, unclear user journeys, unknown technical feasibility, missing metrics, incomplete resourcing, unsupported edge cases, undocumented business rules.

**Look for:** Sections that are vague, placeholder language, "TBD" items, areas where the plan assumes knowledge that has not been validated.

**Pushback:**
- What do we still not know?
- Which unknown could invalidate the plan?
- Are we underestimating discovery effort?

### 11. Risk Register

Extract and classify risks by type: delivery, technical, operational, adoption, security, compliance, data quality, vendor, change management, stakeholder alignment.

**Look for:** Stated risks, unstated risks, risks with mitigations, risks without mitigations, risks accepted silently.

**Pushback:**
- Which risk category has no mitigation plan?
- Are we overfocused on technical risk while ignoring operational risk?
- Which high-impact risk is being accepted silently?

### 12. Failure Modes

Extract likely failure scenarios, silent failure scenarios, scale failure points, user trust failure points, operational overload scenarios, integration breakdown scenarios.

**Look for:** Single points of failure, scenarios where partial success masks deeper problems, cases where the plan works at small scale but breaks at target scale.

**Pushback:**
- How does this fail in production?
- What breaks first under real usage?
- What is the blast radius if this component is wrong?

### 13. Tradeoffs

Extract speed vs quality, automation vs manual, flexibility vs standardization, short-term vs long-term, user value vs internal efficiency, customization vs maintainability tradeoffs.

**Look for:** Decisions where one value was chosen over another, especially when the tradeoff is not explicitly acknowledged.

**Pushback:**
- What are we sacrificing to move faster?
- Is this technical debt intentional or accidental?
- Is the workaround becoming the product?

---

## Group 3: Execution Readiness Extraction

### 14. Critical Path and Sequence Logic

Extract critical path items, prerequisite tasks, sequencing errors, tasks started too early, parallelizable tasks, tasks blocked by unresolved questions.

**Look for:** Work that is listed but not sequenced realistically. Implementation scheduled before validation. Building around unresolved foundations.

**Pushback:**
- What must be true before this starts?
- Are we scheduling implementation ahead of validation?
- Are teams building around unresolved foundations?

### 15. Ownership

Extract named owners, missing owners, shared ownership areas, approval owners, maintenance owners, escalation owners.

**Look for:** Vague ownership ("the team will handle"), shared ownership without a single accountable person, missing post-launch ownership.

**Pushback:**
- Who is accountable, not just involved?
- Who owns mitigation if this fails?
- Who maintains this after launch?

### 16. Decisions Required

Extract irreversible decisions, reversible decisions, blocked decisions, decisions with no owner, decisions deferred too long, decisions that unlock multiple downstream tasks.

**Look for:** Decisions already made, pending decisions, and avoided decisions. Look for decisions that are creating false progress by being deferred.

**Pushback:**
- What decision must be made now to avoid downstream churn?
- Which unresolved decision is creating false progress?
- Are teams implementing around ambiguity instead of resolving it?

### 17. Readiness Gates

Extract design readiness, architecture readiness, data readiness, security readiness, operational readiness, support readiness, rollout readiness, measurement readiness.

**Look for:** Evidence of readiness versus planned readiness. A project can be "built" and still not be launch-ready.

**Pushback:**
- What proof exists that this is production-ready?
- Are rollout and support treated as core work or afterthoughts?
- What readiness gate is currently unmet?

---

## Additional Extraction Targets

### Stakeholder Alignment

Extract stakeholder goals, conflicting incentives, alignment gaps, approval sensitivity, likely resistance, affected-but-unrepresented groups.

### Measurement and Evidence

Extract baseline metrics, target metrics, leading indicators, lagging indicators, missing instrumentation, qualitative vs quantitative measures.

### Change Impact

Extract downstream process changes, support burden changes, training implications, governance changes, maintenance overhead, monitoring needs, documentation burden, effects on adjacent teams.

### Scenario Analysis

Extract or construct best-case, expected, downside, failure, and recovery scenarios for the plan.
