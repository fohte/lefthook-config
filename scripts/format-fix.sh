#!/usr/bin/env bash
# Simple formatting script
# - Removes trailing whitespace from lines
# - Ensures files end with exactly one newline

set -euo pipefail

# Process a single file
process_file() {
  local file="$1"

  # Skip if file doesn't exist
  if [ ! -f "$file" ]; then
    echo "ERROR: File not found: $file" >&2
    return 1
  fi

  # Create temporary file
  temp_file=$(mktemp)

  # Remove trailing whitespace and normalize to single trailing newline
  # awk is more portable and handles this cleanly
  awk '
    { sub(/[[:space:]]+$/, ""); lines[NR] = $0 }
    END {
      # Find last non-empty line
      for (i = NR; i > 0; i--) {
        if (lines[i] != "") {
          last = i
          break
        }
      }
      # Print all lines up to last non-empty
      for (i = 1; i <= last; i++) {
        print lines[i]
      }
    }
  ' "$file" > "$temp_file" && mv "$temp_file" "$file"
}

# Main
main() {
  if [ $# -eq 0 ]; then
    echo "Usage: $0 FILE..."
    echo "Fix formatting: remove trailing whitespace and ensure final newline"
    exit 1
  fi

  for file in "$@"; do
    process_file "$file"
  done
}

main "$@"
