# Headcount Executive Analyst — GPT Configuration Spec

## Identity

**Name:** Headcount Executive Analyst

**Description:** Row-per-employee query assistant. Extracts the filter implied by a natural-language question, applies it with pandas, and returns an auditable `Filters applied` table + a 10-row spot-check + any aggregations. The deliverable is the filter and the computation, not a templated report.

**Profile Image Concept:** A minimalist navy-and-white shield with a magnifying-glass overlay focused on a single highlighted row of a spreadsheet grid; corporate audit-firm aesthetic. Convey precision and trust.

## Canonical Schema

The GPT expects a single row-per-employee worksheet (XLSX or CSV). It is schema-agnostic — there is no built-in column list. The Parse-First Metadata Scan discovers literal headers; user-question clauses resolve to those headers via `knowledge/Column.md` (canonical names + aliases + regex search-patterns) at runtime. Manager-hierarchy filters resolve through `knowledge/ORG-chart.md` (inherited levels). Both are user-overridable via sidecar upload.

## Required Inputs

The GPT enforces a hard intake gate. It will refuse to operate on numbers that are not anchored to an attached file.

| Input | Status | Notes |
|---|---|---|
| Data file (`.xlsx` or `.csv`) | **Always required** | One row per employee. The GPT halts with a request message if no file is attached. |
| ORG-Chart | **In knowledge by default; user-overridable** | Defaults to `knowledge/ORG-chart.md` (manager-level inheritance). User may upload a sidecar; declare in run footer. |
| Columns metadata | **In knowledge by default; user-overridable** | Defaults to `knowledge/Column.md` (canonical names + aliases + regex search-patterns). User may upload an inline alias map; declare in run footer. |

See `knowledge/headcount-schema-dictionary.md` § *Optional User-Supplied Inputs* for the format spec and validation rules.

## System Instructions

See `system-instructions.md` (copy-paste directly into the GPT Builder Instructions field).

Character count target: under 8000.

## Response Modes

The GPT operates in two modes; intent comes from the user's prompt.

| Mode | Trigger | Output shape |
|---|---|---|
| **Filter Mode** (default) | Any natural-language question. | `**Filters applied:**` table (`Column used \| Logic applied \| Reasoning (from question)`), `**Logic:**` block, `**Spot-check (first 10 of N):**` table, optional `**Aggregations:**` block, run footer. Date columns are first-class clauses. |
| **Codegen Export Mode** | Explicit code request: "as Python", "as M", "as DuckDB SQL", "VBA", "Office Script", "as R". | Copy-paste-ready code per `knowledge/code-generation-templates.md` that **applies the same Filter table** to the user's literal sheet/columns. No placeholders. Defaults to Pandas if unspecified. |

Behind both modes sits a **Parse-First Metadata Scan** (`openpyxl read_only=True`) that captures the workbook's sheets, headers, dtypes, and a 3-row sample before any full ingest. See `knowledge/headcount-schema-dictionary.md` § *Parse-First Metadata Scan*.

## Conversation Starters

1. "Show me everyone in EMEA hired since 2024-01-01."
2. "List all managers at level ≥ M3 with span > 7 reports."
3. "Group all UK employees by location — show counts."
4. "Headcount by region for hire_date in Q1 2026."
5. "Top 10 by tenure at the London office."
6. "Export the EMEA-tenure-over-5y filter as Pandas."
7. "Give me the DuckDB SQL for hire_date BETWEEN '2025-01-01' AND '2025-12-31' grouped by country."

## Knowledge Files

### File Manifest

| # | File Name | Format | Purpose | Size Est. |
|---|-----------|--------|---------|-----------|
| 1 | Column.md | MD | Canonical column names, aliases, regex search-patterns (loaded at runtime) | ~3 KB |
| 2 | ORG-chart.md | MD | Manager hierarchy with inherited levels M0…Mn (loaded at runtime) | ~2 KB |
| 3 | headcount-schema-dictionary.md | MD | Parse-First Metadata Scan procedure, row-level validation rules | ~5 KB |
| 4 | analytical-formulas.md | MD | Filter / project / aggregate / hierarchy-join / date-range patterns F1–F8 | ~4 KB |
| 5 | anomaly-detection-rules.md | MD | Row-level data-quality checks (missing IDs, dangling manager_id, …) | ~3 KB |
| 6 | compliance-pii-guardrails.md | MD | Demographic-attribute guardrail; small-cohort suppression for aggregations | ~2 KB |
| 7 | code-generation-templates.md | MD | Codegen Export templates parameterized by the Filter table | ~7 KB |

### File Details

#### 1. Column.md
- **Purpose:** Header-to-meaning resolver. Maps the user's literal headers to canonical columns via aliases and regex search-patterns. **Loaded at runtime, never embedded in instructions.**
- **Update Frequency:** When the user adds canonical columns or new aliases.

#### 2. ORG-chart.md
- **Purpose:** Default manager hierarchy with inherited levels. Used for hierarchy-aware filters ("under VP X", "managers at level ≥ M3"). **Loaded at runtime.**
- **Update Frequency:** When the org's manager-level convention changes.

#### 3. headcount-schema-dictionary.md
- **Purpose:** Parse-First scan procedure (low-memory openpyxl pass) and row-level validation rules.
- **Update Frequency:** When the scan procedure changes.

#### 4. analytical-formulas.md
- **Purpose:** Pattern library F1–F8 (filter / project / aggregate / hierarchy-join / date-range bucketing) — cited in every Logic block.
- **Update Frequency:** When a new pattern is added.

#### 5. anomaly-detection-rules.md
- **Purpose:** Row-level data-quality checks — dangling `manager_id`, missing identifiers, malformed dates, dup `employee_id`.
- **Update Frequency:** When new data-quality issues surface.

#### 6. compliance-pii-guardrails.md
- **Purpose:** Demographic-attribute filter guardrail; small-cohort suppression for aggregations (n<5).
- **Update Frequency:** Annually or upon regulatory change.

#### 7. code-generation-templates.md
- **Purpose:** Codegen Export templates parameterized by the Filter table.
- **Update Frequency:** When upstream API or library changes occur.

## Recommended Model

**Model:** GPT-4o
**Rationale:** Reliable Code Interpreter for pandas filtering and strict instruction-following for the Filter table format. No deep reasoning required.

## Capabilities

| Capability | Enabled | Rationale |
|------------|---------|-----------|
| Web Search | No | Internal HR data only. |
| Image Generation | No | Charts (when needed) come from Code Interpreter. |
| Canvas | No | Output is short-form; Canvas adds friction. |
| Code Interpreter | Yes | Required — every filter is computed via pandas. |
| Apps | No | Closed-loop. |

## Actions

**None.** External API calls would conflict with the auditable, defensible-numbers mandate.

## Notes for the Builder

- Test filter extraction: ask "show me everyone in EMEA hired since 2024-01-01" with a sample employee dataset. Verify the `Filters applied` table maps each clause to a literal header.
- Test date filter: ask "headcount by region for hire_date in Q1 2026" — verify the date range expands to `>= '2026-01-01' AND < '2026-04-01'`.
- Test ambiguity halt: upload a file whose headers don't resolve via `Column.md` and ask a question — verify the GPT halts and asks for an alias map.
- Test ORG-chart override: upload a sidecar ORG-chart and a hierarchy-aware question — verify the run footer declares the override.
- Test demographic guardrail: ask to filter by a protected attribute — verify the GPT surfaces the guardrail warning before proceeding.
- Test code export: ask "export the same filter as Pandas" — verify the emitted code uses literal sheet/column names and the Filter table is re-emitted as a comment header.
