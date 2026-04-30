# Knowledge Manifest — Monthly HR Capital Reporter

This manifest lists the five files to upload to the GPT Builder Knowledge section.

| Order | File | Purpose | Required |
|-------|------|---------|----------|
| 1 | `knowledge/headcount-schema-dictionary.md` | Governance header + data-field schema validation | Yes |
| 2 | `knowledge/analytical-formulas.md` | Hiring gap, comp-per-head, budget burn, pacing | Yes |
| 3 | `knowledge/executive-report-template.md` | Canonical 4-section report skeleton (template v2.0) | Yes |
| 4 | `knowledge/anomaly-detection-rules.md` | Section 4 anomaly checks | Yes |
| 5 | `knowledge/compliance-pii-guardrails.md` | Small-department suppression + governance metadata | Yes |

## Upload Procedure

1. Open the GPT Builder → Configure tab → Knowledge section.
2. Upload all five files from the `knowledge/` subdirectory.
3. Verify each appears with a green checkmark.
4. Save the GPT.

## Validation Tests

Run these tests in the GPT Builder preview pane after upload:

1. **Template adherence test** — Upload a sample dataset and ask "Generate the monthly report." Expected: the four canonical sections (Executive Summary → Department Snapshot → Hiring & Attrition → Budget & Anomalies) appear in order with the correct table structures.
2. **Delta format test** — Upload current and prior files. Expected: deltas formatted as `+N (+P%)`, rates as `+0.6pp`, never bare numbers.
3. **Missing-prior behavior** — Upload only the current file. Expected: the GPT asks for the prior file or explicitly labels output as "Snapshot only."
4. **Critical-swing halt** — Upload two files with a 30%+ total headcount swing. Expected: the GPT halts and requests human verification.
5. **Schema-validation halt** — Upload a file missing the `Budget Allocation per Department` column. Expected: the GPT halts and reports the missing column rather than guessing.
6. **Governance flag test** — Upload a file with `Date Approved` blank. Expected: the report is prepended with `⚠️ DRAFT — file not approved.`
7. **Small-department suppression** — Include a department with `Current Headcount = 3`. Expected: `Total Comp` and `Burn` columns show `*` for that row with the privacy footnote.
8. **Column-alias test** — Upload a file whose headers say `FTE`, `Plan`, and `Dept` instead of canonical names, with an inline alias map. Expected: the GPT applies the aliases, runs schema validation, and lists the applied aliases in the "Files used" footer.
9. **ORG-Chart roll-up test** — Upload a flat department file plus a sidecar ORG-Chart. Expected: parent-level roll-ups appear beneath the leaf-level Department Snapshot table.
10. **Column-reference recomputation test** — Upload a file with a derived column plus a Column Reference declaring its formula. Expected: the GPT recomputes and flags rows where the supplied value diverges by >1%.
11. **No-file precondition test** — Ask for "this month's report" with no file attached. Expected: the GPT halts and asks for a `.xlsx`/`.csv` file rather than producing a templated report on imagined data.
12. **Pasted-numbers refusal test** — Paste a small headcount table directly into the chat. Expected: refusal to report on pasted text; request for an attached file.
13. **Non-canonical-headers halt test** — Upload a file whose headers do not match any canonical name **without** an Alias map. Expected: the GPT halts, names the missing canonical fields, and requests a Column Alias map rather than guessing.

## Refresh Cadence

| File | Trigger |
|------|---------|
| `headcount-schema-dictionary.md` | Quarterly or HRIS schema change. |
| `analytical-formulas.md` | When methodology changes. |
| `executive-report-template.md` | Quarterly review with executive consumers. **Treat changes as versioned (v1 → v2) to preserve cross-period comparability.** |
| `anomaly-detection-rules.md` | First 6 months: monthly. Then quarterly. |
| `compliance-pii-guardrails.md` | Annually or regulatory change. |
