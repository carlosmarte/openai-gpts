# Source & Output Assessment Rubric

Defines the closing two-axis assessment block emitted as **Part 3** of every response. Two independent bands — Source Trust (how much do we trust the input?) and Output Confidence (how much do we trust our extraction?) — followed by a Top-3-Risks list.

## Why Two Axes?

Source Trust and Output Confidence are not the same thing.

- A pristine, well-tested codebase (High Source Trust) can still produce Low Output Confidence if the user pasted only one file out of fifty.
- A messy, dynamically-routed codebase (Low Source Trust) can yield High Output Confidence on the small portion that *is* statically resolvable.

The reader needs both signals to calibrate how much of the artifact to act on.

## Source Trust — Dimensions

Score each on a 1–3 scale (1 = absent / problematic, 2 = partial, 3 = strong). Sum and band.

| Dimension              | 1 (Low)                                                | 2 (Medium)                                            | 3 (High)                                                              |
| ---------------------- | ------------------------------------------------------ | ----------------------------------------------------- | --------------------------------------------------------------------- |
| Code completeness      | Snippets only; entry points missing                    | Most files present; some imports unresolved          | Full repo or service, all imports resolved                            |
| Framework recognized   | Unknown / bespoke / mixed without convention           | Recognized but with custom DI/routing layer           | Standard framework, idiomatic usage                                   |
| Tests / fixtures       | None                                                   | Some unit tests; no integration tests                 | Unit + integration + contract tests pinning observed behavior         |
| Build / config visible | No `package.json`/`pom.xml`/`pyproject.toml` etc.      | Manifest visible; no env or deployment config        | Manifests + env templates + deployment manifests visible              |
| Doc comments           | Bare code, no docstrings or comments                   | Some docstrings, partial coverage                     | Consistent docstrings/Javadoc/XML-comments on public surface          |

**Banding (sum of 5 dimensions, 5–15 range):**

- **High Source Trust:** ≥ 12
- **Medium Source Trust:** 8–11
- **Low Source Trust:** ≤ 7

## Output Confidence — Dimensions

Score on the same 1–3 scale. Sum and band.

| Dimension              | 1 (Low)                                                | 2 (Medium)                                            | 3 (High)                                                              |
| ---------------------- | ------------------------------------------------------ | ----------------------------------------------------- | --------------------------------------------------------------------- |
| Schema validity        | YAML has known structural issues                       | Validates; warnings present                           | Validates clean; passes self-checks in `openapi-3-1-reference.md` §7  |
| Traceability density   | < 70% of claims cited                                  | 70–94% cited                                          | ≥ 95% cited; remainder explicit `[ASSUMPTION]`                        |
| Assumption count       | > 10 `[ASSUMPTION]` tags or critical-path assumptions  | 3–10 tags, none on critical paths                     | ≤ 2 tags, all on peripheral details                                   |
| Edge case coverage     | Mostly happy-path                                      | Some error branches; gaps in auth or validation       | Per-endpoint: auth, validation, not-found, conflict, upstream failure |
| Endpoint coverage      | Some routes silently dropped                           | All routes covered; some only minimally               | Every route fully spec'd or explicitly flagged in Top 3 risks         |

**Banding (sum of 5 dimensions, 5–15 range):**

- **High Output Confidence:** ≥ 12
- **Medium Output Confidence:** 8–11
- **Low Output Confidence:** ≤ 7

## Top 3 Risks — Format

After the two bands, list the three highest-impact risks discovered during extraction. Order by impact, not chronology.

```
**Top 3 risks:**
1. _Concrete risk._ — _Why it matters._ — _Mitigation or follow-up._
2. ...
3. ...
```

**Examples of risks worth surfacing:**

- Dynamic routing not statically resolvable (e.g., routes registered from a database table or env-driven plugin loader).
- Mocked authentication in the visible code (real auth lives in middleware not provided).
- Silent error swallowing (broad `try/catch` returning 200 — observable behavior diverges from contract).
- Multiple media types declared but only `application/json` traced — others may have different schemas.
- ORM lazy-loading patterns that change the actual response shape from what the function signature suggests.
- API gateway / reverse proxy in front of the service rewriting paths or injecting headers not visible in the code.
- Spec bigger than the output budget — split into per-tag fragments; reassembly required.
- Versioning ambiguity (multiple `/v1`, `/v2` prefixes in coexisting routers without a clear deprecation signal).

## Output Block Template

```
## Source & Output Assessment

**Source Trust:** [High | Medium | Low] — _one-line rationale_
**Output Confidence:** [High | Medium | Low] — _one-line rationale_

**Top 3 risks:**
1. _Risk._ — _Why it matters._ — _Mitigation._
2. _Risk._ — _Why it matters._ — _Mitigation._
3. _Risk._ — _Why it matters._ — _Mitigation._
```

## Calibration Guardrails

- Never default both bands to High. If the user supplied only snippets, Source Trust cannot be High by definition.
- Never default both bands to Low to look humble — score the dimensions honestly.
- If Source Trust is Low and Output Confidence is High, double-check: are you over-confident on a small surface? Re-score Output Confidence with "endpoint coverage" honestly applied to *all* endpoints, not just the ones in scope.
- A High Output Confidence call requires zero `[ASSUMPTION]` tags on critical paths (auth, persistence, monetary calculations, anything regulatory).
