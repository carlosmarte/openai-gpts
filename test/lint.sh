#!/usr/bin/env bash
# Static lint pass — no LLM calls, no cost. Run this on every CI / pre-commit.
#
# Checks:
#   1. system-instructions.md ≤ 8000 chars per GPT
#   2. gpt-spec.md Description ≤ 300 chars per GPT
#   3. system-instructions.md does NOT use `knowledge/X.md` paths (must be bare filenames)
#   4. The 7 common knowledge files are byte-identical across all 3 GPTs
#   5. Each GPT's knowledge directory contains the expected files

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

GPTS=(
  GPTs/headcount-executive-analyst
  GPTs/headcount-reporter
  GPTs/headcount-workforce-insight-strategist
)

COMMON=(
  Column.md
  ORG-chart.md
  headcount-schema-dictionary.md
  analytical-formulas.md
  anomaly-detection-rules.md
  compliance-pii-guardrails.md
  code-generation-templates.md
)

fail=0
pass=0

bullet() { printf "  %-6s %s\n" "$1" "$2"; }

echo "=== 1. system-instructions.md char limit (≤ 8000) ==="
for d in "${GPTS[@]}"; do
  f="$d/system-instructions.md"
  # Count Unicode chars, not bytes — GPT Builder counts chars and
  # UTF-8 multibyte chars (em dashes, smart quotes) inflate byte count.
  n=$(python3 -c "import sys; print(len(open(sys.argv[1]).read()))" "$f")
  if [ "$n" -le 8000 ]; then
    bullet "PASS" "$d ($n chars)"
    pass=$((pass+1))
  else
    bullet "FAIL" "$d ($n chars; over by $((n-8000)))"
    fail=$((fail+1))
  fi
done

echo ""
echo "=== 2. gpt-spec.md Description ≤ 300 chars ==="
for d in "${GPTS[@]}"; do
  f="$d/gpt-spec.md"
  desc_line=$(grep -m1 '^\*\*Description:\*\*' "$f" || true)
  desc="${desc_line#\*\*Description:\*\* }"
  n=$(python3 -c "import sys; print(len(sys.argv[1]))" "$desc")
  if [ "$n" -le 300 ] && [ "$n" -gt 0 ]; then
    bullet "PASS" "$d ($n chars)"
    pass=$((pass+1))
  else
    bullet "FAIL" "$d ($n chars)"
    fail=$((fail+1))
  fi
done

echo ""
echo "=== 3. system-instructions has no \`knowledge/X.md\` paths ==="
for d in "${GPTS[@]}"; do
  f="$d/system-instructions.md"
  if grep -q '`knowledge/' "$f"; then
    bullet "FAIL" "$d still references \`knowledge/...\`"
    grep -n '`knowledge/' "$f" | sed 's/^/      /'
    fail=$((fail+1))
  else
    bullet "PASS" "$d (uses bare filenames)"
    pass=$((pass+1))
  fi
done

echo ""
echo "=== 4. Common knowledge files are byte-identical across GPTs ==="
for f in "${COMMON[@]}"; do
  digests=$(for d in "${GPTS[@]}"; do
    if [ -f "$d/knowledge/$f" ]; then
      shasum -a 256 "$d/knowledge/$f" | cut -d' ' -f1 | cut -c1-12
    else
      echo "MISSING"
    fi
  done | sort -u | wc -l | tr -d ' ')
  if [ "$digests" = "1" ]; then
    bullet "PASS" "$f (identical across 3 GPTs)"
    pass=$((pass+1))
  else
    bullet "FAIL" "$f (DIVERGED — $digests distinct hashes)"
    fail=$((fail+1))
  fi
done

echo ""
echo "=== 5. Required knowledge files present per GPT ==="
declare -a EXTRA_PER_GPT
EXTRA_PER_GPT[0]=""
EXTRA_PER_GPT[1]="executive-report-template.md"
EXTRA_PER_GPT[2]="strategic-narrative-frameworks.md"
i=0
for d in "${GPTS[@]}"; do
  required=("${COMMON[@]}")
  if [ -n "${EXTRA_PER_GPT[$i]}" ]; then
    required+=("${EXTRA_PER_GPT[$i]}")
  fi
  missing=0
  for f in "${required[@]}"; do
    if [ ! -f "$d/knowledge/$f" ]; then
      bullet "FAIL" "$d/knowledge/$f MISSING"
      fail=$((fail+1))
      missing=$((missing+1))
    fi
  done
  if [ "$missing" = 0 ]; then
    bullet "PASS" "$d (${#required[@]} files present)"
    pass=$((pass+1))
  fi
  i=$((i+1))
done

echo ""
echo "=== Summary ==="
echo "  Passed: $pass"
echo "  Failed: $fail"
[ "$fail" = 0 ] || exit 1
