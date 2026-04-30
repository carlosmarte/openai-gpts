#!/usr/bin/env bash
# Behavioral test runner for the three headcount GPTs.
#
# For each GPT × each prompt, builds a full simulated-GPT prompt
# (system-instructions + knowledge files + sample CSV + user question)
# and pipes it through `claude -p` in oneshot mode. Captures the
# response and checks it against expectation patterns.
#
# Usage:
#   ./test/run.sh lint                # static checks only (no LLM)
#   ./test/run.sh smoke               # one prompt × one GPT (cheapest sanity)
#   ./test/run.sh all                 # all prompts × all 3 GPTs
#   ./test/run.sh gpt <name>          # all prompts × one GPT
#   ./test/run.sh case <NN>           # one prompt × all 3 GPTs
#   ./test/run.sh assert <run_dir>    # re-run assertions on an existing run
#
# Environment:
#   MODEL    Claude model id (default: claude-haiku-4-5-20251001)
#   FORMAT   Output format: text | json | stream-json (default: json)
#   DRY_RUN  If 1, prints the claude command instead of running it.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

MODEL="${MODEL:-claude-haiku-4-5-20251001}"
FORMAT="${FORMAT:-json}"
DRY_RUN="${DRY_RUN:-0}"
CSV="$ROOT/test/fixtures/employees.csv"

GPTS=(
  GPTs/headcount-executive-analyst
  GPTs/headcount-reporter
  GPTs/headcount-workforce-insight-strategist
)

# shellcheck source=lib/build_prompt.sh
source "$ROOT/test/lib/build_prompt.sh"
# shellcheck source=lib/assert.sh
source "$ROOT/test/lib/assert.sh"

require_claude() {
  if ! command -v claude >/dev/null 2>&1; then
    echo "ERROR: \`claude\` CLI not found on PATH. Install Claude Code first." >&2
    exit 127
  fi
}

# Run one (gpt × prompt) pair. Writes <run_dir>/<gpt>/<NN>-<name>.{prompt,response,assert}.
run_one() {
  local gpt_dir="$1" prompt_file="$2" run_dir="$3"
  local gpt_name; gpt_name=$(basename "$gpt_dir")
  local case_name; case_name=$(basename "$prompt_file" .txt)
  local case_id="${case_name%%-*}"
  local exp_file="$ROOT/test/expectations/${case_id}.must-contain"

  local out_dir="$run_dir/$gpt_name"
  mkdir -p "$out_dir"
  local prompt_out="$out_dir/${case_name}.prompt.txt"
  local resp_out="$out_dir/${case_name}.response.json"
  local text_out="$out_dir/${case_name}.response.txt"
  local assert_out="$out_dir/${case_name}.assert.txt"

  # Build the simulated-GPT prompt
  build_prompt "$gpt_dir" "$prompt_file" "$CSV" > "$prompt_out"

  echo ""
  echo ">>> $gpt_name :: $case_name"
  echo "    prompt:   $prompt_out ($(wc -c < "$prompt_out" | tr -d ' ') chars)"

  if [ "$DRY_RUN" = "1" ]; then
    echo "    [DRY_RUN] would run: claude -p --model $MODEL --output-format $FORMAT < $prompt_out"
    return 0
  fi

  # Run claude in oneshot/print mode, piping the full prompt on stdin
  # claude flags: -p print mode, --model selects model, --output-format json|text|stream-json
  if ! claude -p --model "$MODEL" --output-format "$FORMAT" --max-turns 1 < "$prompt_out" > "$resp_out" 2>"$assert_out.stderr"; then
    echo "    ERROR: claude exited non-zero. See $assert_out.stderr"
    return 2
  fi

  # Extract assistant text from the JSON envelope
  if [ "$FORMAT" = "json" ]; then
    extract_text "$resp_out" > "$text_out"
  else
    cp "$resp_out" "$text_out"
  fi

  # Run assertions
  if [ -f "$exp_file" ]; then
    if assert_contains_all "$text_out" "$exp_file" "$case_name" > "$assert_out"; then
      cat "$assert_out"
      echo "    -> OK"
    else
      cat "$assert_out"
      echo "    -> FAIL (response: $text_out)"
      return 1
    fi
  else
    echo "    (no expectation file at $exp_file — skipping assertions)"
  fi
}

# Run a battery of cases. <selector> can be:
#   "all"          -> all 3 GPTs × all prompts
#   "smoke"        -> first GPT × first prompt
#   "gpt:<name>"   -> one GPT × all prompts
#   "case:<NN>"    -> all GPTs × one prompt (matched by leading NN)
run_battery() {
  local selector="$1"
  local ts; ts=$(date -u +%Y%m%dT%H%M%SZ)
  local run_dir="$ROOT/test/results/$ts"
  mkdir -p "$run_dir"
  echo "Run dir: $run_dir"
  echo "Model:   $MODEL"
  echo "Format:  $FORMAT"

  local fails=0
  local prompts=("$ROOT"/test/prompts/*.txt)
  local gpts=("${GPTS[@]}")

  case "$selector" in
    smoke)
      gpts=("${GPTS[0]}")
      prompts=("${prompts[0]}")
      ;;
    all)
      ;;
    gpt:*)
      local name="${selector#gpt:}"
      gpts=()
      for d in "${GPTS[@]}"; do
        if [ "$(basename "$d")" = "$name" ]; then gpts+=("$d"); fi
      done
      [ "${#gpts[@]}" -gt 0 ] || { echo "no GPT named $name"; exit 2; }
      ;;
    case:*)
      local nn="${selector#case:}"
      prompts=("$ROOT"/test/prompts/${nn}-*.txt)
      [ -f "${prompts[0]:-}" ] || { echo "no prompt with case id $nn"; exit 2; }
      ;;
    *) echo "unknown selector: $selector"; exit 2;;
  esac

  for gpt_dir in "${gpts[@]}"; do
    for prompt_file in "${prompts[@]}"; do
      run_one "$gpt_dir" "$prompt_file" "$run_dir" || fails=$((fails+1))
    done
  done

  echo ""
  echo "=== Battery complete ==="
  echo "  Run dir:  $run_dir"
  echo "  Failures: $fails"
  [ "$fails" -gt 0 ] && exit 1
  exit 0
}

cmd="${1:-smoke}"
case "$cmd" in
  lint)   exec "$ROOT/test/lint.sh";;
  smoke)  require_claude; run_battery smoke;;
  all)    require_claude; run_battery all;;
  gpt)    require_claude; run_battery "gpt:${2:?usage: run.sh gpt <name>}";;
  case)   require_claude; run_battery "case:${2:?usage: run.sh case <NN>}";;
  assert)
    run_dir="${2:?usage: run.sh assert <run_dir>}"
    [ -d "$run_dir" ] || { echo "no such dir: $run_dir"; exit 2; }
    fails=0
    for txt in "$run_dir"/*/*.response.txt; do
      [ -f "$txt" ] || continue
      case_name=$(basename "$txt" .response.txt)
      case_id="${case_name%%-*}"
      exp="$ROOT/test/expectations/${case_id}.must-contain"
      [ -f "$exp" ] || continue
      echo ">>> $(basename "$(dirname "$txt")") :: $case_name"
      assert_contains_all "$txt" "$exp" "$case_name" || fails=$((fails+1))
    done
    echo "Failures: $fails"
    [ "$fails" -gt 0 ] && exit 1
    ;;
  *)
    echo "usage: $0 {lint|smoke|all|gpt <name>|case <NN>|assert <run_dir>}"
    exit 2
    ;;
esac
