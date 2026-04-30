# Report Shape Catalog — Codegen Targets

**This GPT does not render reports itself.** It emits code (per `code-generation-templates.md`) that the user runs in Excel / Pandas / DuckDB / R / Office Scripts / VBA to produce their report. This file documents the **report shapes** that the emitted code can produce — the menu the user picks from when phrasing a question.

Each shape lists:
- The user prompt that triggers it
- The F-pattern chain (from `analytical-formulas.md`) that the GPT applies
- The output shape the user will get when the emitted code runs
- A sample header + 3 sample rows so the user can verify they asked for the right shape

The GPT picks the shape from the user's question; if ambiguous, it asks before emitting code.

---

## Shape R1 — Filtered Listing

**Sample prompt:** "Show me everyone in EMEA hired since 2024-01-01."

**F-chain:** F1 (filter) + F2 (project) + F5 (date-range, if implied)

**Output shape:** rectangular table of matching rows.

```
| employee_id | name        | region | hire_date  | manager_level |
|-------------|-------------|--------|------------|---------------|
| E1042       | Jane Doe    | EMEA   | 2024-03-15 | M2            |
| E1097       | John Smith  | EMEA   | 2024-08-22 | M0            |
| E1124       | Maya Patel  | EMEA   | 2025-01-09 | M1            |
```

**Notes:** This is the most common shape. The emitted Pandas/M/SQL code returns the filtered DataFrame and the user pages through it in Excel.

---

## Shape R2 — Single Aggregate

**Sample prompt:** "How many people in EMEA hired since 2024-01-01?"

**F-chain:** F1 + F3 (count)

**Output shape:** single number.

```
Matched 287 of 4,318 rows.
```

**Notes:** The simplest report shape — the answer is a count or sum. The emitted code prints/returns one number. Often used as a sanity check before requesting R3 or R4.

---

## Shape R3 — Group-By Summary

**Sample prompt:** "Headcount by department for EMEA Q1 hires."

**F-chain:** F1 + F3 (group-by)

**Output shape:** two-column table (group, aggregate).

```
| department  | headcount |
|-------------|-----------|
| Engineering | 142       |
| Sales       | 71        |
| Operations  | 74        |
```

**Notes:** The most common executive-report shape. Emitted code uses `df.groupby(col).size()` (Pandas), `Table.Group(...)` (M), or `GROUP BY` (SQL).

---

## Shape R4 — Cross-Tab / Pivot

**Sample prompt:** "Headcount by region × department for Q1 2026 hires."

**F-chain:** F1 + F8 (cross-tab)

**Output shape:** two-dimensional matrix.

```
| region | Engineering | Sales | Operations |
|--------|-------------|-------|------------|
| EMEA   | 142         | 71    | 74         |
| AMER   | 218         | 95    | 88         |
| APAC   | 81          | 42    | 35         |
```

**Notes:** Heaviest output shape — only emitted when the user explicitly asks for two dimensions. The emitted Pandas uses `pd.crosstab()` or `pivot_table(...)`; the M version uses `Table.Pivot`; SQL uses conditional `SUM(CASE WHEN ...)`.

---

## Shape R5 — Top-N Ranked List

**Sample prompt:** "Top 10 managers by span of control."

**F-chain:** F1 + F7 (top-N)

**Output shape:** ranked table.

```
| rank | employee_id | name      | direct_reports |
|------|-------------|-----------|----------------|
| 1    | E0042       | A. Lee    | 18             |
| 2    | E0511       | B. Kim    | 16             |
| 3    | E1024       | C. Garcia | 15             |
```

**Notes:** Spot-check is capped at 10. If the user wants more, they ask for the full ranked list and the emitted code returns all rows.

---

## Shape R6 — Hierarchy Roll-Up

**Sample prompt:** "Headcount per VP — group all reports under each VP and show the VP-level totals."

**F-chain:** F4 (subtree walk) + F6 (parent aggregation)

**Output shape:** parent-level summary, optionally with leaf-level drill-down.

```
| vp_employee_id | vp_name     | total_org | direct_reports |
|----------------|-------------|-----------|----------------|
| E0024          | A. Khan     | 287       | 8              |
| E0031          | M. Sato     | 412       | 11             |
| E0089          | P. Schmidt  | 198       | 6              |
```

**Notes:** Requires `manager_id` and resolves manager-level via `ORG-chart.md`. Emitted code does the recursive subtree walk in Pandas; SQL uses recursive CTEs.

---

## Shape R7 — Date-Bucketed Time Series

**Sample prompt:** "Hires by quarter for the last 2 years."

**F-chain:** F1 + F5 (date-range) + F3 (group-by quarter)

**Output shape:** time-series table.

```
| quarter  | hires |
|----------|-------|
| 2024-Q1  | 142   |
| 2024-Q2  | 178   |
| 2024-Q3  | 165   |
| 2024-Q4  | 203   |
| 2025-Q1  | 218   |
| ...      | ...   |
```

**Notes:** Pandas uses `df.hire_date.dt.to_period('Q')`; M uses `Date.QuarterOfYear`; SQL uses `DATE_TRUNC('quarter', ...)`. Date columns must be coerced first (rule V4 in `headcount-schema-dictionary.md`).

---

## Composing report shapes

A user prompt can chain shapes — e.g., "Top 5 departments by EMEA Q1 headcount" = R3 (group-by) + R5 (top-N), or "Headcount by region for the last 4 quarters" = R7 (time series) + R3 (group-by).

The GPT identifies the shape chain from the question and emits one code block that produces the combined output. The combined shape is documented in the spot-check + Aggregations sub-block before the codegen is requested.

---

## Anti-patterns the GPT must refuse

- **Templated multi-section reports** (the old "Executive Summary → Entity Snapshot → Inflow & Rate Analysis → Spend & Anomalies" 4-section monthly format). The user can compose multiple shape requests, but the GPT does not produce a fixed multi-section block.
- **Narrative prose accompanying a report shape.** The GPT returns data + the Filter table; narrative is the strategist's job, not the reporter's.
- **Plan-vs-actual / forecast-vs-actual.** Row-per-employee data does not contain plan targets; the user must supply a separate plan file (out of current scope).
- **MoM / QoQ delta tables** unless the user supplies two files — these require comparing snapshots, which the user composes by running R7 (time-series) twice or by uploading two files and using F1 with a "snapshot_date" column.
