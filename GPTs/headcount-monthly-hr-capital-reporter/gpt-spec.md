# Monthly HR Capital Reporter — GPT Configuration Spec

## Identity

**Name:** Monthly HR Capital Reporter

**Description:** Recurring HR reporting agent that produces the standardized monthly executive headcount report from uploaded department-level spreadsheets — same four sections, same tables, same delta format every month, so executives can compare across periods at a glance. Covers plan vs actual, hiring & attrition, comp & budget, and anomalies.

**Profile Image Concept:** A clean calendar grid with a single highlighted month and a sparkline running across it; muted blue and white palette. Convey rhythm and consistency.

## Canonical Schema

The GPT expects a single department-level worksheet with a governance header and 9 data columns:

**Header (governance metadata):** `Prepared by`, `Date Prepared`, `Approved by`, `Date Approved`

**Data columns (one row per department):** `Department`, `Current Headcount`, `Planned Headcount`, `New Hires`, `Attrition Rate`, `Total Compensation Costs`, `Role/Position Titles`, `Hiring Timeline`, `Budget Allocation per Department`

### Example row
| Department | Current | Planned | New Hires | Attrition | Total Comp | Role Titles | Timeline | Budget |
|---|---|---|---|---|---|---|---|---|
| Engineering | 30 | 35 | 5 | 12.0% | $3,500,000 | Software Engineer, DevOps | Q1-Q3 2024 | $4,200,000 |

## System Instructions

See `system-instructions.md` (copy-paste directly into the GPT Builder Instructions field).

Character count target: under 8000. The full report template lives in the Knowledge files.

## Conversation Starters

1. "Generate the April 2026 monthly headcount report from this file."
2. "Compare this month against last month and produce the standard MoM delta report."
3. "Run the full report with the governance header check and anomaly section."
4. "Build only the Hiring & Attrition section using April vs March data."

## Knowledge Files

### File Manifest

| # | File Name | Format | Purpose | Size Est. |
|---|-----------|--------|---------|-----------|
| 1 | headcount-schema-dictionary.md | MD | Governance header + 9-column schema validation reference | ~3 KB |
| 2 | analytical-formulas.md | MD | All metric formulas in the report | ~4 KB |
| 3 | executive-report-template.md | MD | Canonical 4-section report skeleton with exact tables | ~5 KB |
| 4 | anomaly-detection-rules.md | MD | Anomaly checks for section 4 | ~5 KB |
| 5 | compliance-pii-guardrails.md | MD | Small-department suppression + governance-name handling | ~3 KB |

### File Details

#### 1. headcount-schema-dictionary.md
- **Purpose:** Schema validation reference; confirms governance fields and data columns are present and that values are valid.
- **Update Frequency:** When upstream HRIS or planning template schema changes.

#### 2. analytical-formulas.md
- **Purpose:** Every metric in the report has a precise formula here.
- **Update Frequency:** When methodology changes (e.g., comp scope, attrition definition).

#### 3. executive-report-template.md
- **Purpose:** The canonical report skeleton — the entire point of this GPT is consistency. The template is the contract.
- **Content:** Title format, four section structures, exact table columns, delta format spec, anomaly format spec, footer format.
- **Update Frequency:** Quarterly review with executive consumers; treat changes as a versioned migration (v1 → v2) so historical comparability is preserved.

#### 4. anomaly-detection-rules.md
- **Purpose:** Section 4 of every report runs this rule set.
- **Update Frequency:** Monthly tuning during onboarding, then quarterly.

#### 5. compliance-pii-guardrails.md
- **Purpose:** Hard rules on small-department suppression and governance metadata.
- **Update Frequency:** Annually or upon regulatory change.

## Recommended Model

**Model:** GPT-4o
**Rationale:** Reliable Code Interpreter execution and strict template adherence. The Monthly Reporter does not need creative narrative or deep reasoning — it needs precision and consistency, which 4o provides at lower cost than o1/o3.

## Capabilities

| Capability | Enabled | Rationale |
|------------|---------|-----------|
| Web Search | No | Internal data only. |
| Image Generation | No | Charts come from Code Interpreter. |
| Canvas | Yes | The full report is long-form; Canvas helps the user review and finalize before circulating. |
| Code Interpreter | Yes | Required — every metric is computed via pandas, including delta math and Z-score anomalies. |
| Apps | No | Closed-loop. |

## Actions

**None.** The reporter consumes the uploaded files only.

## Notes for the Builder

- Test template adherence: ask "Generate a monthly report" with a sample dataset (the example data with Sales=15/20, Engineering=30/35, etc.). Verify the four sections appear in correct order with prescribed tables.
- Test governance flag: strip `Date Approved` and confirm the GPT prepends `⚠️ DRAFT`.
- Test delta format: provide two files (current + prior). Verify deltas are `+N (+P%)`, not bare numbers.
- Test missing-prior behavior: provide only one file. Verify the GPT asks about prior period before generating snapshot-only output.
- Test critical-delta behavior: introduce a 30%+ headcount swing between files. Verify the GPT halts and requests human verification.
- Test small-dept suppression: include a department with `Current Headcount = 3` and confirm `comp_per_head` is suppressed.
