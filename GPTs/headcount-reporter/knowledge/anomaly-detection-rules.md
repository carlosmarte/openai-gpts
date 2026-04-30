# Anomaly Detection Rules — Row-Level Data Quality

Run every applicable rule against the **matched rows** (post-F1 filter) on every run. Each rule has a severity tag: `[CRITICAL]`, `[WARN]`, or `[INFO]`. Rules whose target column did not resolve via `Column.md` are silently skipped — never executed against guessed columns.

Rules are partitioned into two passes:
- **Pass A (Pre-filter, on full DataFrame):** structural data-quality rules that should fire regardless of the user's filter (uniqueness, FK integrity).
- **Pass B (Post-filter, on matched rows):** local-quality rules that surface in the run footer alongside the matched-row count.

---

## Pass A — Structural (Full DataFrame)

| ID | Rule | Severity | Detection | Action |
|---|---|---|---|---|
| A1 | `employee_id` is unique | `[CRITICAL]` | `df.employee_id.duplicated().sum() > 0` | Halt, list the dup IDs and their row indices |
| A2 | `employee_id` is non-null | `[CRITICAL]` | `df.employee_id.isna().sum() > 0` | Halt, report the count of null rows |
| A3 | `manager_id` references a valid `employee_id` (or is null) | `[WARN]` if <5%, `[CRITICAL]` if >5% | `~df.manager_id.isin(df.employee_id) & df.manager_id.notna()` | Surface count + 5 example dangling IDs; if >5%, halt and ask whether to proceed |
| A4 | Manager hierarchy is single-rooted | `[CRITICAL]` | `df[df.manager_id.isna()].shape[0] > 1` | List the multiple roots; ask whether the data is multi-tenant or whether one is the canonical root |
| A5 | No manager-chain cycles | `[CRITICAL]` | DFS on `manager_id` graph detects a back-edge | Halt, list the cycle members |
| A6 | Date columns parse as dates | `[WARN]` | `pd.to_datetime(df[date_col], errors='coerce').isna().sum() > 0` (where source non-null) | Surface count + 3 example malformed values; coerce with `errors='coerce'` and continue |

Pass A runs once per upload, cached for the run.

---

## Pass B — Local Quality (Matched Rows)

| ID | Rule | Severity | Detection | Action |
|---|---|---|---|---|
| B1 | `term_date >= hire_date` | `[WARN]` | `matched[(matched.term_date.notna()) & (matched.term_date < matched.hire_date)]` | Surface count + IDs in footer |
| B2 | `tenure_years >= 0` | `[INFO]` | `matched[matched.tenure_years < 0]` | Surface count in footer |
| B3 | `manager_id == employee_id` (self-reference) | `[INFO]` | `matched[matched.manager_id == matched.employee_id]` | Surface count + IDs in footer |
| B4 | `employment_status` outside known vocabulary | `[INFO]` | not in `{Active, Inactive, On Leave}` (case-insensitive) | List the unknown values with counts |
| B5 | Required column for the question is null on a matched row | `[WARN]` | any column referenced by the user's filter has nulls in matched rows | Surface count; null-rows are excluded from aggregations |
| B6 | Matched-row count is 0 | `[INFO]` | `matched.shape[0] == 0` | Headline "matched 0 rows"; suggest broadening the filter |
| B7 | Matched-row count is the full file | `[INFO]` | `matched.shape[0] == df.shape[0]` | Headline notes the filter was a no-op; suggest tightening |

---

## Severity Routing

| Tag | Behavior |
|---|---|
| `[CRITICAL]` | Halt the run. State the rule ID, the offending count or IDs, and ask the user how to proceed. |
| `[WARN]` | Proceed, but include the rule firing in the run footer. The user should know the result is conditioned on a known data-quality issue. |
| `[INFO]` | Recorded in the footer's "Notes" section but not displayed unless the user asks. |

---

## Anti-patterns the GPT must refuse

- **Silent imputation.** Never fill missing `employee_id`, `manager_id`, or date values without explicit user permission.
- **Aggressive coercion.** Never silently strip or rewrite values that fail validation. Surface them.
- **Filter-then-suppress.** If a row matches the user's filter but fails Pass A (e.g., dup `employee_id`), do not silently exclude it — surface the issue and let the user decide.
- **Confidence inflation.** When `[WARN]` rules fire, do not present the result as "clean" — the run footer must transparently list every fired rule.
