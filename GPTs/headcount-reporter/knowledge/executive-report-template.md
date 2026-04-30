# Executive Monthly Headcount Report — Canonical Template

**Template version:** 3.0 (concept-keyed, schema-agnostic)
**Locked sections:** 4 (Executive Summary, Entity Snapshot, Inflow & Rate Analysis, Spend & Anomalies)

This template is the contract between the reporter GPT and its executive consumers. Do not reorder, rename, or skip sections — period-over-period comparability depends on strict template adherence. Concrete column names are not baked in; the template renders the **user-mapped column** for each analytical concept (see `analytical-formulas.md` for concept names).

---

## Title Format

```
# Monthly Executive Headcount Report — {Month YYYY}
*Reporting period: {YYYY-MM-01} to {YYYY-MM-DD}. Prior period: {YYYY-MM-01} to {YYYY-MM-DD}.*
```

If snapshot-only (no prior file), append `*[Snapshot only — no prior-period comparison]*` under the title.

---

## Section 1 — Executive Summary

Produces 5-6 bullets, conditioned on which concepts the user mapped. Skip a bullet whose concepts are not mapped.

```
## 1. Executive Summary

- Total `actual_count`: **{N}** (`plan_target`: {N_planned}, gap: **{+/-N (+/-P%)}**)   ← if actual_count + plan_target mapped
- Net `inflow_count` this period: **{N_in}** (prior: {N_in_prior}, delta: {+/-N (+/-P%)})   ← if inflow_count mapped
- Weighted-average `attrition_rate`: **{P}%** (prior: {P_prior}%, delta: {+/-Pp pp})   ← if attrition_rate mapped
- Total `comp_spend`: **${C}** vs total `budget` **${B}** (burn: {P_burn}%)   ← if comp_spend + budget mapped
- Top anomaly: {short description, severity, see §4 reference}
- Composite-risk entities (P12 risk_score ≥ 3): {comma-separated list, or "None"}
```

Weighted-average rate (P11 input): `sum(actual_count × rate) / sum(actual_count)`.
`pp` = percentage points, used for rate-on-rate deltas.

---

## Section 2 — Entity Snapshot

One required table covering every entity. Column headers in the table render the user-mapped column name with the concept noted in parentheses.

```
## 2. Entity Snapshot

| {entity_id col} | {actual_count col} | {plan_target col} | Gap | {inflow_count col} | {attrition_rate col} | {comp_spend col} | {budget col} | Burn |
|---|---|---|---|---|---|---|---|---|
| {Entity 1} | {N} | {N_planned} | {+/-N} | {N_in} | {P}% | ${C} | ${B} | {P_burn}% |
| {Entity 2} | ... | ... | ... | ... | ... | ... | ... | ... |
| ... | | | | | | | | |
| **Total** | **{N}** | **{N_planned}** | **{+/-N}** | **{N_in}** | **{P_wavg}%** | **${C}** | **${B}** | **{P_burn}%** |
```

Columns whose concept is not mapped are omitted from the table — never rendered as `N/A`. Sort by absolute Plan Gap (P2) descending. Display all entities — do not bucket into "Other" since row counts at this aggregation are usually manageable. For wide rows, allow horizontal scroll.

For any entity with `actual_count < 5`, replace any spend-derived column (`comp_spend`, Burn, per-capita) with `*` and add a footnote `* Suppressed (n<5) for privacy.` per `compliance-pii-guardrails.md`.

---

## Section 3 — Inflow & Rate Analysis

Three subsections. Skip a subsection whose required concepts are not mapped.

```
## 3. Inflow & Rate Analysis

### 3.1 Top Plan Gaps (largest negative gap first)
| {entity_id col} | Gap | % of Plan | {timeline col} | Pacing |
|---|---|---|---|---|
| {Entity} | -{N} | -{P}% | {window} | {On track / Behind / Ahead} |
| ... | | | | |

### 3.2 Rate Concentration (top 5 by rate, entities with `actual_count ≥ 5`)
| {entity_id col} | {attrition_rate col} | Z-score | Expected Departures (P7) | {inflow_count col} | Net (P4) |
|---|---|---|---|---|---|
| {Entity} | {P}% | {z} | {N_dep} | {N_in} | {+/-N} |
| ... | | | | | |

### 3.3 Plan Re-baselining (period-over-period, if prior file provided)
| {entity_id col} | {plan_target} (prior) | {plan_target} (current) | Δ | Trigger |
|---|---|---|---|---|
| {Entity} | {N_prior} | {N_now} | {+/-N (+/-P%)} | {[INFO] / blank} |
```

If no prior file: replace 3.3 with `Plan re-baselining: not applicable (no prior period file provided).`
If `timeline` is not mapped, omit the Pacing column from 3.1.
If `attrition_rate` is not mapped, omit subsection 3.2.

---

## Section 4 — Spend & Anomalies

Two subsections. Skip 4.1 if `comp_spend` and `budget` are not both mapped.

```
## 4. Spend & Anomalies

### 4.1 Burn (entities outside the 70–105% band)
| {entity_id col} | {comp_spend col} | {budget col} | Burn | Status |
|---|---|---|---|---|
| {Entity} | ${C} | ${B} | {P}% | {[CRITICAL] over / [WARN] slack} |
| ... | | | | |

If all entities are within the 70–105% band: write `All entities within target burn range (70–105%).`

### 4.2 Anomalies
1. **[CRITICAL] Rule N.N — {short description}**
   - Entity: {Entity}
   - Evidence: {trigger metric, citing pattern P1–P12}
   - Recommended action: {what the relevant function should do}

2. **[WARN] Rule N.N — {short description}**
   ...

3. **[INFO] Rule N.N — {short description}**
   ...
```

If no anomalies above WARN are detected: `No anomalies above the WARN threshold this period.`

If a `[CRITICAL]` anomaly fires, prepend the entire report with:
```
> ⚠️ CRITICAL ALERT — Human verification required before circulating this report. See §4.2.
```

---

## Footer

```
---
**Files used:**
- Current period: `{filename_current}` ({N_rows_current} rows, period: {YYYY-MM})
- Prior period: `{filename_prior}` ({N_rows_prior} rows, period: {YYYY-MM})
- Concept map applied: {compact JSON of alias_map → user columns}
- References recomputed: {comma-separated list, or "None"}
- ORG-Chart: {supplied / not supplied}

**Report generated:** {YYYY-MM-DD}
**Template version:** 3.0
```

---

## Format Specifications

### Delta format
- Absolute + percentage: `+5 (+1.9%)` or `-3 (-2.1%)`.
- Zero change: `±0 (0.0%)`.
- Rate-on-rate: `+0.6pp` (percentage points), not `+0.6%`.
- Currency delta: `+$50,000 (+1.2%)`.

### Number rounding
- Counts: whole numbers.
- Currency: nearest unit with thousands separators (`$1,200,000`).
- Percentages: one decimal (`12.0%`).
- Z-scores: two decimals.

### Date format
- Reporting periods: `YYYY-MM`.
- Specific dates: `YYYY-MM-DD`.

### Severity tags
- `[CRITICAL]` — halt-and-verify required.
- `[WARN]` — surface to executive attention; no halt.
- `[INFO]` — inform but do not require action.

## Versioning

Template changes are versioned. v3.0 (this template) is concept-keyed and schema-agnostic — every column header in the rendered output is the user-mapped column name resolved via Column Aliases at runtime. Treat schema-driven template changes as a one-time migration with a clear cut-over date — do not re-render historical reports under the new template unless the underlying mapping is re-applied.
