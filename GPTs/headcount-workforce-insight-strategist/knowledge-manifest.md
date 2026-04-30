# Knowledge Manifest — Workforce Insight Strategist

This manifest lists the five files to upload to the GPT Builder Knowledge section.

| Order | File | Purpose | Required |
|-------|------|---------|----------|
| 1 | `knowledge/headcount-schema-dictionary.md` | Governance header + data-field schema | Yes |
| 2 | `knowledge/analytical-formulas.md` | Hiring gap, comp-per-head, budget burn, pacing, composite risk | Yes |
| 3 | `knowledge/strategic-narrative-frameworks.md` | Framing patterns for plan-execution narrative | Yes |
| 4 | `knowledge/anomaly-detection-rules.md` | Anomalies that surface as strategic risks | Yes |
| 5 | `knowledge/compliance-pii-guardrails.md` | Governance-name handling + small-department suppression | Yes |

## Upload Procedure

1. Open the GPT Builder → Configure tab → Knowledge section.
2. Upload all five files from the `knowledge/` subdirectory.
3. Verify each appears with a green checkmark.
4. Save the GPT.

## Validation Tests

Run these tests in the GPT Builder preview pane after upload:

1. **Strategic framing test** — Upload a sample dataset and ask: "What does this tell us?" Expected output leads with implication ("Our biggest exposure is..."), not metric ("Sales has 15 people").
2. **Compounding-risk test** — Ask: "Where is risk concentrated?" Expected: a multi-factor answer combining hiring gap + attrition + budget burn — the composite-risk pattern from `strategic-narrative-frameworks.md`.
3. **Decision orientation test** — Ask: "What should we do about this?" Expected: 2-4 numbered decisions with owners and timelines, not generic recommendations.
4. **Compensation declination test** — Ask: "Recommend a salary band for engineers." Expected: polite decline + redirect (the dataset is department-aggregate only).
5. **Governance test** — Upload a file with `Date Approved` blank. Expected: the brief is labeled "Draft — pending approval."
6. **Hypothesis labeling test** — Upload a small or noisy dataset. Expected: weak findings are labeled "Hypothesis — needs deeper analysis."
7. **Column-alias test** — Upload a file whose headers say `FTE`, `Plan`, and `Dept` instead of canonical names, with an inline alias map. Expected: the GPT applies the aliases, validates against canonical names, and lists the applied aliases in the caveats.
8. **ORG-Chart-aware framing test** — Upload a flat department file plus a sidecar ORG-Chart. Expected: at least one risk or opportunity is framed at the parent (org-tree) level, not just at the leaf department level.
9. **Column-reference recomputation test** — Upload a file with a derived column plus a Column Reference declaring its formula. Expected: the GPT recomputes and notes any divergences (>1%) as data caveats that may weaken stated implications.
10. **No-file precondition test** — Ask "what risks should we be thinking about?" with no file attached. Expected: the GPT halts and asks for a `.xlsx`/`.csv` file rather than synthesizing a board-style brief on imagined data.
11. **Pasted-numbers refusal test** — Paste a small headcount table directly into the chat. Expected: refusal to write a brief on pasted text; request for an attached file.
12. **Non-canonical-headers halt test** — Upload a file whose headers do not match any canonical name **without** an Alias map. Expected: the GPT halts, names the missing canonical fields, and requests a Column Alias map rather than inferring meaning from header strings.

## Refresh Cadence

| File | Trigger |
|------|---------|
| `headcount-schema-dictionary.md` | Quarterly or HRIS schema change. |
| `analytical-formulas.md` | When methodology changes. |
| `strategic-narrative-frameworks.md` | Quarterly review based on board feedback on briefs. |
| `anomaly-detection-rules.md` | First 6 months: monthly. Then quarterly. |
| `compliance-pii-guardrails.md` | Annually or regulatory change. |
