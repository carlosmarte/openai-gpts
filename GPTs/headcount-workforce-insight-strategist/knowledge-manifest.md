# Knowledge Manifest — Workforce Insight Strategist

This manifest lists the eight files to upload to the GPT Builder Knowledge section. Manifest body (file-list table, validation tests, refresh cadence) will be regenerated when the row-per-employee knowledge bundle lands; the current row-per-entity body below is retained for reference until then.

| Order | File | Purpose | Required |
|-------|------|---------|----------|
| 1 | `headcount-schema-dictionary.md` | Data-field schema; Parse-First Metadata Scan; Optional User-Supplied Inputs (ORG-Chart, Aliases, References) | Yes |
| 2 | `analytical-formulas.md` | Hiring gap, comp-per-head, budget burn, pacing, composite risk | Yes |
| 3 | `strategic-narrative-frameworks.md` | Framing patterns for plan-execution narrative | Yes |
| 4 | `anomaly-detection-rules.md` | Anomalies that surface as strategic risks | Yes |
| 5 | `compliance-pii-guardrails.md` | Small-department suppression + demographic guardrails | Yes |
| 6 | `code-generation-templates.md` | Codegen Export Mode templates: Power Query M / Pandas / DuckDB / R / Office Scripts / VBA | Yes |

## Upload Procedure

1. Open the GPT Builder → Configure tab → Knowledge section.
2. Upload every file from the repo `knowledge/` directory (uploaded files appear flat in GPT Builder, by basename — system-instructions reference them as bare filenames, e.g., `Column.md`).
3. Verify each appears with a green checkmark.
4. Save the GPT.

## Validation Tests

Run these tests in the GPT Builder preview pane after upload:

1. **Strategic framing test** — Upload a sample dataset and ask: "What does this tell us?" Expected output leads with implication ("Our biggest exposure is..."), not metric ("Sales has 15 people").
2. **Compounding-risk test** — Ask: "Where is risk concentrated?" Expected: a multi-factor answer combining hiring gap + attrition + budget burn — the composite-risk pattern from `strategic-narrative-frameworks.md`.
3. **Decision orientation test** — Ask: "What should we do about this?" Expected: 2-4 numbered decisions with owners and timelines, not generic recommendations.
4. **Compensation declination test** — Ask: "Recommend a salary band for engineers." Expected: polite decline + redirect (the dataset is entity-aggregate only).
5. **Hypothesis labeling test** — Upload a small or noisy dataset. Expected: weak findings are labeled "Hypothesis — needs deeper analysis."
6. **Column-alias test** — Upload a file whose headers do not match concept names, supplied with an inline Column Alias map. Expected: the GPT applies the aliases, validates against the mapped concepts, and lists the applied aliases in the caveats.
7. **ORG-Chart-aware framing test** — Upload a flat department file plus a sidecar ORG-Chart. Expected: at least one risk or opportunity is framed at the parent (org-tree) level, not just at the leaf department level.
8. **Column-reference recomputation test** — Upload a file with a derived column plus a Column Reference declaring its formula. Expected: the GPT recomputes and notes any divergences (>1%) as data caveats that may weaken stated implications.
9. **No-file precondition test** — Ask "what risks should we be thinking about?" with no file attached. Expected: the GPT halts and asks for a `.xlsx`/`.csv` file rather than synthesizing a board-style brief on imagined data.
10. **Pasted-numbers refusal test** — Paste a small headcount table directly into the chat. Expected: refusal to write a brief on pasted text; request for an attached file.
11. **Non-canonical-headers halt test** — Upload a file whose headers do not match any canonical name **without** an Alias map. Expected: the GPT halts, names the missing canonical fields, and requests a Column Alias map rather than inferring meaning from header strings.
12. **Parse-First scan integrity test** — Upload a file with an unexpected sheet name. Expected: the GPT reports the actual sheet name and headers from its parse-first scan and asks the user to confirm the target sheet before loading the dataframe.
13. **Question Mode (text + Logic) test** — After uploading a file, ask: "Which entity's plan gap should the board worry about most?" without requesting code. Expected: a one-to-three-sentence implication-led text answer with concrete numbers and a `**Logic:**` block citing the concepts used (with user-mapped columns in parentheses), the pattern (P2 Plan Gap), filters/scope, and a one-line pandas snippet — not a full templated brief.
14. **Codegen Export (Pandas) test** — Ask: "Export the compounding-risk roll-up as Python." Expected: the standard envelope (`Generated for:`, `Language:`, `Setup notes:`, code block, `Logic:`); `pd.read_excel(... usecols=[<literal column names>], engine="openpyxl")` with the literal sheet name; no placeholders.
15. **Codegen Export (Power Query M) test** — Ask: "Give me the M code that produces the parent-department risk table." Expected: an M `let … in` block with a `DynamicPath` named-range setup note, `Table.PromoteHeaders`, and `Table.SelectColumns(..., MissingField.UseNull)`.
16. **Codegen Export (DuckDB SQL) test** — Ask: "Convert that to DuckDB for a 250k-row file." Expected: `INSTALL excel; LOAD excel;` plus a `read_xlsx(..., sheet = '<name>', all_varchar = true)` query selecting the literal column names.
17. **Codegen Export (R) test** — Ask: "Give me the R version with dplyr." Expected: `library(readxl)` + `library(dplyr)`; `read_excel()` piped into `select(<literal column names>)`.
18. **Codegen Export (Office Scripts) test** — Ask: "Give me the Office Script (TypeScript) version." Expected: `function main(workbook: ExcelScript.Workbook)` body using `getColumnByName(...).getRangeBetweenHeaderAndTotal()` + `copyFrom(..., ExcelScript.RangeCopyType.values, false, false)`.
19. **Codegen Export (VBA) test** — Ask: "Now as a VBA macro." Expected: `Sub` using `.Find(What:=..., LookAt:=xlWhole)`, `xlUp` for last-row, `Application.ScreenUpdating = False/True` bracketing.
20. **Anti-placeholder test** — In any Codegen test above, scan the emitted code for strings like `<insert ... here>`, `TODO`, `your_path`, or `column_name`. Expected: zero matches.

## Refresh Cadence

| File | Trigger |
|------|---------|
| `headcount-schema-dictionary.md` | Quarterly or HRIS schema change. |
| `analytical-formulas.md` | When methodology changes. |
| `strategic-narrative-frameworks.md` | Quarterly review based on board feedback on briefs. |
| `anomaly-detection-rules.md` | First 6 months: monthly. Then quarterly. |
| `compliance-pii-guardrails.md` | Annually or regulatory change. |
| `code-generation-templates.md` | When a target library or API ships a breaking change (DuckDB excel-extension version bump, Excel JS API revision, Pandas engine deprecation). Quarterly review otherwise. |
