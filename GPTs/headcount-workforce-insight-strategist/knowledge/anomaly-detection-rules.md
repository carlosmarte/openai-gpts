# Anomaly Detection Rules — Concept-Based

Apply every rule in this document during the anomaly detection pass. Each rule has a severity tag: `[CRITICAL]`, `[WARN]`, or `[INFO]`. Like `analytical-formulas.md`, this file is keyed to **concepts**, not specific column names. Rules that depend on a concept the user did not map are silently skipped — never executed against guessed columns.

The schema is row-per-entity (the user's `entity_id` concept), so individual-record anomalies (ghost employees, contractor compliance) do not apply at this aggregation — those require an underlying record-level file.

## Category 1 — Plan-vs-Actual Anomalies

### Rule 1.1 — Material under-attainment `[WARN]`
- **Concepts required:** `actual_count`, `plan_target`, optionally `timeline`
- **Detect:** `gap > 0.25 × plan_target` (per P2) AND, if `timeline` is supplied, the timeline end-period has passed.
- **Action:** flag entity; report gap as both absolute and percentage of plan.

### Rule 1.2 — Over-attainment beyond plan `[WARN]`
- **Concepts required:** `actual_count`, `plan_target`
- **Detect:** `actual_count > plan_target × 1.10`.
- **Action:** flag for plan revision or cost review; cross-check `budget` if mapped.

### Rule 1.3 — Plan re-baselining `[INFO]`
- **Concepts required:** `plan_target` (current period and prior period)
- **Detect:** `|plan_target_now − plan_target_prior| > 0.10 × plan_target_prior` for any entity.
- **Action:** flag as plan revision; note absolute and percentage change.

### Rule 1.4 — Pacing slip `[WARN]`
- **Concepts required:** `actual_count`, `plan_target`, `inflow_count`, `timeline`
- **Detect:** `pacing_gap_pp < -0.20` (behind schedule by more than 20 percentage points, per P8).
- **Action:** flag; report which periods of the timeline have elapsed and how much inflow has occurred.

## Category 2 — Spend & Budget Anomalies

### Rule 2.1 — Budget overrun `[CRITICAL]`
- **Concepts required:** `comp_spend`, `budget`
- **Detect:** `burn > 1.05` (P6).
- **Action:** flag for finance review; cite absolute overrun.

### Rule 2.2 — Material budget slack `[WARN]`
- **Concepts required:** `comp_spend`, `budget`, `inflow_count`
- **Detect:** `burn < 0.70` AND `inflow_count == 0` for the period.
- **Action:** flag as under-utilized budget; investigate freeze or scope change.

### Rule 2.3 — Per-capita spend outlier `[INFO]`
- **Concepts required:** `comp_spend`, `actual_count`
- **Detect:** `|z_score(per_capita)| > 2.0` across entities (P5 + P11).
- **Action:** surface as informational; do not auto-flag — per-capita varies legitimately by role mix.

### Rule 2.4 — Spend share / count share divergence `[WARN]`
- **Concepts required:** `comp_spend`, `actual_count`
- **Detect:** `|spend_share − count_share| > 5pp` for an entity, where `spend_share = comp_spend_i / sum(comp_spend)` and `count_share = actual_count_i / sum(actual_count)` (P9 applied to both concepts), AND `role_descriptors` (if mapped) does not obviously justify the divergence.
- **Action:** flag for review.

### Rule 2.5 — Zero spend with non-zero count `[CRITICAL]`
- **Concepts required:** `comp_spend`, `actual_count`
- **Detect:** `comp_spend == 0` AND `actual_count > 0`.
- **Action:** flag as data error; halt entity's downstream metrics.

## Category 3 — Rate Anomalies

### Rule 3.1 — Critical rate `[CRITICAL]`
- **Concepts required:** any `rate` concept (e.g., `attrition_rate`)
- **Detect:** `rate > 0.20` for any entity with `actual_count >= 5`.
- **Action:** flag as crisis-level; cross-reference inflows to assess whether they offset outflows.

### Rule 3.2 — High rate warning `[WARN]`
- **Concepts required:** any `rate` concept, optionally `role_descriptors`
- **Detect:** `rate > 0.12` AND (if mapped) the entity's role mix indicates business-critical functions.
- **Action:** flag with business-impact framing.

### Rule 3.3 — Rate Z-score outlier `[WARN]`
- **Concepts required:** any `rate` concept across entities
- **Detect:** `z_score(rate) > 2.0` (P11) across entities in the same period.
- **Action:** flag the outlier; recommend root-cause analysis.

### Rule 3.4 — Rate + under-attainment combo `[CRITICAL]`
- **Concepts required:** `attrition_rate`, `actual_count`, `plan_target`, `inflow_count`
- **Detect:** `attrition_rate > 0.10` AND `gap > 0.20 × plan_target` (P2) AND `inflow_count < expected_departures` (P4).
- **Action:** flag as compounding capacity loss; the entity is shrinking on a net basis while behind plan.

## Category 4 — Data Quality Anomalies

### Rule 4.1 — Negative or non-integer count `[CRITICAL]`
- **Concepts required:** any `count` concept
- **Detect:** value is negative or non-integer.
- **Action:** halt; request file correction.

### Rule 4.2 — Rate out of range `[CRITICAL]`
- **Concepts required:** any `rate` concept
- **Detect:** `rate < 0` OR `rate > 1.0` after normalization.
- **Action:** halt; flag as data error.

### Rule 4.3 — Entity-name drift `[WARN]`
- **Concepts required:** `entity_id`, current and prior period
- **Detect (period-over-period):** an entity appears in current period but not prior, or vice versa, when the org map is otherwise unchanged.
- **Action:** flag possible rename; ask the user to confirm before treating as new/closed entity.

### Rule 4.4 — Total swing > ±25% MoM `[CRITICAL]`
- **Concepts required:** any aggregable concept, current and prior period
- **Detect:** `|delta_pct| > 25%` on the org-total of the concept (P10).
- **Action:** halt automated reporting; require human verification before publishing.

### Rule 4.5 — Malformed timeline `[INFO]`
- **Concepts required:** `timeline`
- **Detect:** timeline string cannot be parsed to start/end periods.
- **Action:** flag with the raw value; skip pacing analysis (Rule 1.4) for that entity.

## Category 5 — Composite Risk

### Rule 5.1 — Composite-risk entity `[WARN]`
- **Concepts required:** any inputs feeding P12
- **Detect:** `risk_score >= 3` per the composite-risk pattern P12 in `analytical-formulas.md`.
- **Action:** flag for executive review with the underlying contributing factors.

## Output Format for Flagged Anomalies

Every flagged anomaly must follow this format:

```
[SEVERITY] Rule N.N — <one-line description>
  Entity: <entity name(s) from the user's `entity_id` column>
  Evidence: <metric or comparison that triggered the rule, citing the pattern name (P1–P12)>
  Recommended action: <what the relevant function should do>
```

Display entity names directly — they are not PII at the row-per-entity aggregation. Aggregate further only when the dataset includes very small entities (see `compliance-pii-guardrails.md` rule on small-cell suppression).
