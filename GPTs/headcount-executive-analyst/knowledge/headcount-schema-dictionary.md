# Headcount Schema Dictionary

This GPT is **schema-agnostic**. There is no built-in list of expected column names. Every uploaded file declares its own schema, and the GPT learns that schema from two runtime sources:

1. The **Parse-First Metadata Scan** (below) — discovers the workbook's actual sheet names, header strings, inferred dtypes, and a small row sample.
2. **`Column.md`** (loaded at runtime) — resolves the file's literal headers to canonical column names via aliases and regex search-patterns.

Treat this document as the source of truth for *how* the GPT discovers structure, not *what* the structure must be.

## Parse-First Metadata Scan

Before loading the full dataframe, the GPT runs a **low-memory metadata scan** to enumerate the workbook's structure without paying the cost of a full ingest. *Parse first, reason second* — read the map before walking the territory.

### Scan procedure (Code Interpreter)

Use `openpyxl` in `read_only=True` mode so headers are streamed without loading the workbook into RAM:

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
    scan[sheet_name] = {"headers": list(headers), "sample": sample}
wb.close()
```

For CSV inputs: `pandas.read_csv(path, nrows=3)` — same idea, no full read.

### Internal context shape

Inject the scan result into reasoning as an XML-tagged context block (internal scaffolding, not shown verbatim):

```xml
<workbook>
  <sheet name="<sheet_name_from_scan>">
    <headers><raw header strings, comma-separated></headers>
    <inferred_dtypes><dtype list aligned to headers></inferred_dtypes>
    <sample_row><values from row 2></sample_row>
  </sheet>
</workbook>
```

### Decisions the scan unblocks

The scan must complete before any of:
- **Header resolution** — walk each header through `Column.md` (canonical → alias → regex). Halt if a clause in the user's question references a concept that resolves to no literal header.
- **Sheet selection** — confirm the expected sheet exists; if multiple sheets, ask the user which one.
- **Header-row detection** — if row 1 contains merged banners or a title, locate the true header row and pass `header=N` (Pandas) / `Table.Skip` (Power Query) accordingly.
- **Date-column identification** — flag any column whose inferred dtype is `datetime` or whose `Column.md` type is `date`; these become first-class filter targets.
- **Codegen parameter injection** — emit the *literal* sheet name and column strings, never placeholders.

### Halt conditions

| Condition | Action |
|---|---|
| Workbook has multiple sheets and the user has not named one | Ask which sheet, list the sheet names from the scan |
| Headers row is empty or contains only `None` values | Ask: "row 1 looks empty — is the header row lower? confirm `header=N`" |
| A header resolves to multiple canonical names via `Column.md` (ambiguity) | List the candidates, ask the user to disambiguate |
| The inferred dtype of a column tagged as `date` is not parseable | Flag and ask whether to coerce (`pd.to_datetime(errors='coerce')`) or halt |
| File row count is 0 (header-only) | Ask: "the file has only the header row — re-upload with data?" |

## Row-Level Validation Rules

After load, run these checks against the resolved columns. Concept-keyed: a rule whose target column did not resolve via `Column.md` is silently skipped. Output appears in the run's "Run footer" alongside the matched-row count.

| ID | Rule | Severity | Detection |
|---|---|---|---|
| V1 | `employee_id` must be unique | `[CRITICAL]` | `df.employee_id.duplicated().sum() > 0` |
| V2 | `employee_id` must be non-null | `[CRITICAL]` | `df.employee_id.isna().sum() > 0` |
| V3 | `manager_id` must reference a valid `employee_id` | `[WARN]` | `~df.manager_id.isin(df.employee_id) & df.manager_id.notna()` |
| V4 | `hire_date` must parse as a date | `[WARN]` | `pd.to_datetime(df.hire_date, errors='coerce').isna().sum() > 0` (where source non-null) |
| V5 | `term_date >= hire_date` (when both present) | `[WARN]` | `df.term_date < df.hire_date` |
| V6 | `tenure_years >= 0` | `[INFO]` | `df.tenure_years < 0` |
| V7 | `manager_id` self-reference | `[INFO]` | `df.manager_id == df.employee_id` |
| V8 | `employment_status` outside known vocabulary | `[INFO]` | not in `{Active, Inactive, On Leave}` (case-insensitive) |

Severity routing: `[CRITICAL]` halts the run and asks the user how to proceed; `[WARN]` proceeds but surfaces in the footer; `[INFO]` is recorded but not displayed unless the user asks.

## Optional User-Supplied Inputs

The GPT operates on three runtime knowledge sources, in this precedence order (sidecar > inline > knowledge default):

1. **Data file** — the `.xlsx`/`.csv` itself, always required.
2. **`Column.md`** — knowledge default; user may override by uploading a sidecar with the same filename, or by supplying an inline JSON alias map at the top of the chat.
3. **`ORG-chart.md`** — knowledge default; user may override the same way (sidecar or inline level-mapping JSON).

Any override is recorded in the run footer.

## Date-Column Handling

Date columns are resolved via `Column.md` (canonical type `date`) or detected from the Parse-First scan's inferred dtypes. After load, coerce with `pd.to_datetime(df[col], errors='coerce')` and surface any coercion failures via rule V4.

Natural-language date phrases in the user's question are expanded into explicit predicates:

| Phrase | Expansion (assuming `today = 2026-04-30`) |
|---|---|
| "Q1 2026" | `>= '2026-01-01' AND < '2026-04-01'` |
| "since 2024-01-01" | `>= '2024-01-01'` |
| "last 90 days" | `>= '2026-01-30'` |
| "this month" | `>= '2026-04-01' AND < '2026-05-01'` |
| "FY2025" | depends on org fiscal calendar — ask if ambiguous |

The resolved boundary dates appear in the `Filters applied` table's Reasoning column so the user can audit the date-math.
