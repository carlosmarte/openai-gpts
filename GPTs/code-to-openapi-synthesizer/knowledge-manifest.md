# Knowledge File Manifest — Code to OpenAPI Synthesizer

All files are text-forward Markdown for maximum retrieval fidelity. Total expected size is well under the 512 MB / 20-file Custom GPT ceiling. Files live under `./knowledge/` and are uploaded directly to the Custom GPT's Knowledge slot.

## File Manifest

| # | File Name                          | Format | Purpose                                                          | Size Est. |
| - | ---------------------------------- | ------ | ---------------------------------------------------------------- | --------- |
| 1 | extraction-methodology.md          | MD     | Tracing order, Code Interpreter usage, prompt-caching discipline | ~6 KB     |
| 2 | openapi-3-1-reference.md           | MD     | OpenAPI 3.1 schema reference + idioms + deltas from 3.0          | ~10 KB    |
| 3 | framework-routing-conventions.md   | MD     | Per-framework routing/decorator/error patterns                   | ~9 KB     |
| 4 | brd-template.md                    | MD     | BRD section skeleton with traceability matrix template           | ~5 KB     |
| 5 | self-reflection-rubric.md          | MD     | Internal pre-output evaluation rubric                            | ~3 KB     |
| 6 | assessment-rubric.md               | MD     | Source Trust × Output Confidence band rubric                     | ~4 KB     |

## File Details

### 1. `extraction-methodology.md`

- **Purpose:** Defines the canonical tracing order (route → controller → service → data model → response) and the rationale for using Code Interpreter (AST traversal) over vector retrieval. Includes the prompt-caching discipline of placing static repo context first and dynamic queries last.
- **Content:** Tracing protocol, Code Interpreter parsing recipes (`ast`, `re`, `pyyaml`), MCP forward-looking note for users who graduate to API-based pipelines, edge case handling guidance.
- **Source:** Distilled from `research/sourcecode-to-api-spec/research.md` sections 4–7 (Ingestion Frameworks, Architectural Logic Extraction, Synthesizing the BRD).
- **Prep Instructions:** No further prep needed — file is purpose-written for the GPT. Re-read research source if the methodology evolves.
- **Update Frequency:** Refresh whenever the underlying research note is revised or new framework conventions emerge.

### 2. `openapi-3-1-reference.md`

- **Purpose:** Compact OpenAPI 3.1 schema reference so the GPT can emit valid YAML without web lookups. Covers required top-level fields, paths/operations structure, components, security schemes, and the key 3.1-vs-3.0 deltas (JSON Schema 2020-12, `nullable` removal, `webhooks`, multiple examples).
- **Content:** Field-by-field tables, idiomatic snippets, common pitfalls.
- **Source:** OpenAPI 3.1.0 specification (public). Curated for high-recall lookup, not exhaustive duplication.
- **Prep Instructions:** No prep beyond review when the OpenAPI spec version bumps.
- **Update Frequency:** On each OpenAPI minor-version release.

### 3. `framework-routing-conventions.md`

- **Purpose:** Pattern dictionary the GPT consults when fingerprinting a repo's framework. Covers Express, Fastify, Spring Boot, FastAPI, Flask, Django, Rails, ASP.NET Core. Each entry: routing idiom, parameter binding, response shape, error-handling convention.
- **Content:** One H2 section per framework with code snippets + `path:line`-style examples of where to look.
- **Source:** Curated from each framework's official docs and the research source's tracing guidance.
- **Prep Instructions:** None — purpose-written.
- **Update Frequency:** When adding support for a new framework, or on a major framework release that changes idioms (e.g., FastAPI lifespan/router refactors).

### 4. `brd-template.md`

- **Purpose:** Provides the BRD section skeleton the GPT must follow. Includes the traceability matrix template and example rule-formulation language ("As a … I want … so that …").
- **Content:** Full template with placeholder text, plus a worked mini-example showing a single rule traced from source line to user story.
- **Source:** Composite of standard BRD practice (BABOK) tailored for API documentation.
- **Prep Instructions:** None.
- **Update Frequency:** Stable; only revised if the org adopts a different BRD standard.

### 5. `self-reflection-rubric.md`

- **Purpose:** Internal pre-output rubric. The GPT applies this silently before returning, iterating until each category passes. Categories: Clarity, Completeness, Accuracy, Schema Validity, Traceability Density, Edge Case Coverage.
- **Content:** Per-category checks with concrete pass/fail signals.
- **Source:** Adapted from the "self-reflection rubric" pattern described in the research source (Synthesizing the BRD section).
- **Prep Instructions:** None.
- **Update Frequency:** Refine if specific failure modes emerge in production use.

### 6. `assessment-rubric.md`

- **Purpose:** Defines the closing two-axis assessment block (Source Trust × Output Confidence) the GPT emits as Part 3. Each axis has High/Medium/Low bands with explicit pass/fail signals.
- **Content:** Source Trust dimensions (code completeness, framework recognized, tests/fixtures present, build configs visible, doc comments). Output Confidence dimensions (schema validity, traceability density, assumption count, edge case coverage). Top-3-risks template.
- **Source:** Source-and-Output Assessment pattern from the `add-gpt-source-output-assessment` skill canon.
- **Prep Instructions:** None.
- **Update Frequency:** Stable; refine if calibration drifts in real use.

## Upload Order

When loading into the Custom GPT Knowledge slot, upload in numeric order so the GPT's first reference (the methodology) anchors the others.

## Notes on What Is NOT in Knowledge

The following intentionally live in **system-instructions.md**, not Knowledge:

- Behavioral rules (bias-to-action, parallel reads, no chain-of-thought)
- Output structure (Part 1 / 2 / 3)
- Workflow steps (1–7)
- Boundaries (no Swagger 2.0, no invention)

This split follows the OpenAI guideline: behavior in Instructions, reference data in Knowledge.
