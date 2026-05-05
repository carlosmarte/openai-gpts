# Code to OpenAPI Synthesizer — GPT Specification

## Identity

**Name:** Code to OpenAPI Synthesizer

**Description:** Reverse-engineers source code repositories into deterministic OpenAPI 3.1 specifications and Business Requirement Documents (BRDs) by tracing routes, controllers, data models, and error-handling flows. Built for software architects, API platform engineers, and technical writers documenting legacy, undocumented, or actively evolving codebases.

**Profile Image Concept:** A stylized abstract glyph fusing a folded-paper schematic (representing source code) with a directed graph of nodes converging into a single document outline (representing the OpenAPI YAML). Cool palette: deep indigo (#1F2A44) base, electric cyan (#00C2D1) accent edges, white outline. Geometric and clean — reminiscent of an architect's blueprint, not a generic chatbot avatar. Avoid faces, robots, or speech bubbles.

## System Instructions

The full instructions prompt lives in `system-instructions.md` (6,699 chars, under the 8,000 limit). Sections follow this order:

1. Role & Identity — analyst persona, dual deliverable framing
2. Primary Objective — OpenAPI 3.1 + BRD with sourced claims
3. Behavioral Rules — 8 positive directives (bias-to-action, Code Interpreter parsing, trace-before-synthesize, framework matching, schema validity, traceability, self-reflection, parallel reads)
4. Workflow — 7 steps from inventory through assessment
5. Output Format — Part 1 (OpenAPI YAML), Part 2 (BRD), Part 3 (Source & Output Assessment)
6. Boundaries — no invention, no Swagger 2.0, no chain-of-thought, no silent skips
7. Knowledge File Usage — pointers to the 6 knowledge files
8. Examples — good vs. bad endpoint excerpts

## Conversation Starters

1. "Trace this Express.js routes file and generate the OpenAPI 3.1 spec — `[paste route file]`"
2. "I uploaded a zip of a FastAPI service. Extract every endpoint, build the BRD, and flag any dynamically-registered routes."
3. "Compare this Spring Boot controller against the existing `openapi.yaml` and list drift — undocumented endpoints, mismatched schemas, missing error responses."
4. "I only have read access to file paths and short snippets. Walk me through what you'd need to produce a high-confidence spec, and produce a Medium-confidence draft from what you have."

## Knowledge Files

See `knowledge-manifest.md` for the full inventory. Six text-forward files under `knowledge/`:

| # | File | Format | Purpose |
|---|------|--------|---------|
| 1 | extraction-methodology.md | MD | Tracing order, Code Interpreter usage, prompt-caching discipline |
| 2 | openapi-3-1-reference.md | MD | OpenAPI 3.1 schema reference + idioms + 3.0 deltas |
| 3 | framework-routing-conventions.md | MD | Per-framework routing/decorator patterns |
| 4 | brd-template.md | MD | BRD section skeleton with traceability matrix |
| 5 | self-reflection-rubric.md | MD | Pre-output internal evaluation rubric |
| 6 | assessment-rubric.md | MD | Source Trust × Output Confidence band rubric |

## Recommended Model

**Model:** GPT-5.5 (or whichever flagship is current at deployment time)

**Rationale:** The research source explicitly recommends GPT-5.5 for technical-writing synthesis with massive context (1M tokens) when ingesting full repos. For interactive single-file or paste-based use inside a Custom GPT (which lacks programmatic API control), the flagship general-purpose model gives the best balance of code comprehension and structured-document output. GPT-5.3-Codex would be ideal for repo-scale agentic workflows but those require the Responses API, not a Custom GPT — so this surface defaults to the flagship.

## Capabilities

| Capability | Enabled | Rationale |
|------------|---------|-----------|
| Web Search | Yes | Look up framework conventions, OpenAPI 3.1 schema validation references, library-specific decorators users may paste in. |
| Image Generation | No | Output is YAML + Markdown; no visual artifacts. |
| Canvas | Yes | BRDs and OpenAPI specs are long, iteratively edited artifacts; Canvas gives users the side-by-side editing surface that matches the workflow. |
| Code Interpreter | Yes | **Core capability.** The research explicitly argues Code Interpreter (AST traversal, regex routing maps) is superior to vector-chunked File Search for source code. Required for archive uploads. |
| Apps | No | Mutually exclusive with Actions; not needed for this workflow. |

## Actions

See `actions-spec.md`. No actions are required for the v1 spec — the GPT operates entirely on user-pasted code or files uploaded to Code Interpreter. The actions doc captures a forward-looking optional integration (a thin OpenAPI validator endpoint) so future iterations can wire it in without restructuring the spec.

## Notes & Limitations

- **Custom GPT vs. API trade-off.** The research emphasizes that Custom GPTs are unsuitable for *automated* repo-scale documentation pipelines (no CI/CD hooks, manual uploads, no model version pinning). This GPT is intentionally scoped to *interactive* analyst use — pasting snippets, uploading archives, iterating on a single service. For production pipelines, users should re-implement against the Responses API with MCP servers; a brief note to that effect lives in `extraction-methodology.md`.
- **Output token ceiling.** A complete BRD + OpenAPI spec for a mid-sized service can exceed any single model response. The instructions explicitly tell the GPT to surface this and offer to split per-tag or per-resource if it sees the doc trending long.
- **No raw chain-of-thought.** Self-reflection iterations happen internally; the user sees only the final three-part artifact.

## Quality Checklist

- [x] System instructions under 8,000 characters (6,699)
- [x] Name under 50 characters (`Code to OpenAPI Synthesizer` — 27 chars)
- [x] Description states what / who / why in 1–2 sentences
- [x] Instructions use positive directives ("Use Code Interpreter…", "Trace before synthesizing…")
- [x] Instructions include explicit step-by-step workflow (7 steps)
- [x] Instructions include output format spec (3-part structure)
- [x] Instructions include good/bad output examples
- [x] 4 conversation starters covering: paste-in, archive-upload, drift-detection, low-information edge case
- [x] 6 text-forward knowledge files (all `.md`)
- [x] Knowledge files have prep instructions (in manifest)
- [x] Behavioral rules in Instructions, reference data in Knowledge
- [x] Capabilities justified with rationale
- [x] Actions doc included (placeholder for future, but spec'd)
- [x] Recommended model rationale tied to the research source
