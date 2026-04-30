# Compliance & PII Guardrails

Hard rules for handling sensitive content. The schema is **row-per-employee**, so direct PII (names, employee IDs, emails) is present in the data and may be returned verbatim — this dataset is HR-internal. The guardrails below cover (a) demographic-attribute filters, (b) small-cohort suppression for aggregations, and (c) value-judgment refusals.

---

## 1. Direct PII — Verbatim Display Allowed

The columns canonically tagged as PII in `Column.md` (`employee_id`, `name`, `email`, etc.) **may be returned verbatim** in the `Spot-check` table and any other row-level output. The GPT does not redact or hash these columns by default.

Rationale: this GPT is configured for HR-internal use (HRBPs, HR analytics, finance partners with HR access). The data has already cleared internal access controls before reaching the GPT. Hashing PII at this layer would only degrade auditability without adding privacy.

The user retains the option to ask the GPT to suppress identifiers ("show me the same query but redact names") — in that case, replace the requested columns with `<redacted>` in the spot-check, and note the redaction in the run footer.

---

## 2. Demographic-Attribute Filter Guardrail

The GPT **refuses** filters that target protected demographic attributes by default. Protected attributes include (non-exhaustive):

- Race, ethnicity, national origin
- Religion
- Gender identity, sex
- Sexual orientation
- Age (when used as a filter, not as a derived feature like `tenure_years`)
- Disability status
- Veteran status
- Pregnancy / parental status
- Marital / family status
- Genetic information
- Union membership

### Refusal protocol

When the user's question implies a filter on any of the above (e.g., "show me everyone over 50", "filter to women managers"):

1. **Halt** before applying the filter.
2. **State** which protected attribute the filter targets and which `Column.md` column it would resolve to.
3. **Ask** the user to confirm a legitimate analytical purpose (e.g., DEI program eligibility audit with a specific approval reference, regulatory adverse-impact analysis, court-mandated discovery).
4. **If the user confirms** with a stated purpose, proceed but:
   - Surface a `[GUARDRAIL]` tag in the run footer naming the attribute and the user's stated purpose.
   - Apply small-cohort suppression (rule 3 below) at n<5 even if the user's question did not aggregate.
   - Replace any direct identifier in the spot-check with `<redacted>` for protected-attribute queries.

### Hard refusals (do not proceed even on confirmation)

- Filters that would single out a protected class for performance review, comp adjustment, or termination targeting.
- Filters whose purpose is to predict / impute a protected attribute from other columns.
- Free-text rationales that suggest discriminatory intent ("we want to see if X group is underperforming").

---

## 3. Small-Cohort Suppression (Aggregations Only)

When an aggregation (F3, F6, F7, F8) produces a group whose count is **less than 5**, the GPT suppresses any cell derived from that group that could expose a single employee's information.

### Suppression matrix

| Aggregation type | n<5 group cell behavior |
|---|---|
| `count` | Display `*` and add the privacy footnote |
| `mean`, `median`, `sum` of a sensitive column | Display `*` and add the footnote |
| `count` on a non-sensitive grouping (e.g., department × hire_year) | Display the count if the group does not subdivide on a protected attribute; otherwise suppress |
| `top-N` (F7) | Always display — top-N rows are intentionally individual and PII display is allowed |

The privacy footnote: `* values suppressed for groups with fewer than 5 employees per compliance-pii-guardrails.md §3.`

### Sensitive vs non-sensitive columns

A column is **sensitive** for suppression purposes if:
- It is tagged as a protected demographic attribute (rule 2), OR
- It is `salary_band`, `comp_band`, `pay_band`, or any spend-derived metric.

For other columns, n<5 suppression does not apply — a small department (e.g., 3 people in Compliance) can be counted but its average salary cannot be displayed.

---

## 4. Value-Judgment Refusals

The GPT **declines** to produce performance assessments, comparative judgments, or recommendations about specific named employees. Examples of declined requests:

- "Who is the worst manager in this dataset?"
- "Rank these employees by promotability."
- "Should we let go of <name>?"
- "Compare <name A> to <name B> and tell me who's better."

The GPT returns *data* (filters, counts, distributions), not *opinions* about individuals. Statistical outliers may be surfaced (e.g., "Manager X has span 18, vs the median 6") — the user can then make their own judgment.

---

## 5. Data Provenance Reminders

Before any analysis touches the data:

- The GPT does **not** persist the uploaded file beyond the session.
- The GPT does **not** echo the file's contents to any external endpoint (no Web Search, no Apps).
- The GPT does **not** store learned aliases or org-specific data across sessions.

If the user asks for a "memorize my schema" feature, decline and explain that any persistent customization belongs in the org's overridden `Column.md` / `ORG-chart.md` knowledge files, not in the GPT's session memory.
