#!/usr/bin/env bash

# Common setup for all tests
_common_setup() {
    # Get the project root directory
    PROJECT_ROOT="$( cd "$( dirname "$BATS_TEST_FILENAME" )/.." >/dev/null 2>&1 && pwd )"

    # Make scripts visible to PATH
    PATH="$PROJECT_ROOT/scripts:$PATH"

    # Create temp directory for test files
    TEST_TEMP_DIR="$(mktemp -d)"

    # Export for use in tests
    export PROJECT_ROOT
    export TEST_TEMP_DIR
}

# Simple assertion helpers (instead of using bats-assert)
assert_file_exists() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        echo "Expected file to exist: $file" >&2
        return 1
    fi
}

assert_file_contains() {
    local file="$1"
    local pattern="$2"
    if ! grep -q "$pattern" "$file"; then
        echo "Expected file $file to contain: $pattern" >&2
        echo "Actual content:" >&2
        cat "$file" >&2
        return 1
    fi
}

assert_no_trailing_spaces() {
    local file="$1"
    if grep -q "[[:space:]]$" "$file"; then
        echo "File has trailing spaces: $file" >&2
        grep -n "[[:space:]]$" "$file" >&2
        return 1
    fi
}

assert_ends_with_newline() {
    local file="$1"
    if [ "$(tail -c 1 "$file" | wc -l)" -ne 1 ]; then
        echo "File does not end with newline: $file" >&2
        return 1
    fi
}
