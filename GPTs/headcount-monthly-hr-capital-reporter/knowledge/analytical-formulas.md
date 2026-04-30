# Analytical Formulas — Department-Level Headcount Analytics

The authoritative methodology for every metric. Use these formulas as written; do not invent alternatives.

## 1. Total Organizational Headcount

```
total_current  = sum(Current Headcount)
total_planned  = sum(Planned Headcount)
total_new_hires = sum(New Hires)
```

## 2. Hiring Gap (Plan vs Actual)

```
hiring_gap_dept = Planned Headcount - Current Headcount
hiring_gap_total = sum(hiring_gap_dept)
```

Sign convention:
- **Positive** → department is under-hired (more roles to fill).
- **Negative** → department is over-hired (above plan).

## 3. New-Hire Fill Rate

```
fill_rate_dept = New Hires / max(hiring_gap_dept_at_period_start, 1)
```

Caps at 1.0 for reporting clarity. Use the period-start gap (Planned − Current at start of period) when both files are provided; otherwise approximate using current values and label the assumption.

## 4. Net Growth (per Department)

```
expected_attrition_dept = round(Current Headcount × Attrition Rate)
net_growth_dept         = New Hires - expected_attrition_dept
```

`net_growth_dept > 0` means the department is growing on a net basis after attrition; ≤ 0 means hiring isn't keeping pace.

## 5. Compensation Per Head

```
comp_per_head_dept = Total Compensation Costs / Current Headcount
comp_per_head_org  = sum(Total Compensation Costs) / sum(Current Headcount)
```

Use as an outlier indicator (Z-score across departments). Flag as `[INFO]` only — comp-per-head varies legitimately by department type.

## 6. Budget Burn / Coverage Ratio

```
budget_burn_dept = Total Compensation Costs / Budget Allocation per Department
budget_slack_dept = Budget Allocation per Department - Total Compensation Costs
```

Interpretation:
- `budget_burn > 1.0` → department is over budget.
- `budget_burn < 0.7` → significant slack; may indicate under-hiring or comp lag.

## 7. Attrition Impact (Forward-Looking)

```
expected_departures_dept = round(Current Headcount × Attrition Rate)
expected_departures_total = sum(expected_departures_dept)
```

Pair with `New Hires` to derive whether hiring will offset departures.

## 8. Hiring-Timeline Pacing

Parse `Hiring Timeline` to start and end quarters (e.g., "Q1-Q3 2024" → start=Q1 2024, end=Q3 2024).

```
periods_elapsed_pct = (current_period - timeline_start) / (timeline_end - timeline_start)
hires_progress_pct  = New Hires / max(Planned - period_start_Current, 1)
pacing_gap          = hires_progress_pct - periods_elapsed_pct
```

Flags:
- `pacing_gap < -0.20` → behind schedule.
- `pacing_gap > +0.20` → ahead of schedule.

## 9. Department-Level Concentration Metrics

### Headcount Share
```
share_dept = Current Headcount / total_current
```

### Comp Cost Share
```
comp_share_dept = Total Compensation Costs / sum(Total Compensation Costs)
```

### Hiring Share
```
hiring_share_dept = New Hires / total_new_hires
```

Flag any department where comp share differs from headcount share by more than 5pp without an explanation tied to role mix.

## 10. Period-over-Period Deltas (when prior file is provided)

```
delta_current_dept = Current_now - Current_prior
delta_planned_dept = Planned_now - Planned_prior  (catches re-baselining)
delta_attrition_dept = Attrition_now - Attrition_prior
delta_comp_dept = Comp_now - Comp_prior
delta_budget_dept = Budget_now - Budget_prior
```

Format every delta as `+N (+P%)` or `-N (-P%)`; for rates, use `+Pp pp` (percentage points).

## 11. Composite Risk Index (Per Department)

For each department:
```
risk_score = (
    (1 if hiring_gap_dept > 0.25 × Planned else 0) +     # major under-hire
    (1 if Attrition Rate > 0.12 else 0) +                # high attrition
    (1 if budget_burn_dept > 1.05 else 0) +              # over budget
    (1 if pacing_gap < -0.20 else 0)                     # behind hiring schedule
)
```

`risk_score >= 3` → flag as composite risk; recommend executive review.

## Reference pandas Snippets

```python
import pandas as pd

# Load with header rows handled separately
df = pd.read_csv('headcount.csv', skiprows=2)  # adjust for governance header

# Normalize attrition (handles "10.0%" or 0.10 formats)
df['Attrition Rate'] = (
    df['Attrition Rate']
      .astype(str).str.rstrip('%').astype(float)
      .pipe(lambda s: s/100 if s.max() > 1 else s)
)

# Hiring gap and fill rate
df['hiring_gap'] = df['Planned Headcount'] - df['Current Headcount']
df['fill_rate'] = df['New Hires'] / df['hiring_gap'].clip(lower=1)

# Comp per head and budget burn
df['comp_per_head'] = df['Total Compensation Costs'] / df['Current Headcount']
df['budget_burn']   = df['Total Compensation Costs'] / df['Budget Allocation per Department']

# Expected departures
df['expected_departures'] = (df['Current Headcount'] * df['Attrition Rate']).round().astype(int)
df['net_growth'] = df['New Hires'] - df['expected_departures']
```
