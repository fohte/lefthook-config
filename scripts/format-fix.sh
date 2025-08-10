#!/usr/bin/env bash
# Simple formatting script
# - Removes trailing whitespace from lines
# - Ensures files end with a single newline

set -euo pipefail

# Process a single file
process_file() {
  local file="$1"

  # Skip if file doesn't exist
  if [ ! -f "$file" ]; then
    echo "ERROR: File not found: $file" >&2
    return 1
  fi

  # Remove trailing whitespace from all lines
  sed -i.bak 's/[[:space:]]*$//' "$file" && rm -f "$file.bak"

  # Ensure file ends with exactly one newline
  if [ -s "$file" ]; then
    # Add newline if file doesn't end with one
    if [ "$(tail -c1 "$file" | wc -l)" -eq 0 ]; then
      echo "" >> "$file"
    fi
  fi
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
