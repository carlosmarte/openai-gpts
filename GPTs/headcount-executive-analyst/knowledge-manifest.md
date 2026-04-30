# Knowledge Manifest — Headcount Executive Analyst

This manifest lists the four files to upload to the GPT Builder Knowledge section.

| Order | File | Purpose | Required |
|-------|------|---------|----------|
| 1 | `knowledge/headcount-schema-dictionary.md` | Governance header + 9-column schema | Yes |
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

## Refresh Cadence

| File | Trigger |
|------|---------|
| `headcount-schema-dictionary.md` | When the source file's header or column structure changes. |
| `analytical-formulas.md` | When methodology changes (e.g., comp scope redefined). |
| `anomaly-detection-rules.md` | First 6 months: monthly threshold tuning. Then quarterly. |
| `compliance-pii-guardrails.md` | Annually or upon regulatory change. |
