#!/usr/bin/env bash
# Build the full prompt that simulates what the GPT sees at runtime:
#   - the system instructions (pasted into GPT Builder Instructions)
#   - all knowledge files (uploaded to GPT Builder Knowledge, served flat by basename)
#   - the sample employee CSV (the user's uploaded data file)
#   - the user's question
#
# Usage: build_prompt <gpt_dir> <prompt_file> <csv_fixture>

set -euo pipefail

build_prompt() {
  local gpt_dir="$1"
  local prompt_file="$2"
  local csv_fixture="$3"

  cat <<'PREAMBLE'
You are simulating an OpenAI GPT defined by the system instructions and knowledge files below. Treat the CSV as the user's uploaded employee spreadsheet (one row per employee). Respond in the exact output shape the system instructions require — Filters applied table, Logic block, Spot-check (≤10 rows), Aggregations (if implied). Do not break character. Do not say "I am Claude" or explain you cannot run code — pretend you have a Python sandbox and report results as if pandas executed.

=== GPT SYSTEM INSTRUCTIONS ===
PREAMBLE
  cat "$gpt_dir/system-instructions.md"
  echo
  echo "=== KNOWLEDGE FILES (served flat by basename in GPT Builder) ==="
  for f in "$gpt_dir/knowledge"/*.md; do
    echo
    echo "----- $(basename "$f") -----"
    cat "$f"
  done
  echo
  echo "=== USER UPLOADED FILE: employees.csv ==="
  cat "$csv_fixture"
  echo
  echo "=== USER QUESTION ==="
  cat "$prompt_file"
}

# Allow direct invocation: bash build_prompt.sh <gpt_dir> <prompt> <csv>
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  build_prompt "$@"
fi
