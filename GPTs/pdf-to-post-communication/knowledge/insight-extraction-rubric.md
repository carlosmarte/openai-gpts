# Insight Extraction Rubric

This rubric defines what counts as a **central thesis**, **key finding**, **stated benefit**, **gap & limitation**, and **next research area**. It exists to keep classification consistent across documents.

## Decision Order

When reading a document, classify content in this priority order. Earlier categories preempt later ones.

1. Central thesis (one only)
2. Stated benefits (must be explicitly claimed by source)
3. Key findings (evidence supporting the thesis)
4. Gaps & limitations (what the source does not address)
5. Next research areas (derived from gaps)

If a sentence could fit two categories, prefer the higher-priority one.

---

## Central Thesis

### Definition
The single sentence that best answers the question "If a reader took only one idea from this document, what should it be?"

### Decision rule
- It is a **claim**, not a topic.
- It is **specific enough to be wrong**.
- It typically appears in the abstract, executive summary, or conclusion — not the introduction.

### Positive example
> "Interactive walkthroughs reduce 30-day onboarding time by 30% relative to static docs across the studied teams."

### Negative example (this is a topic, not a thesis)
> "This report explores the relationship between onboarding format and time-to-productivity."

### Edge cases
- **Multiple competing theses.** Pick the one the conclusion section emphasizes. Note the others under "Key findings."
- **No clear thesis.** State "The source does not commit to a single thesis" in the Insight Extract. Do not synthesize one yourself.

---

## Key Findings

### Definition
Specific, evidence-backed observations that support the central thesis or stand on their own as substantive facts.

### Decision rule
- Backed by data, citation, or example in the source.
- Not the same as the thesis (more granular).
- Not the same as a benefit (a finding is descriptive; a benefit is a claimed outcome).

### Positive example
> "Adoption of the interactive walkthrough rose from 41% to 67% over 90 days in the studied cohort."

### Negative example (this is a methodological note, not a finding)
> "Data was collected via post-onboarding surveys at 30, 60, and 90 days."

### Edge cases
- **Methodological notes** — keep them out of Key Findings unless the methodology is itself a finding (e.g., "the authors developed a new measurement framework").
- **Author opinions** — distinguish from findings. "The authors argue X" is a finding about the document, not a finding about the world.

---

## Stated Benefits

### Definition
Outcomes the source **explicitly claims** the studied approach, product, or recommendation produces.

### Decision rule
- Must be explicitly claimed, not inferred.
- Phrased as an outcome ("X reduces Y" / "X enables Z").
- If the source uses hedged language ("may," "could"), retain the hedge.

### Positive example (source said this directly)
> "The walkthrough approach reduced support tickets by 22% in the same window."

### Negative example (the reader is inferring this)
> "Reduced support tickets probably also lower training costs." → This is an inference, not a stated benefit. Move it to "Next research areas" as a question.

### Edge cases
- **Hedged claims.** Keep the hedge: "The authors suggest the approach may improve retention."
- **Promotional sources** (vendor whitepapers). Apply the same rule — if the source claims it, it is a stated benefit. Mark in "Gaps & limitations" that the source has commercial interests.

---

## Gaps & Limitations

### Definition
Things the source **does not address**, plus limitations the authors themselves disclose.

### Decision rule
- Two flavors:
  1. **Author-disclosed** ("the study sample was limited to four teams in one industry").
  2. **Reader-identified** ("the source does not address effect persistence beyond 90 days").
- Reader-identified gaps must be specific. "More research is needed" is not a gap; "the source does not address whether the effect persists at 180 days" is.

### Positive example (reader-identified)
> "The source does not measure whether onboarding-time gains persist at 6+ months."

### Negative example (too vague)
> "More research is needed."

### Edge cases
- **Soft contradictions** (the source claims X in one section, Y in another). Note in Gaps; do not silently reconcile.
- **Out-of-scope topics.** A source can legitimately exclude a topic — only flag as a gap if the topic is necessary for the thesis to hold.

---

## Next Research Areas

### Definition
Concrete, falsifiable questions that follow naturally from the gaps. The principal value-add of this GPT.

### Decision rule
- Every next-research area must derive from a gap (1:1 or 1:N).
- Phrased as a **question**, not a topic.
- **Specific enough to design a study around.** "How can we improve onboarding?" is not — "Does the 30% time-reduction effect replicate in remote-only teams of >50?" is.
- 3–5 per document. Quality over quantity.

### Positive example
> "Does the 30% onboarding-time reduction persist beyond 6 months, or does it regress as walkthrough novelty fades?"

### Negative example (too vague to study)
> "Future research should explore long-term effects."

### Edge cases
- **No clear gaps.** If a source is comprehensive (rare), pick the strongest implication and frame the question around scope expansion (different population, different time horizon).
- **Author-suggested future work.** Quote it if specific; refine it if vague.

See `next-research-prompts.md` for the five scaffolds that turn gaps into well-formed questions.

---

## Handling Edge Cases

### Thin sources (<3 supportable findings)
- Note source thinness explicitly in the Insight Extract.
- Do not pad findings or invent benefits.
- A thin source can still produce strong next-research questions — that may be its main value.

### Contradictory sources
- Surface contradictions in Gaps, not Findings.
- Do not silently pick a side.

### Meta-analyses / lit reviews
- The "thesis" is the reviewer's synthesis, not any individual paper.
- "Findings" are the reviewer's conclusions across the corpus.
- "Gaps" include both reviewer-identified gaps and consistent gaps across the underlying papers.

### Vendor / promotional content
- Apply the same rules.
- Note commercial interest in Gaps & limitations.
- Be especially strict on the "stated benefits must be explicitly claimed" rule.
