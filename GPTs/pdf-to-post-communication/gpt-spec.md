# PDF to Post Communication — GPT Specification

## Identity

**Name:** PDF to Post Communication

**Description:** Turns research PDFs into ready-to-send Slack messages, LinkedIn posts, and Email briefs — with critical analysis, gap identification, next-research questions, and a closing source-quality + extraction-fidelity scorecard. Built for knowledge workers and PMs who disseminate findings across channels without losing source fidelity.

**Profile Image Concept:** A flat, minimal icon showing a single PDF document with three thin arrows fanning out to three small channel glyphs — a chat bubble (Slack), a professional badge (LinkedIn), and an envelope (Email). Color palette: deep navy + teal accent on a light background. No text, no gradients. Clean enough to read at 32px.

## System Instructions

The full instructions prompt is maintained in [`system-instructions.md`](./system-instructions.md) (copy-paste ready, **7,438 / 8,000 chars**). It covers:

- **Role & Identity** — informational analyst voice for PMs and knowledge workers.
- **Primary Objective** — produce five deliverables per request: Insight Extract + Slack + LinkedIn + Email + Source & Output Assessment.
- **Workflow** — ingest → section → extract → critique → format → self-review → assess.
- **Output Format** — strict H2 layout, per-channel length and structure caps, closing scorecard tables.
- **Behavioral Rules** — source-grounded, neutral, no fabricated specifics, `[unverified]` labels when uncertain.
- **Boundaries** — no legal/medical/financial advice, no invented numbers, scope limited to Slack/LinkedIn/Email.
- **Knowledge File Usage** — pointers into the four uploaded reference files.
- **Examples** — paired good/bad Slack output for tone calibration.

## Conversation Starters

1. "Here's a research PDF — give me a Slack message, LinkedIn post, and Email brief from it."
2. "Pull the key insights from this whitepaper and tell me what gaps it leaves unaddressed."
3. "Take this product report and draft a LinkedIn post that highlights the most surprising finding."
4. "What questions does this research fail to answer? Suggest 5 concrete next research areas."

## Knowledge Files

See [`knowledge-manifest.md`](./knowledge-manifest.md) for full prep details. Summary:

| # | File Name | Format | Purpose | Size Est. |
|---|-----------|--------|---------|-----------|
| 1 | `channel-style-guide.md` | MD | Tone, structure, and length norms for Slack, LinkedIn, Email | ~6 KB |
| 2 | `insight-extraction-rubric.md` | MD | Rubric for classifying findings vs. benefits vs. gaps | ~5 KB |
| 3 | `next-research-prompts.md` | MD | Scaffolds for turning gaps into falsifiable next-research questions | ~4 KB |
| 4 | `assessment-rubric.md` | MD | 1–5 scoring criteria for source quality and output self-assessment | ~5 KB |

All four are kept in `./knowledge/` and uploaded as-is. They are reference data, not behavior — behavior lives in `system-instructions.md`.

## Recommended Model

**Model:** GPT-4o

**Rationale:** The workflow needs reliable PDF parsing via Code Interpreter, multi-step reasoning (extract → critique → reformat × 3 channels), and consistent tone control across long output. GPT-4o balances fidelity and latency for this. o1 / o3 would be overkill — the task is structured synthesis, not deep reasoning. GPT-4o mini risks losing nuance on critical-evaluation and gap-identification steps.

## Capabilities

| Capability | Enabled | Rationale |
|------------|---------|-----------|
| Web Search | Yes | Verifies plausibility of stated claims and enriches "next research areas" with adjacent open questions. Not used to inject new facts into the Insight Extract. |
| Image Generation | No | Output is text-only across all three channels. |
| Canvas | No | Output is short-to-medium-form structured posts; users copy-paste into channel tools. Canvas adds friction without value. |
| Code Interpreter | Yes | Required for robust PDF text extraction, including layout-aware parsing of tables, headings, and multi-column documents. |
| Apps | No | Mutually exclusive with Actions; v1 has no external API integrations. Users push to channels manually. |

## Actions

**Status:** Not enabled in v1. See [`actions-spec.md`](./actions-spec.md) for the v2 design sketch (Slack/LinkedIn/Gmail posting actions) and the rationale for deferring them.

## Quality Checklist

- [x] System instructions under 8000 chars (7,438)
- [x] Name under 50 chars and specific (24 chars)
- [x] Description states what, who, and why in 2 sentences
- [x] Instructions use positive directives, not negations
- [x] Instructions include step-by-step workflow
- [x] Instructions include output-format specs (per-channel)
- [x] Instructions include good/bad output examples
- [x] 4 conversation starters covering different use cases
- [x] Knowledge files are text-forward (Markdown)
- [x] Knowledge files have prep instructions in manifest
- [x] Behavioral rules in Instructions, reference data in Knowledge
- [x] Capabilities justified with rationale per row
- [x] Actions deferred with documented design sketch
- [x] Recommended model matches task complexity
