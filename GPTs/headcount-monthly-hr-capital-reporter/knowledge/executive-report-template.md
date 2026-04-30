# Executive Monthly Headcount Report — Canonical Template

**Template version:** 2.0 (department-level schema)
**Locked sections:** 4 (Executive Summary, Department Snapshot, Hiring & Attrition Analysis, Budget & Anomalies)

This template is the contract between the reporter GPT and its executive consumers. Do not reorder, rename, or skip sections — period-over-period comparability depends on strict template adherence.

---

## Title Format

```
# Monthly Executive Headcount Report — {Month YYYY}
*Reporting period: {YYYY-MM-01} to {YYYY-MM-DD}. Prior period: {YYYY-MM-01} to {YYYY-MM-DD}.*
*Prepared by: {Prepared by} on {Date Prepared} • Approved by: {Approved by} on {Date Approved}*
```

If snapshot-only (no prior file), append `*[Snapshot only — no prior-period comparison]*` under the title.

If unsigned-off, prepend the report with:
```
> ⚠️ DRAFT — file not approved. Do not circulate as authoritative.
```

---

## Section 1 — Executive Summary

Produces 5-6 bullets. Format exactly as below.

```
## 1. Executive Summary

- Total current headcount: **{N}** (planned: {N_planned}, gap: **{+/-N (+/-P%)}**)
- Net new hires this period: **{N_hires}** (prior: {N_hires_prior}, delta: {+/-N (+/-P%)})
- Weighted-average attrition rate: **{P}%** (prior: {P_prior}%, delta: {+/-Pp pp})
- Total compensation cost: **${C}** vs total budget **${B}** (burn: {P_burn}%)
- Top anomaly: {short description, severity, see §4 reference}
- Composite-risk departments (risk_score ≥ 3): {comma-separated list, or "None"}
```

Weighted-average attrition = `sum(Current Headcount × Attrition Rate) / sum(Current Headcount)`.
`pp` = percentage points, used for rate-on-rate deltas.

---

## Section 2 — Department Snapshot

One required table containing every department.

```
## 2. Department Snapshot

| Department | Current | Planned | Gap | New Hires | Attrition | Total Comp | Budget | Burn |
|---|---|---|---|---|---|---|---|---|
| {Dept 1} | {N} | {N_planned} | {+/-N} | {N_hires} | {P}% | ${C} | ${B} | {P_burn}% |
| {Dept 2} | ... | ... | ... | ... | ... | ... | ... | ... |
| ... | | | | | | | | |
| **Total** | **{N}** | **{N_planned}** | **{+/-N}** | **{N_hires}** | **{P_wavg}%** | **${C}** | **${B}** | **{P_burn}%** |
```

Sort by absolute hiring gap descending (largest under-hire first). Display all departments — do not bucket into "Other" since the row count is typically manageable (≤20 departments). For very wide rows, allow horizontal scroll in the rendered output.

For any department with `Current Headcount < 5`, replace `Total Comp` and `Burn` with `*` and add a footnote `* Suppressed (n<5) for privacy.`

---

## Section 3 — Hiring & Attrition Analysis

Three subsections.

```
## 3. Hiring & Attrition Analysis

### 3.1 Top Hiring Gaps (largest under-hire first)
| Department | Gap | % of Plan | Hiring Timeline | Pacing |
|---|---|---|---|---|
| {Dept} | -{N} | -{P}% | {Q-window} | {On track / Behind / Ahead} |
| ... | | | | |

### 3.2 Attrition Concentration (top 5 by rate, depts with ≥5 headcount)
| Department | Attrition | Z-score | Expected Departures | New Hires | Net |
|---|---|---|---|---|---|
| {Dept} | {P}% | {z} | {N_dep} | {N_hires} | {+/-N} |
| ... | | | | | |

### 3.3 Plan Re-baselining (period-over-period, if prior file provided)
| Department | Planned (prior) | Planned (current) | Δ | Trigger |
|---|---|---|---|---|
| {Dept} | {N_prior} | {N_now} | {+/-N (+/-P%)} | {[INFO] / blank} |
```

If no prior file is provided, replace 3.3 with: `Plan re-baselining: not applicable (no prior period file provided).`

---

## Section 4 — Budget & Anomalies

Two subsections.

```
## 4. Budget & Anomalies

### 4.1 Budget Burn (departments outside the 70-105% band)
| Department | Comp Cost | Budget | Burn | Status |
|---|---|---|---|---|
| {Dept} | ${C} | ${B} | {P}% | {[CRITICAL] over / [WARN] slack} |
| ... | | | | |

If all departments are within the 70-105% band: write `All departments within target burn range (70-105%).`

### 4.2 Anomalies
1. **[CRITICAL] Rule N.N — {short description}**
   - Department: {Dept}
   - Evidence: {trigger metric}
   - Recommended action: {what HR Ops or Finance should do}

2. **[WARN] Rule N.N — {short description}**
   ...

3. **[INFO] Rule N.N — {short description}**
   ...
```

If no anomalies above WARN are detected: write `No anomalies above the WARN threshold this period.`

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
  - Prepared by: {Prepared by_current} • Approved by: {Approved by_current}
- Prior period: `{filename_prior}` ({N_rows_prior} rows, period: {YYYY-MM})
  - Prepared by: {Prepared by_prior} • Approved by: {Approved by_prior}

**Report generated:** {YYYY-MM-DD}
**Template version:** 2.0
```

---

## Format Specifications

### Delta format
- Absolute + percentage: `+5 (+1.9%)` or `-3 (-2.1%)`.
- Zero change: `±0 (0.0%)`.
- Rate-on-rate: `+0.6pp` (percentage points), not `+0.6%`.
- Currency delta: `+$50,000 (+1.2%)`.

### Number rounding
- Headcount and integer counts: whole numbers.
- Currency: nearest dollar with thousands separators (`$1,200,000`).
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

Template changes are versioned. v1.0 was for the row-per-employee schema; v2.0 (this template) is for the row-per-department schema. Treat schema-driven template changes as a one-time migration with a clear cut-over date — do not re-render historical reports under the new template unless the underlying data has been re-aggregated.
