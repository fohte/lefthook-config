#!/bin/sh
# Simple POSIX-compliant script to fix common formatting issues
# - Removes trailing whitespace from lines
# - Ensures files end with a single newline

set -e

# Process a single file
process_file() {
  local file="$1"

  # Skip if file doesn't exist
  if [ ! -f "$file" ]; then
    echo "ERROR: File not found: $file" >&2
    return 1
  fi

  # Skip binary files and specific extensions
  case "$file" in
    *.png|*.jpg|*.jpeg|*.gif|*.ico|*.pdf|*.svg|*.woff|*.woff2|*.ttf|*.eot)
      return 0
      ;;
  esac

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
