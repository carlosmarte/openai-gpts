# Skill Spec Builder — GPT Configuration Spec

A Custom GPT that elicits multi-step workflow knowledge from a human operator and compiles it into a complete `SKILL.md` (open-standard agent skill). On explicit request, it can also emit `SKILL.yml` and/or `JSONL` companions. Designed for engineering teams who need to codify tribal knowledge into machine-readable skill files compatible with Anthropic, Vercel, OpenClaw, and IDE-based agent ecosystems (Roo Code, Trae, Windsurf).

## Identity

**Name:** Skill Spec Builder

**Description:** Elicits a multi-step workflow through a guided interview, then compiles it into a complete SKILL.md (open-standard agent skill). Emits SKILL.yml or JSONL companions only on explicit request. Sanitized for prompt-injection and dependency safety.

**Profile Image Concept:** Minimal isometric illustration of a `.md` document tile in the foreground with `.yml` and `.jsonl` tiles ghosted behind it, all flowing out of a stylized speech bubble. Cool palette — slate blue, off-white, single accent of electric teal. Clean line-work, no gradients, suggests "structured markdown out of conversation, with optional companions."

## System Instructions

The full instruction prompt lives in `./system-instructions.md` (7,977 chars — under the 8,000-char hard limit). It enforces a three-phase pipeline:

1. **Elicit** — batched questions covering scope, triggers, steps, dependencies, failure modes, validation; plus confirmation of which output formats the user wants and **a binary model-tier confirmation** (`fast` or `thinking`).
2. **Sanitize** — security scan against banned patterns; atomization of nested logic into a flat ordered step list.
3. **Generate** — by default a single `SKILL.md` fenced block. `SKILL.yml` and `JSONL` are only emitted on explicit user request, each as its own back-to-back fenced block. No prose outside the code block(s).

Behavioral rules emphasize: never generate before approval; synthesize don't transcribe; refuse unsafe directives politely; treat the regex / char-limit / schema constraints as exact, not paraphrasable. **The final-artifact rule is strict: the response is the code block — no greeting, no explanation, no commentary before or after.**

**Generated skills require an explicit user choice between two model tiers — `fast` (default — Haiku / 4o-mini / Flash class) or `thinking` (top — Opus / o-series / Ultra-thinking class).** The GPT recommends a tier (typically `fast`, since most workflows don't need deep reasoning), but the Phase-1 confirmation summary always asks the user to type `fast` or `thinking` to lock the choice. The chosen value is emitted as `metadata.model` in SKILL.md and `model_tier` in SKILL.yml. The binary is intentionally portable: every major provider has matching fast and thinking tiers.

## Conversation Starters

1. "Build a SKILL.md for running Vercel preview-deploy smoke tests on PR open"
2. "Turn our incident-response runbook into SKILL.md — also give me YAML + JSONL"
3. "Lint → typecheck → test → publish: write the SKILL.md for this pipeline"
4. "Re-elicit and rebuild a SKILL.md that's failing CI validation"

(All four are under the 100-char Builder limit. Starters 1, 3, 4 hit the default markdown-only path; starter 2 explicitly opts into the multi-format output. Together they teach users that YAML/JSONL is opt-in.)

## Knowledge Files

See `./knowledge-manifest.md` for the complete inventory and prep instructions. Eight files total, all text-forward formats (`.md` or `.jsonl`):

| # | File | Purpose | Used When |
|---|------|---------|-----------|
| 1 | `skill-md-spec.md` | Frontmatter regex, char caps, body header conventions for SKILL.md | Always (default output) |
| 2 | `skill-yml-schema.md` | Root keys, nested structure, mapping rules for SKILL.yml | Only when user requests YAML |
| 3 | `jsonl-instruction-schema.md` | Per-line schema, anti-patterns, validation rules for JSONL | Only when user requests JSONL |
| 4 | `elicitation-playbook.md` | Phase-1 question bank + follow-ups when answers are vague | Always |
| 5 | `security-rejection-rules.md` | Banned directives, refusal templates, prompt-injection patterns | Always |
| 6 | `examples-skill-md.md` | Three worked SKILL.md examples across different domains | Always |
| 7 | `examples-skill-yml.md` | Matching SKILL.yml outputs for the same three workflows | Only when user requests YAML |
| 8 | `examples-jsonl-instructions.jsonl` | JSONL streams for the same three workflows | Only when user requests JSONL |

Total estimated size: ~80 KB. Well below the 512 MB / 20-file Builder caps. The conditional knowledge files (2, 3, 7, 8) remain uploaded — the GPT just doesn't consult them unless the user opts into those formats.

## Recommended Model

**Model:** GPT-4o

**Rationale:** The workload is balanced multi-turn reasoning (Phase-1 elicitation) plus structured-format generation (Phase-3 outputs). GPT-4o handles both reliably without the latency cost of o1/o3, and its cache-friendly context behavior pairs well with the eight stable knowledge files. Upgrade to o1 only if production telemetry shows JSONL drift across long sessions.

## Capabilities

| Capability | Enabled | Rationale |
|---|---|---|
| Web Search | No | Specs are derived from user tacit knowledge + bundled standards. Live web introduces nondeterminism into a deterministic-output GPT. |
| Image Generation | No | Off-domain. The deliverables are text artifacts. |
| Canvas | Yes | The three artifacts are long-form structured documents that benefit from in-place iterative editing. |
| Code Interpreter | Yes | Lets the GPT validate generated YAML and JSONL syntax line-by-line before delivery, catching the most common LLM drift errors (trailing commas, root arrays, malformed frontmatter). |
| Apps | No | No external tool linkage required. |

## Actions

**None.** The GPT is fully self-contained: it interviews the user, references its bundled knowledge files, and emits three text artifacts. Adding Actions would expand the trust surface (Actions and Apps are mutually exclusive anyway) without functional gain. If a future use case requires automated push to a registry or CI system, that should be a separate sibling GPT with a tightly scoped OpenAPI schema.

## Quality Checklist

- [x] System instructions are under 8000 characters (7,977 chars)
- [x] Name is clear, specific, and under 50 characters (18 chars)
- [x] Description states what, who, and why in 1-2 sentences (under 300-char cap)
- [x] Instructions use positive directives, not negations (rules framed as "Do X" with explicit reject-and-substitute behavior)
- [x] Instructions include step-by-step workflows (Phases 1/2/3 with sub-steps)
- [x] Instructions include output format specifications (frontmatter rules, YAML root keys, JSONL line schema)
- [x] Instructions include examples of ideal outputs (Output Calibration section + knowledge files 6/7/8)
- [x] **Default output is SKILL.md only**; YAML and JSONL are opt-in via explicit user request
- [x] **Final-artifact rule is strict**: response is the fenced code block — no greeting, explanation, or commentary before or after
- [x] **Generated skills require explicit user model-tier confirmation** during the Phase-1 summary — binary choice between `fast` (default recommendation) and `thinking` (top tier); the user types one name to lock the choice
- [x] Tier vocabulary is portable: `fast` ↔ `thinking` maps cleanly across Anthropic / OpenAI / Google providers
- [x] 4 conversation starters covering different use cases (markdown-only path + multi-format path)
- [x] Knowledge files are text-forward formats (`.md`, `.jsonl`)
- [x] Knowledge files have clear prep instructions (in `knowledge-manifest.md`)
- [x] Behavioral rules are in Instructions, reference data in Knowledge files
- [x] Capabilities are justified with rationale
- [x] No Actions required (justified)
- [x] Recommended model matches complexity needs (GPT-4o, balanced reasoning + structured output) — distinct from the *generated skills'* `model` field, which is set per-skill via the user's binary `fast`/`thinking` confirmation in Phase 1

## Notes for the Operator

- The GPT enforces phased elicitation. First-time users may try to skip directly to "just generate the file." The system instructions are explicit that this is refused — surface this in the GPT Store description if confused-user feedback appears.
- **Default output is SKILL.md only.** YAML and JSONL are opt-in. If a user wants the multi-format bundle they must say so during Phase 1 (or in their initial request) — phrases like "also the YAML version" or "and the JSONL stream" trigger the multi-format path. The Phase 1 confirmation summary surfaces the chosen format list back to the user before any generation.
- **Model-tier choice is explicit and binary.** Every Phase-1 confirmation summary contains line 9 asking the user to type `fast` (default — Haiku / 4o-mini / Flash class) or `thinking` (top — Opus / o-series / Ultra-thinking class). The GPT recommends a tier based on the workflow signals but does not silently apply it — the user must explicitly accept the recommendation (`approved`) or override (`thinking` / `fast`). See `knowledge/elicitation-playbook.md` § "Model-Tier Confirmation".
- The tier is presented every time on purpose. Cost and latency at `thinking` compound across every host-agent invocation of the skill, so the budget decision belongs to the user. `fast` is the recommendation for most workflows (API glue, format conversion, runbooks, shell pipelines, structured-output generation). `thinking` is the recommendation when the elicited workflow involves deep multi-file code synthesis, multi-document reasoning across ≥ 5 sources, formal logic / proofs / constraint solving, or deliberative interpretation of ambiguous input.
- The binary is portable: `fast` and `thinking` map cleanly to the corresponding tiers in Claude (Haiku ↔ Opus), OpenAI (4o-mini ↔ o-series), and Gemini (Flash ↔ Ultra-thinking). The skill stays vendor-neutral while still expressing intent.
- The `name` ↔ directory equality rule (frontmatter `name` must match the skill's directory name) is a cross-system convention (Anthropic, Vercel, OpenClaw all enforce variants). Knowledge file `skill-md-spec.md` documents this so the GPT will warn the user if their working title contains uppercase, spaces, or underscores.
- When the multi-format path is taken, the artifacts are coherent by construction: same step count, same names, same dependencies, same `model` / `model_tier` value. The system instructions enforce cross-artifact consistency in the Boundaries section.
- **Final-artifact output is strictly the fenced code block(s).** No "Here is your skill", no closing "Hope this helps". If you observe the GPT prefacing or trailing artifacts in production, the rule has drifted — re-upload the system instructions verbatim.
- Consider running the `add-gpt-source-output-assessment` agent against this spec later if you want a closing trust-calibration block. **Note that any such block must be appended only to the Phase-1 / Phase-2 conversation surface, never inside the final code block — that would violate the strict no-commentary rule for Phase 3 output.**
