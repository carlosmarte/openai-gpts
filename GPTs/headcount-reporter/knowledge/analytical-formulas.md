# Analytical Formulas — Concept-Based Patterns

This GPT does not bake in any specific column names. It operates on **analytical concepts** that the user maps to their actual columns via the Column Aliases described in `headcount-schema-dictionary.md`. Each formula below is keyed to one or more concepts; the GPT substitutes the user's column names at runtime.

If a concept is not present in the user's alias map, the corresponding formula is silently skipped — never executed against guessed columns.

## Concept Glossary

| Concept | Type | Semantic role |
|---|---|---|
| `entity_id` | string | Primary grouping key (one row per entity). |
| `parent_id` | string | Optional parent grouping key (used when an ORG-Chart is supplied). |
| `actual_count` | integer | Headcount currently in place. |
| `plan_target` | integer | Target / planned count for the planning period. |
| `inflow_count` | integer | New additions during the period (e.g., new hires). |
| `attrition_rate` | rate (0..1) | Departures during the period divided by average count. |
| `comp_spend` | currency | Aggregate compensation spend for the period. |
| `budget` | currency | Total budget approved for the planning period. |
| `role_descriptors` | string | Free-text description of the role mix (display only). |
| `timeline` | string | Plan-fulfillment window (e.g., quarter range). |

The GPT extends this glossary by introducing new concepts only when the user explicitly maps them via Column Aliases.

## Formula Patterns

Each pattern carries a **name**, an **inputs** line (concepts required), and the **expression**. The GPT cites the pattern name in every Logic block.

### P1 — Total
- **Inputs:** any count concept (e.g., `actual_count` or `plan_target`)
- **Expression:** `total = sum(<count_concept>)`
- **Use:** Org-wide rollup, totals row.

### P2 — Plan Gap
- **Inputs:** `actual_count`, `plan_target`
- **Expression:** `gap = plan_target − actual_count` (per row); `gap_pct = gap / plan_target` (when `plan_target > 0`).
- **Use:** Where is the entity behind/ahead of plan.

### P3 — Fill Rate
- **Inputs:** `actual_count`, `plan_target`
- **Expression:** `fill_rate = actual_count / plan_target` (when `plan_target > 0`).
- **Use:** What share of plan has been achieved.

### P4 — Net Growth
- **Inputs:** `actual_count`, `inflow_count`, `attrition_rate`
- **Expression:** `expected_departures = actual_count × attrition_rate`; `net_growth = inflow_count − expected_departures`.
- **Use:** Are inflows offsetting expected departures.

### P5 — Per-Capita Spend
- **Inputs:** `comp_spend`, `actual_count`
- **Expression:** `per_capita = comp_spend / actual_count` (when `actual_count > 0`).
- **Use:** Spend efficiency per head; compare across entities.

### P6 — Burn Rate
- **Inputs:** `comp_spend`, `budget`
- **Expression:** `burn = comp_spend / budget` (when `budget > 0`).
- **Use:** Share of budget consumed by actual spend.

### P7 — Attrition Impact
- **Inputs:** `actual_count`, `attrition_rate`
- **Expression:** `expected_departures = actual_count × attrition_rate`.
- **Use:** Forward-looking departure estimate; pair with P4 to assess net capacity.

### P8 — Pacing Gap
- **Inputs:** `inflow_count`, `plan_target`, `actual_count`, `timeline`
- **Expression:** Parse the timeline to start/end periods; compute fraction-elapsed `f = elapsed_periods / total_periods`; expected progress `expected_inflow = (plan_target − actual_count_at_start) × f`; `pacing_gap = inflow_count − expected_inflow` (negative = behind schedule). Express also as percentage points: `pacing_gap_pp = pacing_gap / (plan_target − actual_count_at_start)`.
- **Use:** Are hires landing on schedule or slipping.

### P9 — Concentration
- **Inputs:** any concept C, computed across all entities
- **Expression:** `share_i = C_i / sum(C)`; flag entities where `share_i > θ` (threshold supplied by user, default 0.30).
- **Use:** Identify whether risk, spend, or growth is concentrated in a few entities.

### P10 — Period-over-Period Delta
- **Inputs:** any concept C, current period vs prior period
- **Expression:** `delta_abs = C_now − C_prior`; `delta_pct = delta_abs / C_prior` (when `C_prior > 0`); for rates, use percentage points: `delta_pp = (C_now − C_prior) × 100`.
- **Use:** MoM / QoQ / YoY change tracking.

### P11 — Z-score Outlier
- **Inputs:** any concept C across entities
- **Expression:** `z_i = (C_i − mean(C)) / std(C)`; flag `|z_i| > 2.0`.
- **Use:** Surface entities whose value sits outside the typical distribution.

### P12 — Composite Risk Index
- **Inputs:** the boolean flags from P2 (negative gap), P6 (burn > 1.0), P7 (high attrition impact), P8 (negative pacing gap)
- **Expression:** `risk_score = sum(flag_i for i in [gap, burn, attrition, pacing])`; values 0–4.
- **Use:** Single rollup signal for "this entity is concerning on multiple dimensions."

## Pandas Reference Snippet (Concept-Driven)

The snippet below illustrates how the GPT applies these patterns once Column Aliases have resolved concepts to user columns. The variables `c_actual`, `c_plan`, etc. hold the user's actual column-name strings.

```python
import pandas as pd

df = pd.read_csv('headcount.csv')

# c_* are resolved at runtime from the user's Column Aliases
c_actual    = alias_map['actual_count']
c_plan      = alias_map['plan_target']
c_inflow    = alias_map['inflow_count']
c_attrition = alias_map['attrition_rate']
c_spend     = alias_map['comp_spend']
c_budget    = alias_map['budget']

# Normalize rate (handles percent-string formats)
df[c_attrition] = (
    df[c_attrition].astype(str).str.rstrip('%').astype(float)
      .pipe(lambda s: s/100 if s.max() > 1 else s)
)

# P2 Plan Gap and P3 Fill Rate
df['gap']       = df[c_plan]   - df[c_actual]
df['fill_rate'] = df[c_actual] / df[c_plan]

# P5 Per-Capita Spend, P6 Burn Rate
df['per_capita'] = df[c_spend] / df[c_actual]
df['burn']       = df[c_spend] / df[c_budget]

# P4 Net Growth, P7 Attrition Impact
df['expected_departures'] = df[c_actual] * df[c_attrition]
df['net_growth']          = df[c_inflow] - df['expected_departures']
```

Every output number must be traceable to one of the patterns above. The Logic block in Question Mode cites the pattern name (e.g., "**Logic:** P2 (Plan Gap) on `actual_count` (= `<user column>`) and `plan_target` (= `<user column>`).") so the user can audit instantly.

## Numerical Conventions

- **Currency:** preserve the user's currency; surface USD only if the user confirms. Display with thousands separators.
- **Percentages:** display to one decimal (`12.5%`). Internally store as fractions in `[0, 1]`.
- **Rate deltas:** percentage points (`+0.6pp`), not relative percent.
- **Counts:** integers; flag floats as a data-quality issue per the cross-field validation rules in `headcount-schema-dictionary.md`.
- **Dates:** ISO format (`YYYY-MM-DD`).

## What This File Does Not Define

This file does not enumerate fields, column names, or schema. The user's file structure is discovered via the Parse-First Metadata Scan and resolved via Column Aliases (see `headcount-schema-dictionary.md`). If a needed concept is not in the user's mapping, halt and ask — do not invent.
