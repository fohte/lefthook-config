#!/usr/bin/env bash
# trailing-whitespace.sh
# Removes trailing whitespace from files
# Preserves markdown line breaks (two spaces at end of line) if MARKDOWN_LINEBREAK_EXT is set

set -e

# Exit early if no files provided
if [ $# -eq 0 ]; then
    exit 0
fi

# Get markdown extensions from environment variable
# Default to empty if not set
markdown_exts="${MARKDOWN_LINEBREAK_EXT:-}"

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
    
    # Get file extension
    ext="${file##*.}"
    
    # Check if this is a markdown file that should preserve line breaks
    preserve_linebreaks=false
    if [ -n "$markdown_exts" ]; then
        IFS=',' read -ra EXTS <<< "$markdown_exts"
        for markdown_ext in "${EXTS[@]}"; do
            if [ "$ext" = "$markdown_ext" ]; then
                preserve_linebreaks=true
                break
            fi
        done
    fi
    
    # Create temp file
    temp_file=$(mktemp)
    
    # Remove trailing whitespace
    if [ "$preserve_linebreaks" = true ]; then
        # For markdown files: preserve two spaces at end of line, remove other trailing whitespace
        sed -E 's/([^ ]|  ) +$/\1/g' "$file" > "$temp_file"
    else
        # For other files: remove all trailing whitespace
        sed 's/[[:space:]]*$//' "$file" > "$temp_file"
    fi
    
    # Check if file was modified
    if ! cmp -s "$file" "$temp_file"; then
        mv "$temp_file" "$file"
        fixed_files+=("$file")
    else
        rm "$temp_file"
    fi
done

# If any files were fixed, stage them
if [ ${#fixed_files[@]} -gt 0 ]; then
    git add "${fixed_files[@]}"
    echo "Removed trailing whitespace from: ${fixed_files[*]}"
fi

exit 0