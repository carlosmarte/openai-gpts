# Headcount Schema Dictionary

The canonical schema for the monthly department-level headcount file. Each row represents a single department; the file also carries governance metadata in its header. Treat this document as the source of truth before performing any analysis.

## File Header — Governance Metadata

These four fields appear above the data table and document who owns the file:

| Field | Type | Role |
|---|---|---|
| `Prepared by` | String | Name of the analyst who built the file. |
| `Date Prepared` | Date (YYYY-MM-DD) | When the file was generated. Use this as the snapshot date if `Date Approved` is missing. |
| `Approved by` | String | Name of the executive who approved the file for distribution. |
| `Date Approved` | Date (YYYY-MM-DD) | The authoritative reporting date for the snapshot. |

Validation: if `Date Approved < Date Prepared`, the file is unsigned-off — flag it and refuse to publish executive output until approval is recorded.

## Data Columns

### `Department`
- **Type:** String (categorical)
- **Role:** Primary grouping key. One row per department.
- **Computational use:** `df.set_index('Department')`; never aggregate two rows into one without explicit instruction.
- **Gotcha:** Department names drift across periods ("R&D" vs "Research and Development"). Normalize before period-over-period comparison; maintain a department alias map if naming evolves.

### `Current Headcount`
- **Type:** Integer
- **Role:** Actual headcount in the department as of the snapshot date.
- **Computational use:** Sum across departments for total org headcount. Use as the denominator for attrition impact and comp-per-head calculations.
- **Gotcha:** This is already aggregated — there is no FTE weighting at this level. If FTE precision matters, request the underlying employee file.

### `Planned Headcount`
- **Type:** Integer
- **Role:** Target/budgeted headcount for the planning period (typically end-of-year or end-of-quarter).
- **Computational use:** Pair with `Current Headcount` to compute hiring gap (`Planned - Current`).
- **Gotcha:** Plans drift mid-year — confirm the planning vintage (Original Plan vs Re-baselined Plan) before reporting variances.

### `New Hires`
- **Type:** Integer
- **Role:** Headcount added during the reporting period.
- **Computational use:** Net-of-attrition growth = `New Hires - (Current Headcount × Attrition Rate)`. Compare to hiring gap to assess pacing.
- **Gotcha:** Defines hires *during* the period, not since plan inception. Confirm the period window with the file owner if ambiguous.

### `Attrition Rate`
- **Type:** Percentage (decimal in source, e.g., `0.10` = 10%; or string `"10.0%"`)
- **Role:** Departures during the period divided by average headcount.
- **Computational use:** Multiply by `Current Headcount` to estimate forward-looking departures; cross-tab against `Department` to find concentration.
- **Gotcha:** Confirm the period (monthly vs annualized). The image shows annualized; if monthly, multiply ×12 for comparability.

### `Total Compensation Costs`
- **Type:** Currency (USD shown; confirm currency in metadata)
- **Role:** Aggregate compensation spend for the department in the reporting period.
- **Computational use:** Divide by `Current Headcount` for comp-per-head; pair with `Budget Allocation` for spend-vs-budget.
- **Gotcha:** Scope ambiguity — does this include benefits, bonus, equity, or only salary? Confirm with file owner; document the assumption in caveats.

### `Role/Position Titles`
- **Type:** String (comma-separated representative roles)
- **Role:** Human-readable indicator of the role mix in the department. Display only.
- **Computational use:** Do not aggregate or count these — they are illustrative, not exhaustive.
- **Gotcha:** Free-text and may be incomplete. Treat as documentation, not data.

### `Hiring Timeline`
- **Type:** String (e.g., "Q1 2024", "Q1-Q3 2024", "Q2-Q4 2024")
- **Role:** When the department plans to fulfill its hiring against `Planned Headcount`.
- **Computational use:** Parse to start/end quarters; flag departments whose timeline has slipped past the current period without proportional progress on `New Hires`.
- **Gotcha:** Format varies — "Q1 2024", "Q1-Q3 2024", "2024 H1". Build a tolerant parser.

### `Budget Allocation per Department`
- **Type:** Currency (USD shown)
- **Role:** Total budget approved for the department in the planning period.
- **Computational use:** Compare to `Total Compensation Costs` for budget burn; identify under/over-spent departments.
- **Gotcha:** Budget covers the planning period; comp costs may cover only the reporting period. Annualize one or the other before comparing.

## Cross-Column Validation Rules

| Rule | Check | Action if violated |
|------|-------|-------------------|
| Approval timing | `Date Approved >= Date Prepared` | Flag as unsigned-off; do not publish. |
| Headcount integer | `Current Headcount`, `Planned Headcount`, `New Hires` are non-negative integers | Flag invalid rows. |
| Attrition range | `0 <= Attrition Rate <= 1.0` (or 0–100 if percent string) | Flag values outside range as data error. |
| Comp positivity | `Total Compensation Costs > 0` if `Current Headcount > 0` | Flag zero-comp departments with non-zero headcount. |
| Budget plausibility | `Budget Allocation >= Total Compensation Costs × 0.5` (rough sanity) | Flag departments where budget is implausibly small relative to actuals. |
| Timeline coherence | Parsed `Hiring Timeline` end-quarter is within the planning year | Flag malformed or impossible timelines. |
