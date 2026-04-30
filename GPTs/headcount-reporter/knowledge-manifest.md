# Knowledge Manifest — Headcount Reporter

This manifest lists the seven files to upload to the GPT Builder Knowledge section. Manifest body (file-list table, validation tests, refresh cadence) will be regenerated when the row-per-employee knowledge bundle lands; the current row-per-entity body below is retained for reference until then.

| Order | File | Purpose | Required |
|-------|------|---------|----------|
| 1 | `headcount-schema-dictionary.md` | Data-field schema validation; Parse-First Metadata Scan; Optional User-Supplied Inputs (ORG-Chart, Aliases, References) | Yes |
| 2 | `analytical-formulas.md` | Hiring gap, comp-per-head, budget burn, pacing | Yes |
| 3 | `executive-report-template.md` | Canonical 4-section report skeleton (template v2.0) | Yes |
| 4 | `anomaly-detection-rules.md` | Section 4 anomaly checks | Yes |
| 5 | `compliance-pii-guardrails.md` | Small-department suppression + demographic guardrails | Yes |
| 6 | `code-generation-templates.md` | Codegen Export Mode templates: Power Query M / Pandas / DuckDB / R / Office Scripts / VBA | Yes |

## Upload Procedure

1. Open the GPT Builder → Configure tab → Knowledge section.
2. Upload every file from the repo `knowledge/` directory (uploaded files appear flat in GPT Builder, by basename — system-instructions reference them as bare filenames, e.g., `Column.md`).
3. Verify each appears with a green checkmark.
4. Save the GPT.

## Validation Tests

Run these tests in the GPT Builder preview pane after upload:

1. **Template adherence test** — Upload a sample row-per-entity dataset (with a Column Alias map) and ask "Generate the monthly report." Expected: the four canonical sections (Executive Summary → Entity Snapshot → Inflow & Rate Analysis → Spend & Anomalies) appear in order with the correct table structures and column headers rendered as the user-mapped names.
2. **Delta format test** — Upload current and prior files. Expected: deltas formatted as `+N (+P%)`, rates as `+0.6pp`, never bare numbers.
3. **Missing-prior behavior** — Upload only the current file. Expected: the GPT asks for the prior file or explicitly labels output as "Snapshot only."
4. **Critical-swing halt** — Upload two files with a 30%+ total headcount swing. Expected: the GPT halts and requests human verification.
5. **Concept-validation halt** — Upload a file whose Column Alias map omits a concept the report depends on (e.g., `budget` for the burn section). Expected: the GPT halts and reports the missing concept rather than guessing.
6. **Small-entity suppression** — Include an entity with `actual_count = 3`. Expected: spend-derived columns (`comp_spend`, Burn) show `*` for that row with the privacy footnote.
7. **Column-alias test** — Upload a file whose headers do not match concept names, supplied with an inline Column Alias map. Expected: the GPT applies the aliases, runs concept-keyed validation, and lists the applied aliases in the "Files used" footer.
8. **ORG-Chart roll-up test** — Upload a flat row-per-entity file plus a sidecar ORG-Chart. Expected: parent-level roll-ups appear beneath the leaf-level Entity Snapshot table.
9. **Column-reference recomputation test** — Upload a file with a derived column plus a Column Reference declaring its formula. Expected: the GPT recomputes and flags rows where the supplied value diverges by >1%.
10. **No-file precondition test** — Ask for "this month's report" with no file attached. Expected: the GPT halts and asks for a `.xlsx`/`.csv` file rather than producing a templated report on imagined data.
11. **Pasted-numbers refusal test** — Paste a small headcount table directly into the chat. Expected: refusal to report on pasted text; request for an attached file.
12. **Non-canonical-headers halt test** — Upload a file whose headers do not match any canonical name **without** an Alias map. Expected: the GPT halts, names the missing canonical fields, and requests a Column Alias map rather than guessing.
13. **Parse-First scan integrity test** — Upload a file with an unexpected sheet name. Expected: the GPT reports the actual sheet name and headers from its parse-first scan and asks the user to confirm the target sheet before loading the dataframe.
14. **Question Mode (text + Logic) test** — After uploading a file, ask: "Which department has the largest MoM hiring gap?" without requesting code. Expected: a one-to-three-sentence text answer with concrete numbers and a `**Logic:**` block citing canonical fields, the formula reference, filters/scope, and a one-line pandas snippet — not the full templated report.
15. **Codegen Export (Pandas) test** — Ask: "Export the Entity Snapshot as Python." Expected: the standard envelope (`Generated for:`, `Language:`, `Setup notes:`, code block, `Logic:`); the code uses `pd.read_excel(... usecols=[<literal user-mapped column names>], engine="openpyxl")` with the literal sheet name; no placeholders.
16. **Codegen Export (Power Query M) test** — Ask: "Give me the M code that produces the Budget & Anomalies table." Expected: an M `let … in` block with a `DynamicPath` named-range setup note, `Table.PromoteHeaders`, and `Table.SelectColumns(..., MissingField.UseNull)`.
17. **Codegen Export (DuckDB SQL) test** — Ask: "Convert this report to DuckDB for a 200k-row file." Expected: `INSTALL excel; LOAD excel;` plus a `read_xlsx(..., sheet = '<name>', all_varchar = true)` query selecting the literal column names.
18. **Codegen Export (R) test** — Ask: "Give me the R version with dplyr." Expected: `library(readxl)` + `library(dplyr)`; `read_excel()` piped into `select(<literal column names>)`.
19. **Codegen Export (Office Scripts) test** — Ask: "Give me the Office Script (TypeScript) version." Expected: `function main(workbook: ExcelScript.Workbook)` body using `getColumnByName(...).getRangeBetweenHeaderAndTotal()` + `copyFrom(..., ExcelScript.RangeCopyType.values, false, false)`.
20. **Codegen Export (VBA) test** — Ask: "Now as a VBA macro." Expected: `Sub` using `.Find(What:=..., LookAt:=xlWhole)`, `xlUp` for last-row, `Application.ScreenUpdating = False/True` bracketing.
21. **Anti-placeholder test** — In any Codegen test above, scan the emitted code for strings like `<insert ... here>`, `TODO`, `your_path`, or `column_name`. Expected: zero matches.

## Refresh Cadence

| File | Trigger |
|------|---------|
| `headcount-schema-dictionary.md` | Quarterly or HRIS schema change. |
| `analytical-formulas.md` | When methodology changes. |
| `executive-report-template.md` | Quarterly review with executive consumers. **Treat changes as versioned (v1 → v2) to preserve cross-period comparability.** |
| `anomaly-detection-rules.md` | First 6 months: monthly. Then quarterly. |
| `compliance-pii-guardrails.md` | Annually or regulatory change. |
| `code-generation-templates.md` | When a target library or API ships a breaking change (DuckDB excel-extension version bump, Excel JS API revision, Pandas engine deprecation). Quarterly review otherwise. |
