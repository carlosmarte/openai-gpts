# Strategic Narrative Frameworks — Department-Level Headcount

This document codifies the framing patterns that turn metrics into strategic insight. Apply these patterns aggressively — they prevent regression to descriptive output.

## The Core Structure: Implication → Evidence → Decision

Every finding must follow this three-part structure:

1. **Implication** (1 sentence) — what the finding means for the business.
2. **Evidence** (1-2 sentences) — the specific number or comparison that supports it.
3. **Decision** (1 sentence) — what the executive team should do.

### Example

> **Implication:** Engineering's combination of behind-plan hiring and 12% attrition is shrinking effective capacity just as the platform rebuild ramps, putting Q3 delivery at material risk.
> **Evidence:** Hiring gap = 5 (30 current vs 35 planned). Expected departures = 30 × 12% ≈ 4. New hires this period = 5. Net capacity addition: ~1 person against a plan calling for 5.
> **Decision:** Approve a 5-role buffer above the engineering plan and accelerate Q3 hires into Q2.

## Risk-Language Vocabulary

Translate raw metrics into business-impact language:

| Raw metric | Business-impact framing |
|---|---|
| Large `hiring_gap_dept` | "Plan slippage" / "Capacity shortfall" |
| `Attrition Rate` above peer departments | "Retention exposure" / "Knowledge erosion" |
| Combined under-hire + high attrition | "Compounding capacity loss" |
| Pacing gap negative | "Hiring velocity drag" |
| `budget_burn > 1.0` | "Budget overrun" / "Spend discipline gap" |
| `budget_burn < 0.7` with no hiring | "Stalled investment" / "Budget under-utilization" |
| Comp share > headcount share with no role-mix justification | "Comp inefficiency" / "Cost-per-output drift" |
| Comp share < headcount share | "Possible under-investment in the function" |
| `Hiring Timeline` slipped past current period | "Plan execution gap" |
| Re-baselined `Planned Headcount` mid-year | "Plan integrity erosion" |

## Common Second-Order Patterns

These are the patterns to actively scan for — they generate the highest-impact findings.

### Pattern A — Under-Hire + High Attrition (Compounding Loss)
- **Trigger:** `hiring_gap_dept > 0.20 × Planned` AND `Attrition Rate > 0.10`.
- **Strategic frame:** Net capacity is shrinking; the longer this persists, the deeper the deficit.
- **Decision lever:** Buffer above plan + retention investment in the affected department.

### Pattern B — Pacing Slip + Late Timeline
- **Trigger:** `pacing_gap < -0.20` AND `Hiring Timeline` end-quarter is in the current or past period.
- **Strategic frame:** The plan won't land — recalibrate or ramp recruitment urgently.
- **Decision lever:** Bring forward subsequent-quarter hires; revisit recruiter capacity allocation.

### Pattern C — Comp Share Divergence
- **Trigger:** `|comp_share_dept - headcount_share_dept| > 5 pp` AND department mix doesn't obviously justify (e.g., it's not legal/finance/engineering).
- **Strategic frame:** Either inefficient comp structure or under-funded function — diagnose before action.
- **Decision lever:** Comp benchmark review for the department; check role-mix shifts.

### Pattern D — Budget Slack + No Hiring
- **Trigger:** `budget_burn < 0.7` AND `New Hires == 0` AND `hiring_gap_dept > 0`.
- **Strategic frame:** Approved capacity is sitting on the table — frozen hiring or a recruiter capacity bottleneck.
- **Decision lever:** Investigate root cause; reallocate budget if the function genuinely doesn't need it.

### Pattern E — Plan Re-baselining Drift
- **Trigger:** Period-over-period `|delta_planned_dept| > 0.10 × Planned_prior` for several departments.
- **Strategic frame:** The plan has drifted; "plan vs actual" no longer means what it did at the start of the year.
- **Decision lever:** Lock the next plan version; document the rationale for any further changes.

### Pattern F — Concentrated Risk by Function
- **Trigger:** A single department with `risk_score >= 3` (composite) AND it's revenue-critical (Sales) or platform-critical (Engineering, Operations).
- **Strategic frame:** A single department is carrying disproportionate execution risk for the whole company.
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
- Common patterns: budget slack to redeploy, ahead-of-pace department to model, comp efficiency advantage to defend.

### Decisions Required (numbered list)
- Each decision: action + owner role + timeline.
- Format: "1. [Owner role] approves [action] by [timeline]."
- Decisions should map back to the risks/opportunities — no orphan recommendations.

### Confidence & Caveats
- **Strong** — multiple periods of data confirm the pattern; governance header signed off.
- **Moderate** — single-period data, but a clear concentration.
- **Hypothesis** — pattern visible but evidence weak (e.g., very small department, missing prior period); state what would confirm it.

## Anti-Patterns to Avoid

- **Number-as-finding.** "Engineering has 30 people" is not a finding. The finding is what the number reveals.
- **Hedge soup.** "It might be worth considering looking at..." Decide or don't include it.
- **Generic recommendations.** "Improve retention." Specific: "Commission a 30-day Customer Service retention review reporting to the CHRO."
- **Metric tour.** A walkthrough of every column. Pick the 3 stories that matter most.
- **Demographic inference.** Never. (See `compliance-pii-guardrails.md`.)
- **Person-blame framing.** "Engineering leadership is failing to hire." Replace with: "Engineering hiring is 5 behind plan; the implication for Q3 platform delivery is..."
- **Prescriptive judgment without evidence.** "Sales is underperforming." Replace with: "Sales has Y; the implication for the business is Z."

## Calibration Examples

### Weak narrative
> "We have several departments behind plan. Engineering is 5 short. Customer Service has 15% attrition. Marketing is over-budget. We should look into these."

### Strong narrative
> Our most consequential exposure is the compounding capacity gap in Engineering and Customer Service, both behind hiring plan while attrition runs at 12% and 15% respectively. With the platform rebuild starting in Q3, the engineering gap alone could push the timeline by a quarter; Customer Service's gap risks SLA degradation as ticket volume scales. The board should approve a 5-role engineering buffer this month and commission a Customer Service retention review owned by the CHRO.

The difference: the strong version names the risk, quantifies it in context, ties it to a specific business event, and asks for a specific decision.
