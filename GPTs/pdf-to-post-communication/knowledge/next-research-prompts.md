# Next-Research Prompt Scaffolds

Five reusable scaffolds for turning document gaps into specific, falsifiable, well-scoped research questions. Pick the scaffold that fits the gap; combine when needed.

## Quality Bar

A well-formed next-research question is:

1. **Derived from a specific gap** in the Insight Extract.
2. **Specific enough to design a study around** — names the population, the variable, and (when possible) the measurement.
3. **Falsifiable** — a study could return "no, the effect does not hold."
4. **Scoped** — one question per item, not a question with three sub-questions stapled together.

A weak question is vague ("How can we improve X?"), unfalsifiable ("Should we think about Y?"), or compound ("How does X affect Y, Z, and W in different industries?").

---

## Scaffold 1 — Scope Expansion

> "The source addresses X in context A; what changes in context B?"

### When to use
The source studies a phenomenon in a narrow context (one industry, one company size, one geography, one product type). The natural question is whether the finding generalizes.

### Worked example
- **Gap:** "The source studied four B2B SaaS teams of 20–50 people."
- **Question:** "Does the 30% onboarding-time reduction replicate in B2C consumer apps with >1M users, or does the effect depend on the structured workflow patterns common to B2B tools?"

### Variations
- **Industry expansion:** A → B
- **Company-size expansion:** SMB → enterprise
- **Geography expansion:** US → EU/APAC
- **Product-type expansion:** SaaS → marketplace, SaaS → e-commerce

---

## Scaffold 2 — Mechanism Probe

> "The source observes X correlates with Y; what mechanism explains the link?"

### When to use
The source reports an association or outcome but does not explain why it happened. Mechanism questions are high-value because they point at *causes*, not just *correlations*.

### Worked example
- **Gap:** "The source reports that interactive walkthroughs reduced support tickets by 22% but does not explain why."
- **Question:** "Is the support-ticket reduction driven primarily by (a) fewer first-week errors due to guided flows, (b) higher feature discovery shifting questions earlier in the funnel, or (c) selection effects in who completes the walkthrough?"

### Variations
- Decompose the effect into 2–4 candidate mechanisms.
- Frame each candidate so a study could discriminate between them.

---

## Scaffold 3 — Population Variance

> "The source studies population P; does the finding replicate in P′?"

### When to use
The source's population has a defining characteristic (size, role, expertise level, demographic) and you want to know if the finding holds for a different population.

### Worked example
- **Gap:** "The source studied users with prior SaaS experience."
- **Question:** "Does the 30% onboarding-time reduction hold for users with no prior SaaS experience, or do walkthrough patterns assume product-literacy that first-time users lack?"

### Variations
- **Expertise:** novice → expert
- **Role:** end user → administrator
- **Adoption stage:** early adopters → late majority
- **Engagement level:** active users → low-frequency users

---

## Scaffold 4 — Time-Horizon Test

> "The source measures the effect at t = N; does the effect persist at t = N × k?"

### When to use
The source measures a short-term outcome and the natural question is whether the effect is durable. Especially common with onboarding, training, marketing-campaign, or behavior-change studies.

### Worked example
- **Gap:** "The source measured outcomes at 30, 60, and 90 days."
- **Question:** "Does the onboarding-time reduction persist at 6+ months, or does the effect regress as walkthrough novelty fades and users develop muscle memory through other paths?"

### Variations
- **Short-term → long-term:** 90 days → 1 year
- **Long-term → short-term:** lifetime metric → first-week behavior
- **Decay characterization:** "If the effect decays, what is the half-life?"

---

## Scaffold 5 — Counterfactual Test

> "If the source's recommended action were not taken, what evidence would predict outcome Z?"

### When to use
The source recommends an action and reports an outcome but does not characterize what would have happened without the action. Counterfactual questions stress-test causal claims.

### Worked example
- **Gap:** "The source attributes the 22% support-ticket reduction to the walkthrough but did not run a control."
- **Question:** "Would a comparable cohort that received only an updated help-center article (no walkthrough) have shown a similar reduction, suggesting the gain is from any onboarding investment rather than the walkthrough specifically?"

### Variations
- **Cheaper alternative:** "Does a low-cost intervention produce similar results?"
- **No-intervention baseline:** "What is the natural rate of improvement without any change?"
- **Reverse causation:** "Could the outcome have caused the adoption, rather than vice versa?"

---

## Combining Scaffolds

Some gaps warrant a question that crosses scaffolds. Combine sparingly — keep the question single-focus.

### Example
- **Gap:** "The source studied four B2B teams over 90 days with no control group."
- **Combined question (Scopes 1 + 4 + 5):** "In a controlled trial against a help-center-only baseline, does the walkthrough's onboarding-time advantage persist for B2C users at 6 months?"

If a single question becomes too compound, split it into two next-research items.

---

## Anti-patterns

- **"More research is needed on X."** Reword with a specific question.
- **"How can we improve X?"** Too open. Specify the population, the lever, and the outcome.
- **"What is the future of X?"** Forecasting, not research.
- **Questions a search engine would answer.** Next-research areas should require *new* data collection or analysis.
- **Compound questions stapled with "and."** Split.
