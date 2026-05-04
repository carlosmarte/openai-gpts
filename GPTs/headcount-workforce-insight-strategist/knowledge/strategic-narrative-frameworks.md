# Strategic Narrative Frameworks (N1–N6)

This file codifies the narrative patterns the strategist applies in the `Insight (so what?)` paragraph. Every paragraph cites at least one pattern (Nx) in the run footer. The pattern is not the prose — it is the *shape* of the implication being drawn.

Each pattern lists:
- **Trigger:** the data condition that causes the pattern to fire
- **Required metrics:** what F-pattern outputs the narrative cites
- **Implication template:** the sentence shape (filled in with the user's specific numbers)
- **Anti-patterns:** how the framing fails when applied carelessly

The strategist does not use a pattern unless the data supports it. If no pattern fits, the GPT returns the Filter Mode output without an Insight paragraph and notes "no narrative pattern fired" in the footer.

---

## N1 — Concentration Risk

**Trigger:** A group's share of the matched cohort is meaningfully higher than its share of the total file (e.g., "EMEA Q1 hires are 49% Tech vs 24% global Tech share").

**Required metrics:** F1 matched-row count + F3 group-by counts on the filtered cohort + F3 group-by counts on the full file (for comparison baseline).

**Implication template:** *"\<group X> is {share_in_cohort}% of {filter description} ({matched_count} of {total_matched})  — {ratio}× the {share_in_full}% baseline. If {dependency} slips, {group X} absorbs the bulk of {risk surface}."*

**Anti-patterns:**
- Citing a concentration without the baseline ("EMEA hired 142 Tech engineers" — vs what?). Always include the comparison.
- Calling any majority a "risk" when the dependency is unstated.

---

## N2 — Manager-Span Outliers

**Trigger:** Some managers have direct-report counts ≥ 2× the median span; or some have spans ≤ 2 (potential under-utilized layer).

**Required metrics:** F4 (resolve `manager_id`-derived hierarchy) + F3 group-by `manager_id` to count direct reports + F3 median span across the layer.

**Implication template:** *"Median manager span is {median}. {N} managers ({pct}%) carry ≥ {2× median} reports — these are the manager-burnout candidates. {M} managers carry ≤ 2 reports — these are layer-redundancy candidates. Layer-health gap concentrates in {country / location / region}."*

**Anti-patterns:**
- Pointing at one over-loaded manager without showing the median (no comparison frame).
- Conflating "high span" with "bad management" — the pattern surfaces structural risk, not performance.

---

## N3 — Attrition Concentration

**Trigger:** Departures (rows where `term_date` falls in the queried window) are non-uniformly distributed across a meaningful axis (country, location, manager, region).

**Required metrics:** F1 (filter `term_date` to the window) + F3 group-by + F3 group-by on full file (baseline). If `term_date` is absent, this pattern cannot fire.

**Implication template:** *"{N} departures in {window} concentrate in {country/location/manager_org}: {sub_count} of {N} ({pct}%) vs {baseline_pct}% of total headcount. {Concentration_factor}× over-representation suggests {hypothesis: retention issue / planned RIF / org redesign}."*

**Anti-patterns:**
- Asserting a "retention issue" without ruling out planned reorganizations.
- Treating <5 departures as a pattern (label as "Hypothesis" if cohort is small).

---

## N4 — Hire-Velocity Comparison

**Trigger:** Hire counts in the queried date window differ meaningfully from hire counts in a comparable prior window (e.g., Q1 2026 vs Q1 2025).

**Required metrics:** F1 + F5 (date-range) + F3 (count) for both windows. If only one window is queryable, this pattern cannot fire.

**Implication template:** *"{Current_window} hires: {current_n}. {Prior_comparable_window}: {prior_n}. {Delta} ({pct}% change). {Interpretation}: hiring velocity has {accelerated/decelerated/held flat} — implications for {capacity/runway/burn}."*

**Anti-patterns:**
- Comparing non-comparable windows (e.g., Q1 vs full year). Always normalize to the same length.
- Reading a single-quarter swing as a trend (need at least 3 windows for a trend claim).

---

## N5 — Capacity vs Attrition

**Trigger:** Net capacity change in a window — incoming hires minus departures — is non-trivially negative or positive.

**Required metrics:** F1 + F5 (filter to window) + F3 (count where `hire_date` in window) + F3 (count where `term_date` in window). Both must be derivable.

**Implication template:** *"{Window} net capacity change: +{hires} hires - {departures} departures = {net} ({pct}% of starting headcount). At this rate, {country/region} {gains_or_loses} {projected_n} per {period} — {capacity_runway} months until {threshold}."*

**Anti-patterns:**
- Projecting forward without stating "at this rate" — the math is conditional.
- Ignoring planned vs unplanned distinction (the pattern surfaces the math, not the cause).

---

## N6 — Cohort Exposure

**Trigger:** A specific cohort (e.g., "Tech employees hired in Q1 2024") has a distinguishing characteristic on another axis (tenure now, manager-level distribution, attrition rate).

**Required metrics:** F1 (cohort definition) + F3 (cohort size) + F2 + F3 (distribution of the second axis within the cohort, vs full file).

**Implication template:** *"The {cohort_definition} cohort ({N} employees, {cohort_pct}% of file) shows {axis_finding}: {distribution_difference} vs the broader population. {Implication}: this cohort is {more/less} exposed to {event} because {causal_link}."*

**Anti-patterns:**
- Defining a cohort post-hoc to fit a narrative (the cohort must come from the user's question, not be invented).
- Confusing correlation with causation in the implication.

---

## Pattern selection

Multiple patterns may apply to a single matched cohort; the strategist picks the **one that most directly answers "so what?"** for that question. If two patterns are equally relevant, mention both — but never list patterns serially without grounding each in a number.

If the matched cohort is < 5 rows in any aggregation bucket, the Insight is labeled `Hypothesis — needs deeper analysis.` regardless of which pattern fired.

---

## Anti-patterns across all N1–N6

- **Number-as-insight.** "EMEA has 287 Q1 hires" is data, not insight. The insight is what that 287 *means*.
- **Implication without metric.** "We have a capacity risk in EMEA" without citing a specific cohort size, share, or rate from the Filters / Aggregations.
- **Recommendation-as-insight.** "We should hire more in EMEA" is a decision, not an insight; surface as a separate "Decision Required" line if the question asked for one.
- **Pattern stacking.** Citing 3+ patterns in 4 sentences pads the paragraph; pick one (or at most two) and develop them.
- **Hedge filler.** "It seems like potentially…", "we might want to consider…" — the strategist does not hedge. Either the data supports the implication or the Insight is labeled Hypothesis.
