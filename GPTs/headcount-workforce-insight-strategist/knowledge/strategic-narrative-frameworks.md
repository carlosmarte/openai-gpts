# Strategic Narrative Frameworks

This document codifies the framing patterns that turn metrics into strategic insight. Apply these patterns aggressively — they prevent regression to descriptive output. Like the rest of the GPT, these patterns are **concept-keyed**: they reference the analytical concepts in `analytical-formulas.md` (e.g., `actual_count`, `plan_target`, `attrition_rate`, `comp_spend`, `budget`), not specific column names. The user-mapped column names appear in the rendered narrative and footnotes.

## The Core Structure: Implication → Evidence → Decision

Every finding must follow this three-part structure:

1. **Implication** (1 sentence) — what the finding means for the business.
2. **Evidence** (1-2 sentences) — the specific number or comparison that supports it, citing the analytical pattern (P1–P12).
3. **Decision** (1 sentence) — what the executive team should do.

### Example

> **Implication:** {Entity}'s combination of behind-plan attainment and elevated attrition is shrinking effective capacity just as a critical delivery ramps, putting the timeline at material risk.
> **Evidence:** P2 Plan Gap = 5 (30 actual vs 35 planned). P7 Attrition Impact ≈ 4 expected departures. P4 Net Growth ≈ 1 against a plan calling for 5.
> **Decision:** Approve a buffer above plan for {Entity} and accelerate near-term inflows from the next quarter into this one.

## Risk-Language Vocabulary

Translate raw metrics into business-impact language. Each row references a concept or analytical pattern, not a literal column name.

| Raw signal | Business-impact framing |
|---|---|
| Large negative P2 Plan Gap | "Plan slippage" / "Capacity shortfall" |
| `attrition_rate` above peers (P11) | "Retention exposure" / "Knowledge erosion" |
| Combined P2 negative + elevated `attrition_rate` | "Compounding capacity loss" |
| P8 negative pacing | "Inflow velocity drag" |
| P6 burn > 1.0 | "Budget overrun" / "Spend discipline gap" |
| P6 burn < 0.7 with no inflow | "Stalled investment" / "Budget under-utilization" |
| Spend share > count share with no role-mix justification | "Spend inefficiency" / "Cost-per-output drift" |
| Spend share < count share | "Possible under-investment in the function" |
| `timeline` end-period in the past with under-attainment | "Plan execution gap" |
| Re-baselined `plan_target` mid-year | "Plan integrity erosion" |

## Common Second-Order Patterns

These are the patterns to actively scan for — they generate the highest-impact findings.

### Pattern A — Under-attainment + High Rate (Compounding Loss)
- **Trigger:** P2 Plan Gap > 0.20 × `plan_target` AND `attrition_rate` > 0.10.
- **Strategic frame:** Net capacity is shrinking; the longer this persists, the deeper the deficit.
- **Decision lever:** Buffer above plan + retention investment in the affected entity.

### Pattern B — Pacing Slip + Late Timeline
- **Trigger:** P8 pacing_gap_pp < -0.20 AND `timeline` end-period is current or past.
- **Strategic frame:** The plan won't land — recalibrate or ramp acquisition urgently.
- **Decision lever:** Bring forward subsequent-period inflows; revisit recruiter / sourcer capacity allocation.

### Pattern C — Spend-Share Divergence
- **Trigger:** `|spend_share - count_share| > 5pp` AND `role_descriptors` (if mapped) doesn't obviously justify the divergence.
- **Strategic frame:** Either inefficient spend structure or under-funded function — diagnose before action.
- **Decision lever:** Spend benchmark review for the entity; check role-mix shifts.

### Pattern D — Budget Slack + No Inflow
- **Trigger:** P6 burn < 0.7 AND `inflow_count == 0` AND P2 Plan Gap > 0.
- **Strategic frame:** Approved capacity is sitting on the table — frozen acquisition or a sourcing capacity bottleneck.
- **Decision lever:** Investigate root cause; reallocate budget if the function genuinely doesn't need it.

### Pattern E — Plan Re-baselining Drift
- **Trigger:** Period-over-period `|Δ plan_target| > 0.10 × plan_target_prior` (P10) for several entities.
- **Strategic frame:** The plan has drifted; "plan vs actual" no longer means what it did at the start of the year.
- **Decision lever:** Lock the next plan version; document the rationale for any further changes.

### Pattern F — Concentrated Risk by Entity
- **Trigger:** A single entity with P12 `risk_score >= 3` AND (if `role_descriptors` is mapped) it's a business-critical function.
- **Strategic frame:** A single entity is carrying disproportionate execution risk for the whole company.
- **Decision lever:** Executive escalation with named owner and a 30-day plan.

## Sectional Templates for the Brief

### Executive Headline (2-3 sentences)
- Open with the most consequential finding, framed as a business outcome.
- Quantify only what's necessary to make the implication concrete.
- Avoid: "This report covers...", "We analyzed...", or any meta-framing.

### Top Risks (2-4 bullets)
- Each risk: one bold-headline noun phrase + 2-3 sentences.
- Always include: implication, one or two concrete numbers, recommended mitigation.

### Top Opportunities (1-3 bullets)
- Same structure as risks but framed as advantage to capture.
- Common patterns: budget slack to redeploy, ahead-of-pace entity to model, spend efficiency advantage to defend.

### Decisions Required (numbered list)
- Each decision: action + owner role + timeline.
- Format: "1. [Owner role] approves [action] by [timeline]."
- Decisions should map back to the risks/opportunities — no orphan recommendations.

### Confidence & Caveats
- **Strong** — multiple periods of data confirm the pattern.
- **Moderate** — single-period data, but a clear concentration.
- **Hypothesis** — pattern visible but evidence weak (e.g., very small entity, missing prior period); state what would confirm it.

## Anti-Patterns to Avoid

- **Number-as-finding.** A bare count is not a finding. The finding is what the number reveals.
- **Hedge soup.** "It might be worth considering looking at..." Decide or don't include it.
- **Generic recommendations.** "Improve retention." Specific: "Commission a 30-day {Entity} retention review reporting to the named owner."
- **Metric tour.** A walkthrough of every mapped column. Pick the 3 stories that matter most.
- **Demographic inference.** Never. (See `compliance-pii-guardrails.md`.)
- **Person-blame framing.** "{Entity} leadership is failing to hire." Replace with: "{Entity} attainment is N behind plan; the implication for delivery is..."
- **Prescriptive judgment without evidence.** "{Entity} is underperforming." Replace with: "{Entity} has Y; the implication for the business is Z."

## Calibration Examples

### Weak narrative
> "We have several entities behind plan. {Entity A} is short by some hires. {Entity B} has elevated attrition. {Entity C} is over-budget. We should look into these."

### Strong narrative
> Our most consequential exposure is the compounding capacity gap in {Entity A} and {Entity B}, both behind plan attainment while their `attrition_rate` runs at 12% and 15% respectively. With the platform rebuild starting next period, {Entity A}'s gap alone could push the timeline by a quarter; {Entity B}'s gap risks SLA degradation as volume scales. The board should approve a 5-unit buffer for {Entity A} this month and commission a {Entity B} retention review owned by the named function head.

The difference: the strong version names the risk, quantifies it in context, ties it to a specific business event, and asks for a specific decision. Note that the entity names are placeholders the GPT replaces with the actual values from the user's `entity_id` column at runtime.
