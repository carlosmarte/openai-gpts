# Source & Output Assessment Rubric

This rubric defines scoring criteria for the closing `## Source & Output Assessment` section. Apply consistently — the same source should produce the same scores from one run to the next.

## Part 1 — Source Quality (Document Rating)

Rate the **source PDF**, not the GPT's extraction. Score four dimensions on a 1–5 integer scale.

### Evidence Strength

How well-supported are the source's claims by data, citations, or reproducible methodology?

| Score | Criteria |
|-------|----------|
| 5 | Quantitative findings with disclosed methodology, sample size, control conditions, and external citations. Reproducible. |
| 4 | Quantitative findings with disclosed methodology and sample size, but limited replication detail. |
| 3 | Mix of qualitative and quantitative claims; methodology described but partial; some citations. |
| 2 | Mostly qualitative claims; methodology absent or vague; few citations. |
| 1 | Assertive claims with no supporting evidence, methodology, or citations. Opinion-driven. |

### Clarity

How well-structured and readable is the source for its target audience?

| Score | Criteria |
|-------|----------|
| 5 | Clear thesis, logical section structure, concise language, defined terms, navigable on first read. |
| 4 | Clear thesis and structure; minor jargon or organizational issues. |
| 3 | Thesis discoverable; structure adequate; some sections require re-reading. |
| 2 | Thesis unclear; structure weak; meaning depends on rereading and inference. |
| 1 | Disorganized; thesis absent; reader must reconstruct meaning. |

### Novelty

Does the source advance new thinking, data, or framing — or rehash existing ideas?

| Score | Criteria |
|-------|----------|
| 5 | New data, new framework, or a contrarian thesis well-defended. |
| 4 | New data or new framing of an existing idea; meaningful contribution to the conversation. |
| 3 | Useful synthesis of existing ideas with one or two new angles. |
| 2 | Mostly synthesis or rephrasing of well-known ideas. |
| 1 | Restates conventional wisdom with no new contribution. |

### Generalizability

How broadly do the findings apply beyond the studied context?

| Score | Criteria |
|-------|----------|
| 5 | Findings replicated across multiple populations/contexts, or supported by a mechanism the source explains. |
| 4 | Single well-designed study with population diverse enough to support some generalization. |
| 3 | Findings limited to studied context; transfer plausible but unproven. |
| 2 | Narrow context (single team, single industry, small sample); transfer speculative. |
| 1 | Anecdotal or single-case; not designed for generalization. |

### Trust Band

After scoring all four dimensions, assign an overall band:

| Band | Criterion |
|------|-----------|
| High | Average ≥ 4.0 AND no dimension below 3 |
| Medium | Average 2.5–3.9 OR any single dimension below 3 with others ≥ 4 |
| Low | Average < 2.5 OR Evidence Strength = 1 |

Tie-breakers favor lower bands. A document with a 4.0 average and a 1 in Evidence Strength is **Low**, not High — weak evidence is disqualifying regardless of other dimensions.

---

## Part 2 — Output Self-Assessment

Rate the GPT's own extraction. Be honest — the goal is to inform the reader's trust, not to make the output look stronger.

### Source Fidelity

Count the number of `[unverified]` flags across the Insight Extract and channel posts.

| Status | Criterion |
|--------|-----------|
| 0 flags | All claims traced to source. |
| 1–2 flags | Minor inferences flagged transparently. |
| 3+ flags | Significant inference required; reader should treat posts cautiously. |

### Claim Coverage

Approximate percentage of the source's key findings represented in at least one channel post. Estimate, do not over-precise.

| Range | Criterion |
|-------|-----------|
| ≥ 80% | Comprehensive — channel posts cover the central thesis and most supporting findings. |
| 50–79% | Selective — channel posts cover the thesis but omit supporting findings (often deliberate, given length caps). |
| < 50% | Sparse — channel posts cover only the headline; reader should consult the source directly. |

### Channel Format Fit (per channel)

Apply per `channel-style-guide.md`:

| Status | Criterion |
|--------|-----------|
| OK | All channel rules satisfied (length, structure, tone, hashtag norms). |
| Partial | One or two rules relaxed (e.g., went slightly over length to preserve a key claim). |
| Off | Rules violated for content reasons (e.g., source so thin the post can't reach the minimum without padding). |

### Confidence Band

Combine the four checks into an overall band:

| Band | Criterion |
|------|-----------|
| High | 0–1 unverified flags AND ≥ 80% coverage AND all three channels "OK" |
| Medium | 2 unverified flags OR 50–79% coverage OR one channel "Partial" |
| Low | 3+ unverified flags OR < 50% coverage OR any channel "Off" |

Like the Trust Band, tie-breakers favor lower bands.

---

## Calibration Examples

### Example A — High-Quality Empirical Paper

A peer-reviewed study with N=2,400, control group, replicated finding, clear thesis, defined terms.

- Evidence strength: 5
- Clarity: 4
- Novelty: 4 (incremental contribution)
- Generalizability: 4
- **Trust band: High**

If the GPT's extraction has 0 `[unverified]` flags, ~85% coverage, and all three channel posts well-formed:

- Confidence band: **High**

### Example B — Vendor Whitepaper

A 12-page promotional PDF with one customer case study (n=1), no methodology, several stated benefits, glossy formatting.

- Evidence strength: 1 (single anecdote, no methodology)
- Clarity: 4 (well-formatted, easy read)
- Novelty: 2 (rehashes industry talking points)
- Generalizability: 1 (n=1)
- **Trust band: Low** (Evidence Strength = 1 forces the band down)

Even if extraction is clean (0 unverified, 90% coverage, all channels OK), Confidence band can still be **High** — but the Trust band tells the reader to treat the source skeptically. The two bands are independent.

### Example C — Thin Source, Honest Extraction

A 4-page blog-style PDF with two opinions and no data.

- Evidence strength: 1
- Clarity: 3
- Novelty: 2
- Generalizability: 1
- **Trust band: Low**

Extraction: 1 `[unverified]` flag, ~70% coverage, Slack post forced to **Partial** because content didn't justify minimum length.

- Confidence band: **Medium**

This is a valid output. The reader sees that both the source and the extraction are limited and acts accordingly.

---

## Honesty Norm

The Source & Output Assessment is the GPT's most important credibility signal.

- Never inflate scores to make the output look stronger.
- Never deflate scores to seem humble — under-scoring a strong source mis-serves the reader too.
- When uncertain between two scores, pick the lower one and explain why in the note.
- A correctly identified Low/Low rating is more useful to the reader than an inflated High/High that misleads them.
