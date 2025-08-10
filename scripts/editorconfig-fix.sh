#!/bin/sh
# POSIX-compliant EditorConfig implementation
# Replaces eclint dependency with pure shell script

set -e

# Default values
DEBUG="${DEBUG:-false}"
DRY_RUN="${DRY_RUN:-false}"

# Print debug messages
debug() {
  [ "$DEBUG" = "true" ] && echo "DEBUG: $*" >&2
}

# Print error messages
error() {
  echo "ERROR: $*" >&2
}

# Find all .editorconfig files from current directory to root
find_editorconfig_files() {
  local dir="$1"
  local configs=""
  
  while true; do
    if [ -f "$dir/.editorconfig" ]; then
      configs="$dir/.editorconfig $configs"
      
      # Check if this is root = true
      if grep -q "^root[[:space:]]*=[[:space:]]*true" "$dir/.editorconfig" 2>/dev/null; then
        break
      fi
    fi
    
    # Reached filesystem root
    if [ "$dir" = "/" ] || [ "$dir" = "." ]; then
      break
    fi
    
    # Go up one directory
    dir=$(dirname "$dir")
  done
  
  echo "$configs"
}

# Parse .editorconfig and get settings for a file
get_file_settings() {
  local file="$1"
  local config_files="$2"
  
  # Initialize settings
  local indent_style=""
  local indent_size=""
  local end_of_line=""
  local charset=""
  local trim_trailing_whitespace=""
  local insert_final_newline=""
  local max_line_length=""
  
  # Process each config file
  for config in $config_files; do
    debug "Processing config: $config"
    
    # Read config file line by line
    local current_section=""
    while IFS= read -r line || [ -n "$line" ]; do
      # Skip comments and empty lines
      case "$line" in
        "#"*|";"*|"") continue ;;
      esac
      
      # Check for section header
      if echo "$line" | grep -q '^\[.*\]$'; then
        current_section=$(echo "$line" | sed 's/^\[\(.*\)\]$/\1/')
        debug "Found section: $current_section"
        continue
      fi
      
      # Skip if no section defined yet
      [ -z "$current_section" ] && continue
      
      # Check if current file matches the section pattern
      if ! file_matches_pattern "$file" "$current_section"; then
        continue
      fi
      
      # Parse property
      local key=$(echo "$line" | cut -d= -f1 | sed 's/[[:space:]]*$//' | sed 's/^[[:space:]]*//')
      local value=$(echo "$line" | cut -d= -f2- | sed 's/[[:space:]]*$//' | sed 's/^[[:space:]]*//')
      
      case "$key" in
        indent_style) indent_style="$value" ;;
        indent_size) indent_size="$value" ;;
        end_of_line|eol) end_of_line="$value" ;;
        charset) charset="$value" ;;
        trim_trailing_whitespace) trim_trailing_whitespace="$value" ;;
        insert_final_newline) insert_final_newline="$value" ;;
        max_line_length) max_line_length="$value" ;;
      esac
    done < "$config"
  done
  
  # Output settings
  echo "indent_style=$indent_style"
  echo "indent_size=$indent_size"
  echo "end_of_line=$end_of_line"
  echo "charset=$charset"
  echo "trim_trailing_whitespace=$trim_trailing_whitespace"
  echo "insert_final_newline=$insert_final_newline"
  echo "max_line_length=$max_line_length"
}

# Check if a file matches a glob pattern
file_matches_pattern() {
  local file="$1"
  local pattern="$2"
  
  # Get just the filename for matching
  local filename=$(basename "$file")
  
  # Handle special case of * matching everything
  if [ "$pattern" = "*" ]; then
    return 0
  fi
  
  # Convert glob pattern to shell pattern
  # Support basic patterns like *.md, *.{md,mdx}, etc.
  case "$pattern" in
    "*")
      return 0
      ;;
    "*.md{,x}")
      case "$filename" in
        *.md|*.mdx) return 0 ;;
        *) return 1 ;;
      esac
      ;;
    "*.md")
      case "$filename" in
        *.md) return 0 ;;
        *) return 1 ;;
      esac
      ;;
    *)
      # Generic pattern matching using case
      case "$filename" in
        $pattern) return 0 ;;
        *) return 1 ;;
      esac
      ;;
  esac
}

# Apply trim_trailing_whitespace
apply_trim_trailing_whitespace() {
  local file="$1"
  local value="$2"
  
  if [ "$value" = "true" ]; then
    debug "Trimming trailing whitespace from $file"
    if [ "$DRY_RUN" = "true" ]; then
      echo "Would trim trailing whitespace from $file"
    else
      # Use sed to remove trailing whitespace
      sed -i.bak 's/[[:space:]]*$//' "$file" && rm -f "$file.bak"
    fi
  fi
}

# Apply insert_final_newline
apply_insert_final_newline() {
  local file="$1"
  local value="$2"
  
  if [ "$value" = "true" ]; then
    debug "Ensuring final newline in $file"
    if [ "$DRY_RUN" = "true" ]; then
      echo "Would ensure final newline in $file"
    else
      # Check if file ends with newline
      if [ -s "$file" ] && [ "$(tail -c1 "$file" | wc -l)" -eq 0 ]; then
        echo "" >> "$file"
      fi
    fi
  elif [ "$value" = "false" ]; then
    debug "Removing final newline from $file"
    if [ "$DRY_RUN" = "true" ]; then
      echo "Would remove final newline from $file"
    else
      # Remove final newline if present
      if [ -s "$file" ] && [ "$(tail -c1 "$file" | wc -l)" -eq 1 ]; then
        # Use perl if available, otherwise use a temporary file
        if command -v perl >/dev/null 2>&1; then
          perl -pi -e 'chomp if eof' "$file"
        else
          # Fallback method using temporary file
          head -c -1 "$file" > "$file.tmp" && mv "$file.tmp" "$file"
        fi
      fi
    fi
  fi
}

# Apply end_of_line conversion
apply_end_of_line() {
  local file="$1"
  local value="$2"
  
  case "$value" in
    lf)
      debug "Converting line endings to LF in $file"
      if [ "$DRY_RUN" = "true" ]; then
        echo "Would convert line endings to LF in $file"
      else
        # Convert CRLF to LF
        sed -i.bak 's/\r$//' "$file" && rm -f "$file.bak"
      fi
      ;;
    crlf)
      debug "Converting line endings to CRLF in $file"
      if [ "$DRY_RUN" = "true" ]; then
        echo "Would convert line endings to CRLF in $file"
      else
        # Convert LF to CRLF
        sed -i.bak 's/$/\r/' "$file" && rm -f "$file.bak"
      fi
      ;;
    cr)
      debug "Converting line endings to CR in $file"
      if [ "$DRY_RUN" = "true" ]; then
        echo "Would convert line endings to CR in $file"
      else
        # Convert to CR (rare, but supported)
        tr '\n' '\r' < "$file" > "$file.tmp" && mv "$file.tmp" "$file"
      fi
      ;;
  esac
}

# Apply indent conversion
apply_indent_style() {
  local file="$1"
  local style="$2"
  local size="${3:-4}"
  
  if [ -z "$style" ]; then
    return
  fi
  
  case "$style" in
    space)
      debug "Converting indentation to spaces in $file"
      if [ "$DRY_RUN" = "true" ]; then
        echo "Would convert indentation to spaces (size=$size) in $file"
      else
        # Convert tabs to spaces
        local spaces=""
        local i=0
        while [ $i -lt "$size" ]; do
          spaces="$spaces "
          i=$((i + 1))
        done
        sed -i.bak "s/	/$spaces/g" "$file" && rm -f "$file.bak"
      fi
      ;;
    tab)
      debug "Converting indentation to tabs in $file"
      if [ "$DRY_RUN" = "true" ]; then
        echo "Would convert indentation to tabs in $file"
      else
        # Convert leading spaces to tabs (assumes spaces in groups of size)
        local spaces=""
        local i=0
        while [ $i -lt "$size" ]; do
          spaces="$spaces "
          i=$((i + 1))
        done
        sed -i.bak "s/^$spaces/	/g" "$file" && rm -f "$file.bak"
      fi
      ;;
  esac
}

# Process a single file
process_file() {
  local file="$1"
  
  # Skip if file doesn't exist
  if [ ! -f "$file" ]; then
    error "File not found: $file"
    return 1
  fi
  
  debug "Processing file: $file"
  
  # Get the directory of the file
  local file_dir=$(dirname "$file")
  
  # Find all applicable .editorconfig files
  local config_files=$(find_editorconfig_files "$file_dir")
  
  if [ -z "$config_files" ]; then
    debug "No .editorconfig files found for $file"
    return 0
  fi
  
  # Get settings for this file
  local settings=$(get_file_settings "$file" "$config_files")
  
  # Parse settings
  eval "$settings"
  
  # Apply each setting
  [ -n "$trim_trailing_whitespace" ] && apply_trim_trailing_whitespace "$file" "$trim_trailing_whitespace"
  [ -n "$end_of_line" ] && apply_end_of_line "$file" "$end_of_line"
  [ -n "$indent_style" ] && apply_indent_style "$file" "$indent_style" "$indent_size"
  [ -n "$insert_final_newline" ] && apply_insert_final_newline "$file" "$insert_final_newline"
  
  debug "Finished processing $file"
}

# Show usage
usage() {
  cat <<EOF
Usage: $0 [OPTIONS] FILE...

Apply EditorConfig settings to files.

Options:
  -h, --help      Show this help message
  -d, --debug     Enable debug output
  -n, --dry-run   Show what would be done without making changes
  
Environment variables:
  DEBUG=true      Enable debug output
  DRY_RUN=true    Dry run mode

Examples:
  $0 file1.txt file2.js
  $0 --dry-run *.md
  DEBUG=true $0 src/*.js
EOF
}

# Main
main() {
  local files_processed=0
  
  # Parse command line arguments
  while [ $# -gt 0 ]; do
    case "$1" in
      -h|--help)
        usage
        exit 0
        ;;
      -d|--debug)
        DEBUG=true
        shift
        ;;
      -n|--dry-run)
        DRY_RUN=true
        shift
        ;;
      -*)
        error "Unknown option: $1"
        usage
        exit 1
        ;;
      *)
        # Process file
        process_file "$1"
        files_processed=$((files_processed + 1))
        shift
        ;;
    esac
  done
  
  # If no files provided, show usage
  if [ $files_processed -eq 0 ]; then
    usage
    exit 1
  fi
}

# Run main if not sourced
if [ "${0##*/}" = "editorconfig-fix.sh" ]; then
  main "$@"
fi