# Self-Reflection Rubric

Apply this rubric **internally** before returning output. Iterate until every category passes. Do not narrate the iteration — the user sees only the final artifacts.

## Rubric Categories

### 1. Clarity

- [ ] Every sentence has one subject and one claim. No nested compound clauses.
- [ ] Active voice throughout (rules and descriptions).
- [ ] Domain terms either obvious-from-context or defined in the Glossary.
- [ ] No filler ("various", "several", "a number of", "etc.") — replaced with counts or specifics.

**Fail signal:** any sentence requires a re-read to parse.

### 2. Completeness

- [ ] Every routing declaration in the source produced an OpenAPI path entry — or appears under "Top 3 risks" with rationale.
- [ ] Every endpoint has: method, path, summary, parameters, request body (when applicable), at least one success response, at least one explicit error response.
- [ ] Every business rule covers an actual code path, not a generic "the system should…" platitude.
- [ ] Every NFR row has either evidence or an `[ASSUMPTION]` tag.

**Fail signal:** an endpoint is mentioned in the trace but missing from the YAML, or vice versa.

### 3. Accuracy (Source Grounding)

- [ ] Every business rule, every NFR row, every edge case has a `path:line` reference OR an `[ASSUMPTION]` tag — never neither.
- [ ] No invented endpoints, fields, or status codes.
- [ ] Trace chains are linear and citable: `A.ts:N → B.ts:N → C.ts:N`. No "and various other files."
- [ ] Field types in the OpenAPI schema match the source's declared types (e.g., `number` for `BigDecimal`, `string` for `UUID` with `format: uuid`).

**Fail signal:** any claim cannot be traced to source or marked as assumption.

### 4. Schema Validity

- [ ] `openapi: 3.1.0` exactly.
- [ ] `info.title` and `info.version` present.
- [ ] Every `$ref` resolves to a defined component.
- [ ] Every URL path parameter (`{id}`) is declared in `parameters` with `required: true` and `in: path`.
- [ ] Every operation has at least one response.
- [ ] Every `requestBody` and response `content` declares at least one media type.
- [ ] No `nullable: true` (3.0 idiom). Use `type: [..., "null"]`.
- [ ] `operationId` values are unique across the document.
- [ ] No trailing commas, no unquoted special chars in YAML strings.

**Fail signal:** the YAML would fail a `swagger-cli validate` style pass.

### 5. Traceability Density

- [ ] At least one source reference per business rule.
- [ ] At least one source reference per NFR row.
- [ ] At least one source reference per edge case row.
- [ ] The Traceability Matrix lists every business rule and links it to an `operationId`.

**Fail signal:** ratio of cited claims to total claims falls below ~95%.

### 6. Edge Case Coverage

- [ ] Every endpoint documents: missing auth, invalid input, not-found, conflict (when stateful), upstream failure.
- [ ] Silent error-swallowing (broad `try/catch` returning 200) is flagged.
- [ ] Authorization scopes/roles are explicit per endpoint.
- [ ] State transitions (when present) are documented as a list or small diagram.

**Fail signal:** any endpoint shows only a 200 response with no error branches.

### 7. Output Format Conformance

- [ ] Three H2 parts present: OpenAPI spec, BRD, Source & Output Assessment.
- [ ] Part 1 contains a single `yaml` code-fenced block, no prose inside.
- [ ] Part 2 follows the section order in `brd-template.md`.
- [ ] Part 3 contains exactly: Source Trust band, Output Confidence band, Top 3 risks.
- [ ] No internal reasoning chain-of-thought leaked into the output.
- [ ] No meta-commentary ("Here is your spec…", "I hope this helps…").

**Fail signal:** structure deviates from the contract.

## Iteration Protocol

1. Generate draft.
2. Run rubric — note failures per category.
3. If any fail, regenerate the failing parts only (not the whole doc).
4. Re-check failed categories. Stop when all pass.
5. Hard stop: if iteration count exceeds 3 cycles on the same category, surface the unresolvable issue under Top 3 risks and ship.

## What This Rubric Does NOT Check

- Aesthetic preferences (header style, table column widths).
- User-specific style guides (those would override via the system prompt or a separate knowledge file).
- Content beyond what's discoverable from the source (do not invent NFRs to look thorough).
