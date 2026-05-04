# Knowledge File Manifest — PDF to Post Communication

Three reference files are uploaded with this GPT. They are **reference data**, not behavior — all decision logic lives in `system-instructions.md`. Each file is text-forward (Markdown), structured with clear H2/H3 headings for retrieval.

## File Manifest

| # | File Name | Format | Purpose | Size Est. |
|---|-----------|--------|---------|-----------|
| 1 | `channel-style-guide.md` | Markdown | Tone, structure, and length norms for Slack, LinkedIn, Email | ~6 KB |
| 2 | `insight-extraction-rubric.md` | Markdown | Rubric for classifying findings vs. benefits vs. gaps vs. next-research-areas | ~5 KB |
| 3 | `next-research-prompts.md` | Markdown | Scaffolds for turning document gaps into falsifiable next-research questions | ~4 KB |
| 4 | `assessment-rubric.md` | Markdown | 1–5 scoring criteria for source quality and per-check criteria for output self-assessment | ~5 KB |

All four live in `./knowledge/` next to this manifest and are uploaded as-is. Total upload footprint: ~20 KB (well under the 20-file / 512 MB-per-file caps).

## File Details

### 1. `channel-style-guide.md`

- **Purpose:** Source of truth for per-channel tone, structure, and length norms. The system instructions reference this file when channel rules conflict with general writing advice.
- **Content:**
  - **Slack section** — TL;DR-first pattern, bolding conventions, emoji-as-signal rules, action-line format, length cap.
  - **LinkedIn section** — hook taxonomy (question / contrarian / surprising-stat), white-space rules, hashtag norms, prohibited filler phrases, length range.
  - **Email section** — subject-line conventions, summary structure, benefit/next-research bullet format, sign-off placeholder, length range.
  - **Cross-channel rules** — what to keep vs. cut when adapting the same insight to all three channels.
- **Source:** Synthesized from the research document at `research/pdf-to-post/research.md` (sections on Slack/LinkedIn/Email specialization), enriched with conventional channel-writing norms.
- **Prep Instructions:** Already prepared. Re-prep if channel platforms change their interface (e.g., Slack message-length caps change, LinkedIn algorithm shifts hashtag visibility).
- **Update Frequency:** Quarterly, or when a channel's norms shift materially.

### 2. `insight-extraction-rubric.md`

- **Purpose:** Keeps classification consistent across documents. Without this rubric, the GPT would conflate "stated benefit" with "key finding" or treat "open question raised by the author" as a "gap." The rubric defines each category with positive examples, negative examples, and a decision rule.
- **Content:**
  - **Central thesis** — definition + how to disambiguate from a topic statement.
  - **Key findings** — what counts as a finding vs. a methodological note vs. a benefit.
  - **Stated benefits** — strict criterion: must be explicitly claimed by the source.
  - **Gaps & limitations** — distinction between author-acknowledged limitations and reader-identified gaps.
  - **Next research areas** — must derive from a gap, must be specific, must be answerable.
  - **Edge cases** — how to handle thin sources, contradictory sources, and meta-analyses.
- **Source:** Synthesized from the research document's "Analytical Reasoning & Extraction" and "Self-Correction" sections.
- **Prep Instructions:** Already prepared. Review if the GPT begins drifting on classification (e.g., if user feedback indicates "benefits" and "findings" are blurring).
- **Update Frequency:** As-needed based on output quality reviews.

### 3. `next-research-prompts.md`

- **Purpose:** Provides reusable scaffolds for turning vague gaps into specific, falsifiable, well-scoped next-research questions. This is the GPT's principal value-add for "next research areas" and is the area most prone to weak output without explicit scaffolding.
- **Content:**
  - **Scaffold 1: Scope expansion** — "The source addresses X in context A; what changes in context B?"
  - **Scaffold 2: Mechanism probe** — "The source observes X correlates with Y; what mechanism explains it?"
  - **Scaffold 3: Population variance** — "The source studies population P; does the finding replicate in P′?"
  - **Scaffold 4: Time-horizon test** — "The source measures effect at t = N; does it persist at t = N × k?"
  - **Scaffold 5: Counterfactual test** — "If the source's recommended action were not taken, what evidence would predict outcome Z?"
  - Each scaffold includes 1–2 worked examples drawn from generic research domains (product, market, policy).
- **Source:** Synthesized from the research document's "Critical Evaluation" section, plus standard research-question framing patterns.
- **Prep Instructions:** Already prepared. Add scaffolds if recurring gap types emerge that the existing five do not cover.
- **Update Frequency:** As-needed based on output quality reviews.

### 4. `assessment-rubric.md`

- **Purpose:** Defines the 1–5 scoring criteria for source quality (Evidence Strength, Clarity, Novelty, Generalizability) and per-check criteria for the GPT's output self-assessment (Source Fidelity, Claim Coverage, Channel Format Fit). Without this rubric, scoring drifts run-to-run and Trust/Confidence bands lose meaning.
- **Content:**
  - **Part 1 — Source Quality:** four 1–5 rating tables, plus the Trust Band combination rule with disqualifying conditions.
  - **Part 2 — Output Self-Assessment:** four checks with criteria, plus the Confidence Band combination rule.
  - **Calibration examples:** three worked cases (high-quality empirical paper, vendor whitepaper, thin blog-style PDF) to anchor the rubric to concrete document types.
  - **Honesty norm:** explicit guidance against inflating or deflating scores.
- **Source:** Designed for this GPT — synthesized from standard research-evaluation rubrics and self-assessment patterns common in editorial QA.
- **Prep Instructions:** Already prepared. Refine if the GPT's scoring drifts (e.g., consistently over-rating vendor whitepapers) or if new document types not covered by the calibration examples become common.
- **Update Frequency:** As-needed based on output quality reviews.

## Preparation Status

All four knowledge files are pre-prepared and live in `./knowledge/` ready for upload to the GPT Builder. No further cleaning or extraction is required before upload.

## Upload Order

Order doesn't matter for retrieval, but for human review and audit clarity, upload in this order:

1. `channel-style-guide.md`
2. `insight-extraction-rubric.md`
3. `next-research-prompts.md`
4. `assessment-rubric.md`
