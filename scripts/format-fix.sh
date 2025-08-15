#!/usr/bin/env bash
# Simple formatting script
# - Removes trailing whitespace from lines
# - Ensures files end with exactly one newline

set -euo pipefail

# Enable extended globbing for pattern matching
shopt -s extglob
# Enable ** to match zero or more directories
shopt -s globstar

# Global variable for ignore pattern
IGNORE_PATTERN=""

# Check if file matches ignore pattern
should_ignore() {
  local file="$1"

  # If no ignore pattern, don't ignore
  if [ -z "$IGNORE_PATTERN" ]; then
    return 1
  fi

  # Check if file matches the glob pattern
  # Using bash's [[ ]] with == for pattern matching with globstar enabled
  if [[ "$file" == $IGNORE_PATTERN ]]; then
    return 0
  fi

  return 1
}

# Process a single file
process_file() {
  local file="$1"

  # Skip if file doesn't exist (e.g., it was deleted in the commit)
  if [ ! -f "$file" ]; then
    return 0
  fi

  # Skip if file matches ignore pattern
  if should_ignore "$file"; then
    return 0
  fi

  # Create temporary file and ensure it's cleaned up
  local temp_file
  temp_file=$(mktemp)
  # shellcheck disable=SC2064 # We want $temp_file expanded now, not when trap executes
  trap "rm -f '$temp_file'" RETURN

  # Remove trailing whitespace and normalize to single trailing newline
  if ! awk '
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
  ' "$file" > "$temp_file"; then
    echo "ERROR: awk failed to process '$file'" >&2
    return 1
  fi

  # Only write back to original file if content has changed
  if ! cmp -s "$file" "$temp_file"; then
    cat "$temp_file" > "$file"
  fi
}

# Main
main() {
  local files=()

  # Parse command line arguments
  while [ $# -gt 0 ]; do
    case "$1" in
      --ignore)
        if [ $# -lt 2 ]; then
          echo "Error: --ignore requires a pattern argument" >&2
          exit 1
        fi
        IGNORE_PATTERN="$2"
        shift 2
        ;;
      -*)
        echo "Unknown option: $1" >&2
        echo "Usage: $0 [--ignore PATTERN] FILE..."
        echo "Fix formatting: remove trailing whitespace and ensure final newline"
        exit 1
        ;;
      *)
        files+=("$1")
        shift
        ;;
    esac
  done

  # Check if we have files to process
  if [ ${#files[@]} -eq 0 ]; then
    echo "Usage: $0 [--ignore PATTERN] FILE..."
    echo "Fix formatting: remove trailing whitespace and ensure final newline"
    echo ""
    echo "Options:"
    echo "  --ignore PATTERN    Glob pattern for files to ignore (e.g., 'tests/fixtures/**')"
    exit 1
  fi

  # Process each file
  for file in "${files[@]}"; do
    process_file "$file"
  done
}

main "$@"
