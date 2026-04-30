#!/usr/bin/env bash
# Assertion helpers for response checking.
#
# Each helper writes pass/fail lines to stdout and returns 0 (pass) or 1 (fail).

set -euo pipefail

# assert_contains_all <response_file> <expectations_file>
#   Reads expectations_file line-by-line; each line is a substring (case-insensitive)
#   that must appear in response_file. Empty lines and lines starting with # are skipped.
assert_contains_all() {
  local resp="$1"
  local exp="$2"
  local label="${3:-}"
  local fails=0
  local total=0

  while IFS= read -r pat; do
    [ -z "$pat" ] && continue
    case "$pat" in \#*) continue;; esac
    total=$((total + 1))
    if grep -iqF -- "$pat" "$resp"; then
      printf "    PASS  contains %q\n" "$pat"
    else
      printf "    FAIL  missing  %q\n" "$pat"
      fails=$((fails + 1))
    fi
  done < "$exp"

  if [ "$fails" -gt 0 ]; then
    printf "  %s: %d of %d patterns missing\n" "${label:-assert}" "$fails" "$total"
    return 1
  fi
  printf "  %s: all %d patterns present\n" "${label:-assert}" "$total"
  return 0
}

# extract_text <claude_json_output_file>
#   Pulls the assistant's text response out of `claude -p --output-format json` output.
extract_text() {
  local f="$1"
  if command -v jq >/dev/null 2>&1; then
    jq -r '.result // .text // (.messages // [])[-1].content // .' "$f" 2>/dev/null || cat "$f"
  else
    # No jq: best-effort grep for the "result" string field
    python3 -c '
import json, sys
try:
  d = json.load(open(sys.argv[1]))
  print(d.get("result") or d.get("text") or "")
except Exception:
  print(open(sys.argv[1]).read())
' "$f"
  fi
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  case "${1:-}" in
    contains) assert_contains_all "$2" "$3" "${4:-}";;
    extract)  extract_text "$2";;
    *) echo "usage: $0 contains <response> <expectations> [label]"; echo "       $0 extract <claude.json>"; exit 2;;
  esac
fi
