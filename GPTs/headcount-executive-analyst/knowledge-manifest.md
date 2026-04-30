# Knowledge Manifest — Headcount Executive Analyst

This manifest lists the four files to upload to the GPT Builder Knowledge section.

| Order | File | Purpose | Required |
|-------|------|---------|----------|
| 1 | `knowledge/headcount-schema-dictionary.md` | Governance header + data-field schema | Yes |
| 2 | `knowledge/analytical-formulas.md` | Hiring gap, comp-per-head, budget burn, pacing, composite risk | Yes |
| 3 | `knowledge/anomaly-detection-rules.md` | Governance / plan-vs-actual / comp-budget / attrition / data-quality rules | Yes |
| 4 | `knowledge/compliance-pii-guardrails.md` | Small-department suppression + governance-name handling | Yes |

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

## Refresh Cadence

| File | Trigger |
|------|---------|
| `headcount-schema-dictionary.md` | When the source file's header or field structure changes. |
| `analytical-formulas.md` | When methodology changes (e.g., comp scope redefined). |
| `anomaly-detection-rules.md` | First 6 months: monthly threshold tuning. Then quarterly. |
| `compliance-pii-guardrails.md` | Annually or upon regulatory change. |
