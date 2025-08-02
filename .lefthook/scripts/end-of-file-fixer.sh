#!/usr/bin/env bash
# end-of-file-fixer.sh
# Ensures all text files end with a newline character

set -e

# Exit early if no files provided
if [ $# -eq 0 ]; then
    exit 0
fi

fixed_files=()

for file in "$@"; do
    # Skip if file doesn't exist
    if [ ! -f "$file" ]; then
        continue
    fi

    # Skip binary files
    if file --mime "$file" | grep -q "charset=binary"; then
        continue
    fi

    # Check if file ends with newline
    if [ -s "$file" ] && [ "$(tail -c 1 "$file" | wc -l)" -eq 0 ]; then
        # Add newline to end of file
        echo >> "$file"
        fixed_files+=("$file")
    fi
done

# If any files were fixed, stage them
if [ ${#fixed_files[@]} -gt 0 ]; then
    git add "${fixed_files[@]}"
    echo "Fixed missing newline at end of file in: ${fixed_files[*]}"
fi

exit 0
