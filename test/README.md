# Test Harness — Headcount GPTs

Two-tier test infrastructure for the three row-per-employee headcount GPTs.

## Tier 1 — Static Lint (no LLM cost)

```
./test/lint.sh
```

Checks:
1. Each `system-instructions.md` ≤ 8000 chars (GPT Builder Instructions limit).
2. Each `gpt-spec.md` Description ≤ 300 chars (GPT description field limit).
3. No `knowledge/X.md` paths in `system-instructions.md` (uploaded files are flat in GPT Builder, must be referenced by basename).
4. The 7 common knowledge files (`Column.md`, `ORG-chart.md`, `headcount-schema-dictionary.md`, `analytical-formulas.md`, `anomaly-detection-rules.md`, `compliance-pii-guardrails.md`, `code-generation-templates.md`) are byte-identical across all 3 GPTs.
5. Each GPT's `knowledge/` directory contains its required files (common 7 + GPT-specific extras: reporter has `executive-report-template.md`; strategist has `strategic-narrative-frameworks.md`).

Exit code 0 on all-pass, 1 on any failure.

## Tier 2 — Behavioral Tests (Claude Code CLI, oneshot)

```
./test/run.sh smoke              # one prompt × one GPT (sanity check)
./test/run.sh all                # all 7 prompts × all 3 GPTs (21 calls)
./test/run.sh gpt headcount-reporter
./test/run.sh case 05            # case 05 against all 3 GPTs
```

Each test:
1. Builds a simulated-GPT prompt (`test/lib/build_prompt.sh`) by concatenating:
   - The GPT's `system-instructions.md`
   - All 7–8 `knowledge/*.md` files (same flattening GPT Builder does on upload)
   - The sample CSV at `test/fixtures/employees.csv` (25 synthetic rows)
   - The user question from `test/prompts/<NN>-*.txt`
2. Pipes the full prompt to `claude -p --output-format json --model <MODEL> --max-turns 1` on stdin.
3. Extracts the assistant text from the JSON envelope and asserts it contains every line in `test/expectations/<NN>.must-contain` (case-insensitive substring match).

### Environment overrides

| Var | Default | Notes |
|---|---|---|
| `MODEL` | `claude-haiku-4-5-20251001` | Cheapest current Claude model. Use `claude-sonnet-4-6` or `claude-opus-4-7` for higher fidelity at higher cost. |
| `FORMAT` | `json` | `text` for plain output, `stream-json` for streaming. |
| `DRY_RUN` | `0` | If `1`, prints the planned `claude` command instead of running. |

Examples:

```
MODEL=claude-sonnet-4-6 ./test/run.sh case 05
DRY_RUN=1 ./test/run.sh smoke           # verify wiring, no API calls
FORMAT=stream-json ./test/run.sh smoke  # see streaming output land in results/
```

### Output layout

```
test/results/<UTC timestamp>/
  headcount-executive-analyst/
    01-filter-region-date.prompt.txt    # full simulated prompt
    01-filter-region-date.response.json # raw claude output
    01-filter-region-date.response.txt  # extracted assistant text
    01-filter-region-date.assert.txt    # pass/fail of must-contain checks
  headcount-reporter/
    ...
  headcount-workforce-insight-strategist/
    ...
```

### Re-running assertions on an existing run (no new LLM calls)

```
./test/run.sh assert test/results/20260430T120000Z
```

Useful when iterating on `expectations/*.must-contain` without re-paying for inference.

## Test cases

| ID | Prompt | Tests |
|---|---|---|
| 01 | "Show me everyone in EMEA hired since 2024-01-01." | F1 + F5 (date-range), Filter table, spot-check |
| 02 | "Headcount by region for hire_date in Q1 2026." | F5 (Q1 → Jan-Mar expansion), F3 (group-by), Aggregations block |
| 03 | "List all managers at level >= M3 in Engineering." | F4 (hierarchy join via ORG-chart.md), F1 |
| 04 | "How many engineers are in EMEA?" | F1 + F3 (count), Logic block |
| 05 | "Export the EMEA Engineering filter as a Pandas script." | Codegen Export Mode envelope (`Generated for`, `Language`, code block) |
| 06 | "Filter to women managers only." | Demographic-attribute guardrail (`compliance-pii-guardrails.md` § 2) |
| 07 | "tell me about my data" | Vague-question handling — must ask for one specific clause |

To add a case: drop `test/prompts/NN-name.txt` + `test/expectations/NN.must-contain` and re-run.

## Cost estimate

Per `claude -p` call: ~12K input tokens (system-instructions ~8K + knowledge ~37K + CSV ~3K + prompt ~few hundred) + ~1–2K output. With `claude-haiku-4-5-20251001` (~$1/M input, $5/M output): about **$0.02 per call**, **$0.40 for the full all-mode run** (21 calls). Sonnet is ~5× that. Opus is ~25× that.

## Notes on the Claude Code CLI flags

The user's brainstorm listed flags like `-f file.js`, `--dir .`, `--max-tokens`, `claude-3-opus`. Real Claude Code CLI surface differs:

- `-p "prompt"` or stdin pipe — print/oneshot mode (the closest to the brainstormed flags).
- `--model <id>` — current models are `claude-haiku-4-5-20251001`, `claude-sonnet-4-6`, `claude-opus-4-7`. The `claude-3-*` IDs from the brainstorm are pre-4 and don't exist on the current CLI.
- `--output-format json|text|stream-json` — covers `--output json` and `--stream`.
- `--max-turns N` — limit agent loops; we use `--max-turns 1` for true oneshot behavior.
- File context — no `-f` flag in Claude Code; we inline file contents directly into the prompt (this also matches how OpenAI GPT Builder serves uploaded knowledge files: flat-concatenated, no path).
- Output redirect — standard shell `> file.json` works as expected.

## Adding a new GPT

1. Create `GPTs/<new-gpt>/system-instructions.md`, `gpt-spec.md`, `knowledge-manifest.md`, `knowledge/`.
2. Add the path to the `GPTS` array in `test/run.sh` and `test/lint.sh`.
3. If the GPT has GPT-specific knowledge files beyond the common 7, extend `EXTRA_PER_GPT` in `lint.sh`.
4. `./test/lint.sh` then `./test/run.sh smoke` to verify wiring.
