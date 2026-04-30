# Knowledge File Manifest — Forward Planning Strategist

## File Manifest

| # | File Name | Format | Purpose | Size Est. |
|---|-----------|--------|---------|-----------|
| 1 | extraction-framework.md | MD | Full 17-category extraction model with definitions and per-category pushback prompts | ~8 KB |
| 2 | plan-template-one-pager.md | MD | Structured one-page plan output template for leadership-ready summaries | ~3 KB |
| 3 | pushback-question-bank.md | MD | Curated challenge questions organized by planning weakness category | ~6 KB |

---

## File Details

### 1. extraction-framework.md

- **Purpose:** Provides the complete extraction taxonomy so the GPT knows exactly what to look for in any planning document. Each category includes a definition, what to extract, why it matters, and example pushback prompts.
- **Content:** 17 extraction categories organized into three groups — Core Planning, Risk and Challenge, and Execution Readiness. Each category has: description, extraction targets, importance rationale, and 2-3 pushback question patterns.
- **Source:** Derived from the research document at `research/plan-overview/v1/research.md`.
- **Prep Instructions:** Already prepared and ready for upload. No additional cleaning needed.
- **Update Frequency:** Update when new extraction categories or analytical patterns are identified through usage.

### 2. plan-template-one-pager.md

- **Purpose:** Gives the GPT a consistent structural template when users request a one-page strategy overview output format.
- **Content:** Markdown template with sections for Problem, Objective, Key Decisions, Hypotheses, Scope (In/Out), Success Criteria, Deliverables, Risks with Mitigations, and Effort Summary. Includes formatting guidance and field descriptions.
- **Source:** Derived from the one-page version section of the research document.
- **Prep Instructions:** Already prepared and ready for upload. No additional cleaning needed.
- **Update Frequency:** Update if output format requirements change based on user feedback.

### 3. pushback-question-bank.md

- **Purpose:** Provides a structured library of challenge questions the GPT can adapt when identifying weak areas in plans. Prevents generic pushback by giving specific, targeted question patterns.
- **Content:** Challenge questions organized by category (assumptions, dependencies, constraints, ownership, timeline, scope, risk, readiness, tradeoffs, failure modes, measurement, stakeholder alignment). Each category has 5-8 questions with context notes on when to use them.
- **Source:** Compiled from pushback prompts across all 17 extraction categories in the research document, expanded with additional patterns.
- **Prep Instructions:** Already prepared and ready for upload. No additional cleaning needed.
- **Update Frequency:** Expand as new pushback patterns prove effective in practice.
