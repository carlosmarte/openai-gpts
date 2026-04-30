# Headcount Schema Dictionary

This GPT is **schema-agnostic**. There is no built-in list of expected column names. Every uploaded file declares its own schema, and the GPT learns that schema from two runtime sources:

1. The **Parse-First Metadata Scan** (described below) — discovers the actual sheet names, header strings, inferred dtypes, and a small row sample.
2. The **user-supplied Column Aliases and Column References** (described in *Optional User-Supplied Inputs*) — map the user's headers and derived columns to **analytical concepts** defined in `analytical-formulas.md` (e.g., `actual_count`, `plan_target`, `attrition_rate`, `comp_spend`, `budget`).

Treat this document as the source of truth for *how* the GPT discovers structure, not *what* the structure must be.

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

Once the scan completes, the GPT injects the result into its own reasoning as an XML-tagged context block. This is internal scaffolding (not shown to the user verbatim) but it is the source of truth that downstream steps — concept resolution, validation, codegen — rely on:

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

The scan must complete before the GPT does any of the following:
- **Concept resolution** — match the user's raw headers to the analytical concepts in `analytical-formulas.md`. The user's Column Aliases drive the mapping; if no aliases are supplied and headers do not unambiguously match a concept, halt and ask.
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

The uploader may attach any of three optional inputs alongside the data file. When provided, apply them **before** schema validation and analysis. **At least one of Column Aliases or Column References must be present** unless the file's headers exactly match the analytical-concept names — otherwise the GPT cannot ground its formulas.

### ORG-Chart
- **Form:** Hierarchical mapping of leaf-entity → parent-entity (nested tree or two-column `Entity` / `Parent` table). May be supplied as JSON, YAML, CSV, or as a sidecar sheet.
- **Use:** Hierarchical roll-ups (aggregate child entities into a parent), tree-aware concentration analysis, identifying gaps at any level of the hierarchy. Use the user-mapped grouping column from the data as the leaf-level join key.
- **Validation:** Every value in the user's grouping column must resolve to a node in the chart; flag orphans rather than silently dropping them. Reject cycles.

### Column Aliases
- **Form:** A mapping from the uploader's column names to **analytical concepts** defined in `analytical-formulas.md`. Concept names include (non-exhaustive): `entity_id`, `actual_count`, `plan_target`, `inflow_count`, `attrition_rate`, `comp_spend`, `budget`, `role_descriptors`, `timeline`. Example map: `{"FTE": "actual_count", "Plan": "plan_target", "Dept": "entity_id"}`. May be supplied inline in the prompt, as a sidecar file, or as a header row prefixed with `# alias:`.
- **Use:** Resolve incoming columns to canonical concepts before validation. Preserves the analytical contract (formulas keyed to concepts) while accepting heterogeneous source files.
- **Validation:** Do not coerce silently. When the source file is ambiguous (e.g., two source columns aliased to the same concept, or an alias targets an unknown concept), confirm with the user before applying. Record every alias applied in the output's "Caveats" section.

### Column References
- **Form:** Declared relationships between columns — derived columns (`comp_per_head = comp_spend / actual_count`), foreign-key references into another sheet, or cross-sheet join keys. May be supplied as a list of formulas or a JSON spec.
- **Use:** Cross-column validation, derived-column re-computation (do not trust supplied values without re-deriving), and join-key resolution when the user supplies multiple sheets.
- **Validation:** Recompute every declared derivation. Flag rows where the supplied value diverges from the recomputed value by more than 1% (or a tolerance specified by the user). For foreign-key references, flag unresolved keys; do not invent matches.

## Cross-Field Validation Rules (Generic)

These rules apply once concepts have been resolved via Column Aliases. They reference *concepts*, not specific column names — the GPT substitutes the user's actual column names at runtime.

| Rule | Check | Action if violated |
|------|-------|-------------------|
| Count integer | Any concept of type `count` (e.g., `actual_count`, `plan_target`, `inflow_count`) is a non-negative integer. | Flag invalid rows. |
| Rate range | Any concept of type `rate` (e.g., `attrition_rate`) lies in `[0, 1]` after normalization (or `[0, 100]` if percent string). | Flag values outside range as data error. |
| Spend positivity | If `comp_spend > 0` is expected, flag zero-spend rows with non-zero count. | Flag suspicious rows. |
| Budget plausibility | `budget >= comp_spend × 0.5` (rough sanity). | Flag rows where budget is implausibly small relative to actuals. |
| Timeline coherence | If a `timeline` concept is supplied, its parsed end-period must lie within the planning horizon implied by the data. | Flag malformed or impossible timelines. |

If a concept is not present in the user's mapping, the corresponding rule is silently skipped — never fabricated.
