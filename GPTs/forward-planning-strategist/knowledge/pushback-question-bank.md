# Pushback Question Bank

Adapt these questions to the specific document context. Do not use them verbatim — tailor the language to reference specific items, timelines, teams, or decisions from the plan being analyzed.

---

## Assumptions

- What evidence supports the assumption that [specific assumption]?
- What happens if [assumption] turns out to be false? Is there a fallback?
- Is the team treating [assumption] as validated when it has not been tested?
- Which assumptions depend on decisions or deliverables from outside the team?
- Are we assuming ideal conditions (full staffing, no competing priorities, no scope changes)?

## Dependencies

- Which dependency is on the critical path and not yet confirmed?
- Which dependency is least controlled by the executing team?
- Does [dependency] have a committed owner, delivery date, and escalation path?
- What happens to the timeline if [external dependency] slips by two weeks?
- Are there circular dependencies that create deadlock risk?

## Constraints

- Is the current scope achievable within the stated [time/budget/staffing] constraint?
- Which constraint most threatens delivery quality if it tightens?
- Are we planning around constraints or pretending they do not exist?
- Has the team validated that [platform/tool limitation] does not block [planned capability]?
- What happens if the constraint changes mid-execution?

## Scope

- Is anything labeled "out of scope" that is actually required for the in-scope items to work?
- What is deferred to "phase 2" that is actually foundational to phase 1 success?
- Is the scope narrow enough to deliver with confidence, or is it hedged with "stretch goals"?
- Does every in-scope item have a clear definition of done?
- Are we solving one problem well or three problems poorly?

## Ownership

- Who is accountable (not just responsible or consulted) for [deliverable/decision]?
- Who owns this after launch — maintenance, support, and iteration?
- Are there shared ownership areas where no single person is accountable?
- Who owns the mitigation plan if [risk] materializes?
- Is there an escalation owner for cross-team blockers?

## Timeline and Sequencing

- What must be true before [task/phase] can start?
- Are we scheduling implementation before validating the approach?
- What evidence supports the estimate for [task/phase]?
- Are teams building on top of decisions that have not been finalized?
- What happens to downstream work if [upstream task] slips?
- Which tasks are currently on the critical path but not being treated as critical?

## Decisions

- What decision must be made now to avoid downstream rework?
- Which unresolved decision is allowing false progress?
- Are teams implementing around ambiguity instead of resolving it?
- Which decision is overdue and increasing cost of change?
- What decision, if reversed later, would invalidate completed work?

## Risk

- Which high-impact risk is being accepted without explicit acknowledgment?
- What risk category has no mitigation plan at all?
- Are we overfocused on technical risk while ignoring [operational/adoption/change management] risk?
- What is the blast radius if [component/integration] fails?
- Is the risk register reflecting real concerns or just documenting obvious low-impact items?

## Gaps and Unknowns

- What do we still not know that could change the plan significantly?
- Which unknown could invalidate the entire approach?
- Are we underestimating the effort needed for discovery and validation?
- What edge cases are not addressed?
- Where is the plan using placeholder language instead of specific commitments?

## Readiness

- What proof exists that this is production-ready (not just code-complete)?
- Are rollout, support, and training treated as core deliverables or afterthoughts?
- What readiness gate is currently unmet?
- Has [security/compliance/operational] review been scheduled and scoped?
- Is there a rollback plan if launch does not go as expected?

## Tradeoffs

- What are we sacrificing to meet the current timeline?
- Is this technical debt intentional and time-boxed, or accidental and unbounded?
- Are we choosing speed over quality in an area where quality failures are expensive?
- Is the workaround becoming the permanent solution?
- What long-term cost are we accepting for short-term delivery?

## Measurement

- How will success actually be measured — not aspirationally, but operationally?
- Do we have a baseline measurement today for each success metric?
- What leading indicator would tell us within two weeks that the plan is off track?
- Are we measuring what matters or what is easy to measure?
- What happens if we hit the metrics but users are still dissatisfied?

## Stakeholder Alignment

- Who disagrees with this plan but has not raised it formally?
- Which team absorbs the operational cost of this initiative without being represented in planning?
- Are leadership, product, engineering, and operations optimizing for the same outcome?
- Is there a stakeholder whose approval is needed but not yet secured?
- What happens if executive priorities shift mid-execution?

## Failure Modes

- How does this fail silently — where partial success masks deeper problems?
- What breaks first under real usage at target scale?
- What is the recovery plan if [critical component] fails after launch?
- Are we stress-testing the plan or just reviewing it linearly?
- What failure scenario has the team not discussed?
