# Anomaly Detection Rules — Department-Level Headcount

Apply every rule in this document during the anomaly detection pass. Each rule has a severity tag: `[CRITICAL]`, `[WARN]`, or `[INFO]`. The schema is row-per-department, so individual-employee anomalies (ghost employees, contractor compliance) do not apply at this aggregation — those require the underlying employee file.

## Category 1 — Governance Anomalies

### Rule 1.1 — Unsigned-off file `[CRITICAL]`
- Detect: `Date Approved` is missing OR `Date Approved < Date Prepared`.
- Action: halt; refuse to publish executive output until approval is recorded.

### Rule 1.2 — Stale file `[WARN]`
- Detect: `Date Approved` is more than 35 days before today.
- Action: flag and ask the user whether a fresher file is available before proceeding.

## Category 2 — Plan-vs-Actual Anomalies

### Rule 2.1 — Material under-hiring `[WARN]`
- Detect: `hiring_gap_dept > 0.25 × Planned Headcount` AND `Hiring Timeline` end-quarter has passed.
- Action: flag department; report gap as both absolute and percentage of plan.

### Rule 2.2 — Over-hiring beyond plan `[WARN]`
- Detect: `Current Headcount > Planned Headcount × 1.10`.
- Action: flag for plan revision or cost review; cross-check `Budget Allocation`.

### Rule 2.3 — Plan re-baselining `[INFO]`
- Detect (period-over-period): `|Planned_now - Planned_prior| > 0.10 × Planned_prior` for any department.
- Action: flag as plan revision; note absolute and percentage change.

### Rule 2.4 — Hiring pacing slip `[WARN]`
- Detect: `pacing_gap < -0.20` (behind schedule by more than 20 percentage points).
- Action: flag; report which quarters of the timeline have elapsed and how much hiring has occurred.

## Category 3 — Compensation & Budget Anomalies

### Rule 3.1 — Budget overrun `[CRITICAL]`
- Detect: `budget_burn_dept > 1.05` (department is more than 5% over budget).
- Action: flag for finance review; cite absolute overrun in dollars.

### Rule 3.2 — Material budget slack `[WARN]`
- Detect: `budget_burn_dept < 0.70` AND `New Hires == 0` for the period.
- Action: flag as under-utilized budget; investigate hiring freeze or scope change.

### Rule 3.3 — Comp-per-head outlier `[INFO]`
- Detect: `|z_score(comp_per_head_dept across departments)| > 2.0`.
- Action: surface as informational; do not auto-flag — comp varies legitimately by role mix.

### Rule 3.4 — Comp share / headcount share divergence `[WARN]`
- Detect: `|comp_share_dept - headcount_share_dept| > 5 pp` AND department's `Role/Position Titles` do not obviously justify the divergence (e.g., engineering, legal, finance commonly carry higher comp).
- Action: flag for review.

### Rule 3.5 — Zero comp with non-zero headcount `[CRITICAL]`
- Detect: `Total Compensation Costs == 0` AND `Current Headcount > 0`.
- Action: flag as data error; halt department's downstream metrics.

## Category 4 — Attrition Anomalies

### Rule 4.1 — Critical attrition rate `[CRITICAL]`
- Detect: `Attrition Rate > 0.20` (20%+) for any department with `Current Headcount >= 5`.
- Action: flag as retention crisis; cross-reference with `New Hires` to assess whether hiring offsets departures.

### Rule 4.2 — High attrition warning `[WARN]`
- Detect: `Attrition Rate > 0.12` AND department's role mix indicates revenue-generating or platform-critical functions (Sales, Engineering, Operations).
- Action: flag with business-impact framing.

### Rule 4.3 — Attrition Z-score outlier `[WARN]`
- Detect: `z_score(Attrition Rate) > 2.0` across departments in the same period.
- Action: flag the outlier department; recommend root-cause analysis.

### Rule 4.4 — Attrition + under-hiring combo `[CRITICAL]`
- Detect: `Attrition Rate > 0.10` AND `hiring_gap_dept > 0.20 × Planned Headcount` AND `New Hires < expected_departures_dept`.
- Action: flag as compounding capacity loss; the department is shrinking on a net basis while behind plan.

## Category 5 — Data Quality Anomalies

### Rule 5.1 — Negative or non-integer headcount `[CRITICAL]`
- Detect: `Current Headcount`, `Planned Headcount`, or `New Hires` is negative or non-integer.
- Action: halt; request file correction.

### Rule 5.2 — Attrition rate out of range `[CRITICAL]`
- Detect: `Attrition Rate < 0` OR `Attrition Rate > 1.0` after normalization.
- Action: halt; flag as data error.

### Rule 5.3 — Department name drift `[WARN]`
- Detect (period-over-period): a department appears in current period but not prior, or vice versa, when the org map is otherwise unchanged.
- Action: flag possible rename; ask the user to confirm before treating as new/closed department.

### Rule 5.4 — Total org headcount swing > ±25% MoM `[CRITICAL]`
- Detect: `|delta_total_current_pct| > 25%`.
- Action: halt automated reporting; require human verification before publishing.

### Rule 5.5 — Malformed `Hiring Timeline` `[INFO]`
- Detect: timeline string cannot be parsed to start/end quarters.
- Action: flag with the raw value; skip pacing analysis for that department.

## Category 6 — Composite Risk

### Rule 6.1 — Composite-risk department `[WARN]`
- Detect: `risk_score >= 3` per the formula in `analytical-formulas.md` (combines under-hire, attrition, budget overrun, pacing slip).
- Action: flag for executive review with the underlying contributing factors.

## Output Format for Flagged Anomalies

Every flagged anomaly must follow this format:

```
[SEVERITY] Rule N.N — <one-line description>
  Department: <Department name(s)>
  Evidence: <metric or comparison that triggered the rule>
  Recommended action: <what HR Ops or Finance should do>
```

Display department names directly — they are not PII. Aggregate further only when the dataset includes very small departments (see `compliance-pii-guardrails.md` rule on small-cell suppression).
