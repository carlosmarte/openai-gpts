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

## Parse-First Metadata Scan

Before loading the full dataframe, the GPT runs a **low-memory metadata scan** to enumerate the workbook's structure without paying the cost of a full ingest. This is the *parse first, reason second* discipline — read the map of the file before walking the territory. The scan answers four questions: what sheets exist, what headers are on each sheet, what dtypes do the first few rows imply, and where does the data actually start (i.e., are there title or merged-header rows above row 1).

### Scan procedure (Code Interpreter)

Use `openpyxl` in `read_only=True` mode (or `python-calamine` if available) so headers are streamed without loading the workbook into RAM:

```python
import openpyxl

wb = openpyxl.load_workbook("<FILE_NAME>.xlsx", read_only=True, data_only=True)

scan = {}
for sheet_name in wb.sheetnames:
    ws = wb[sheet_name]
    headers = next(ws.iter_rows(min_row=1, max_row=1, values_only=True), ())
    sample  = []
    for i, row in enumerate(ws.iter_rows(min_row=2, max_row=4, values_only=True)):
        sample.append(row)
        if i >= 2:
            break
    scan[sheet_name] = {
        "headers": [h for h in headers],
        "sample":  sample,
    }
wb.close()
```

For CSV inputs, the equivalent is `pandas.read_csv(path, nrows=3)` — same idea, no full read.

### Internal context shape

Once the scan completes, the GPT injects the result into its own reasoning as an XML-tagged context block. This is internal scaffolding (not shown to the user verbatim) but it is the source of truth that downstream steps — schema validation, alias resolution, codegen — rely on:

```xml
<workbook>
  <sheet name="Q3_Financial_Data">
    <headers>Department, Current Headcount, Planned Headcount, …</headers>
    <inferred_dtypes>str, int, int, int, float, float, str, str, float</inferred_dtypes>
    <sample_row>Engineering, 30, 35, 5, 0.12, 3500000.0, "Software Engineer, DevOps", "Q1-Q3 2024", 4200000.0</sample_row>
  </sheet>
</workbook>
```

### Decisions the scan unblocks

The scan must complete before the GPT does any of the following:
- **Schema validation** — compare scanned headers against the canonical field list above. Any mismatch is the trigger for requesting a Column Alias map (see § *Optional User-Supplied Inputs* below).
- **Sheet selection** — confirm the expected sheet exists; if multiple sheets, ask the user which one (do not guess).
- **Header-row detection** — if row 1 contains merged corporate banners or a title, locate the true header row and pass `skip=N` (R) / `header=N` (Pandas) / `Table.Skip` (Power Query) accordingly.
- **Codegen target injection** — the literal sheet name and column names emitted in any code-generation export (see `code-generation-templates.md`) are pulled from this scan, never invented.

### When the scan must halt

| Condition | Action |
|---|---|
| File is not `.xlsx` or `.csv` | Halt with: *"Only Excel (`.xlsx`) and CSV files are supported. Please re-export and re-attach."* |
| Workbook is password-protected | Halt; ask the user to remove protection or supply the password out-of-band. |
| All sheets are empty | Halt with the list of empty sheets and the file's reported row count. |
| Header row is empty (every cell None) | Halt; ask whether a title row needs to be skipped or whether the file has no header. |
| Inferred row count exceeds the GPT's per-run safe ceiling (default 250,000 rows) | Recommend the DuckDB codegen path rather than full Pandas ingest; ask the user to confirm before proceeding. |

The scan results are recorded in the run's "Caveats" / "Files used" section so the user can audit what the GPT saw before it committed to any analysis.

## Optional User-Supplied Inputs

The uploader may attach any of three optional inputs alongside the data file. When provided, apply them **before** schema validation and analysis.

### ORG-Chart
- **Form:** Hierarchical mapping of department → parent department (nested tree or two-column `Department` / `Parent` table). May be supplied as JSON, YAML, CSV, or as a sidecar sheet.
- **Use:** Hierarchical roll-ups (aggregate child departments into a parent), org-tree-aware concentration analysis, identifying gaps at any level of the hierarchy. Use `Department` from the data as the leaf-level join key.
- **Validation:** Every `Department` value in the data must resolve to a node in the chart; flag orphans rather than silently dropping them. Reject cycles.

### Column Aliases
- **Form:** A mapping from the uploader's column names to the canonical fields defined below — e.g., `{"FTE": "Current Headcount", "Plan": "Planned Headcount", "Dept": "Department"}`. May be supplied inline in the prompt, as a sidecar file, or as a header row prefixed with `# alias:`.
- **Use:** Rename incoming columns to canonical names before validation. Preserves the canonical contract while accepting heterogeneous source files.
- **Validation:** Do not coerce silently. When the source file is ambiguous (e.g., two source columns aliased to the same canonical field, or an alias targets a non-canonical field), confirm with the user before applying. Record every alias applied in the output's "Caveats" section.

### Column References
- **Form:** Declared relationships between columns — derived columns (`Comp per Head = Total Compensation Costs / Current Headcount`), foreign-key references into another sheet, or cross-sheet join keys. May be supplied as a list of formulas or a JSON spec.
- **Use:** Cross-column validation, derived-column re-computation (do not trust supplied values without re-deriving), and join-key resolution when the user supplies multiple sheets.
- **Validation:** Recompute every declared derivation. Flag rows where the supplied value diverges from the recomputed value by more than 1% (or a tolerance specified by the user). For foreign-key references, flag unresolved keys; do not invent matches.

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
