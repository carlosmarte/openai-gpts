# Knowledge Manifest — Headcount Executive Analyst

This manifest lists the five files to upload to the GPT Builder Knowledge section.

| Order | File | Purpose | Required |
|-------|------|---------|----------|
| 1 | `knowledge/headcount-schema-dictionary.md` | Governance header + data-field schema; Parse-First Metadata Scan; Optional User-Supplied Inputs (ORG-Chart, Aliases, References) | Yes |
| 2 | `knowledge/analytical-formulas.md` | Hiring gap, comp-per-head, budget burn, pacing, composite risk | Yes |
| 3 | `knowledge/anomaly-detection-rules.md` | Governance / plan-vs-actual / comp-budget / attrition / data-quality rules | Yes |
| 4 | `knowledge/compliance-pii-guardrails.md` | Small-department suppression + governance-name handling | Yes |
| 5 | `knowledge/code-generation-templates.md` | Codegen Export Mode templates: Power Query M / Pandas / DuckDB / R / Office Scripts / VBA | Yes |

## Upload Procedure

1. Open the GPT Builder → Configure tab → Knowledge section.
2. Click "Upload files" and select all four files from the `knowledge/` subdirectory.
3. Verify each file appears in the Knowledge list with a green checkmark.
4. Save the GPT.

## Validation Tests

After upload, run these tests in the GPT Builder preview pane:

1. **Schema lookup test** — Ask: "What does the `Hiring Timeline` column mean?" Expected: a definition matching the dictionary, including the parsing notes for "Q1-Q3 2024" formats.
2. **Formula adherence test** — Ask: "How do you calculate budget burn?" Expected: the formula `Total Compensation Costs / Budget Allocation per Department` from `analytical-formulas.md`.
3. **Anomaly rule test** — Ask: "What anomalies do you check for?" Expected: a summary covering governance, plan-vs-actual, comp/budget, attrition, and data-quality categories.
4. **Governance halt test** — Upload a file with no `Date Approved`. Expected: refusal to publish executive output until approval is recorded.
5. **Small-department suppression test** — Upload a row with `Current Headcount = 3`. Expected: `comp_per_head` displayed as `*` with the privacy footnote.
6. **Column-alias test** — Upload a file whose headers say `FTE`, `Plan`, and `Dept` instead of canonical names, with an inline alias map. Expected: the GPT applies the aliases, runs schema validation against the canonical names, and lists the applied aliases in the caveats.
7. **ORG-Chart roll-up test** — Upload a flat department file plus a sidecar ORG-Chart (parent/child). Expected: every `Department` resolves to a node (orphans flagged), and parent-level roll-ups appear in the analysis.
8. **Column-reference recomputation test** — Upload a file with a derived column (e.g., `Comp per Head`) plus a Column Reference declaring its formula. Expected: the GPT recomputes the derivation and flags rows where the supplied value diverges by >1%.
9. **No-file precondition test** — Send a prompt asking for analysis with **no** Excel/CSV file attached and no numbers in the prompt. Expected: the GPT halts and asks for a `.xlsx`/`.csv` file rather than fabricating analysis.
10. **Pasted-numbers refusal test** — Paste a small headcount table directly into the chat without attaching a file. Expected: the GPT refuses to analyze the pasted text and requests an attached file.
11. **Non-canonical-headers halt test** — Upload a file whose headers do not match any canonical name **without** an Alias map. Expected: the GPT halts, names the missing canonical fields, and requests a Column Alias map rather than guessing.
12. **Parse-First scan integrity test** — Upload a file with an unexpected sheet name (e.g., `2026Q2-Apr` instead of `Q3_Financial_Data`). Expected: the GPT reports the actual sheet name and headers from its parse-first scan and asks the user to confirm the target sheet before loading the dataframe.
13. **Question Mode (text + Logic) test** — Ask: "Which department has the largest hiring gap?" without requesting code. Expected: a one-to-three-sentence text answer with concrete numbers, optionally a small markdown table, and a `**Logic:**` block citing canonical fields, the formula reference (`Hiring Gap = Planned − Current`), filters/scope, and a one-line pandas snippet. No code dump.
14. **Codegen Export Mode (Pandas) test** — Ask: "Export this analysis as Python." Expected: the standard envelope (`**Generated for:**` line with sheet + columns, `**Language:**` line, `**Setup notes:**` line, code block, `**Logic:**` line); the code uses `pd.read_excel(... usecols=[<literal column names>], engine="openpyxl")` with the literal sheet name from the parse-first scan; no placeholders.
15. **Codegen Export Mode (Power Query M) test** — Ask: "Give me the Power Query M for the same extraction." Expected: an M `let … in` block with a `DynamicPath` named-range setup note, `Table.PromoteHeaders`, and `Table.SelectColumns(..., MissingField.UseNull)`.
16. **Codegen Export Mode (DuckDB SQL) test** — Ask: "Convert that to DuckDB for a 200k-row file." Expected: `INSTALL excel; LOAD excel;` plus a `read_xlsx(..., sheet = '<name>', all_varchar = true)` query selecting the literal column names; no full-table scan-then-drop.
17. **Codegen Export Mode (R) test** — Ask: "Give me the R version with dplyr." Expected: `library(readxl)` + `library(dplyr)`; `read_excel()` piped into `select(<literal column names>)`; backtick-quoted names where needed.
18. **Codegen Export Mode (Office Scripts) test** — Ask: "Give me the Office Script (TypeScript) version." Expected: `function main(workbook: ExcelScript.Workbook)` body using `getColumnByName(...).getRangeBetweenHeaderAndTotal()` + `copyFrom(..., ExcelScript.RangeCopyType.values, false, false)`; cell-by-cell loops are absent.
19. **Codegen Export Mode (VBA) test** — Ask: "Now as a VBA macro." Expected: `Sub` using `.Find(What:=..., LookAt:=xlWhole)`, `xlUp` for last-row, `Application.ScreenUpdating = False/True` bracketing, and a timestamped destination sheet; no hardcoded column letters like `Range("C:C")`.
20. **Anti-placeholder test** — In any Codegen test above, scan the emitted code for strings like `<insert ... here>`, `TODO`, `your_path`, or `column_name`. Expected: zero matches.

## Refresh Cadence

| File | Trigger |
|------|---------|
| `headcount-schema-dictionary.md` | When the source file's header or field structure changes; or when the Parse-First scan procedure changes (new library, new halt condition). |
| `analytical-formulas.md` | When methodology changes (e.g., comp scope redefined). |
| `anomaly-detection-rules.md` | First 6 months: monthly threshold tuning. Then quarterly. |
| `compliance-pii-guardrails.md` | Annually or upon regulatory change. |
| `code-generation-templates.md` | When a target library or API ships a breaking change (e.g., DuckDB excel-extension version bump, Excel JS API revision, Pandas engine deprecation). Quarterly review otherwise. |
