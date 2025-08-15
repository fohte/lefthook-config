#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

teardown() {
    # Clean up temp directory
    rm -rf "$TEST_TEMP_DIR"
}

@test "removes trailing whitespace from lines" {
    # Copy fixture to temp
    cp "$PROJECT_ROOT/tests/fixtures/trailing-spaces.txt" "$TEST_TEMP_DIR/test.txt"

    # Run format-fix
    run format-fix.sh "$TEST_TEMP_DIR/test.txt"
    [ "$status" -eq 0 ]

    # Check trailing spaces are removed
    assert_no_trailing_spaces "$TEST_TEMP_DIR/test.txt"
}

@test "ensures file ends with single newline" {
    # Copy fixture to temp
    cp "$PROJECT_ROOT/tests/fixtures/no-final-newline.txt" "$TEST_TEMP_DIR/test.txt"

    # Run format-fix
    run format-fix.sh "$TEST_TEMP_DIR/test.txt"
    [ "$status" -eq 0 ]

    # Check file ends with newline
    assert_ends_with_newline "$TEST_TEMP_DIR/test.txt"
}

@test "removes multiple trailing newlines" {
    # Copy fixture to temp
    cp "$PROJECT_ROOT/tests/fixtures/multiple-trailing-newlines.txt" "$TEST_TEMP_DIR/test.txt"

    # Run format-fix
    run format-fix.sh "$TEST_TEMP_DIR/test.txt"
    [ "$status" -eq 0 ]

    # Check file ends with single newline
    assert_ends_with_newline "$TEST_TEMP_DIR/test.txt"

    # Check that there's only one newline at the end
    local last_two_chars
    last_two_chars=$(tail -c 2 "$TEST_TEMP_DIR/test.txt" | od -An -tx1)
    # Should not be two newlines (0a 0a)
    [[ ! "$last_two_chars" =~ "0a 0a" ]]
}

@test "does not modify already clean files" {
    # Copy fixture to temp
    cp "$PROJECT_ROOT/tests/fixtures/already-clean.txt" "$TEST_TEMP_DIR/test.txt"

    # Get original checksum
    local original_checksum
    original_checksum=$(shasum "$TEST_TEMP_DIR/test.txt")

    # Run format-fix
    run format-fix.sh "$TEST_TEMP_DIR/test.txt"
    [ "$status" -eq 0 ]

    # Check file unchanged
    local new_checksum
    new_checksum=$(shasum "$TEST_TEMP_DIR/test.txt")
    [ "$original_checksum" = "$new_checksum" ]
}

@test "handles multiple files" {
    # Copy fixtures to temp
    cp "$PROJECT_ROOT/tests/fixtures/trailing-spaces.txt" "$TEST_TEMP_DIR/file1.txt"
    cp "$PROJECT_ROOT/tests/fixtures/no-final-newline.txt" "$TEST_TEMP_DIR/file2.txt"

    # Run format-fix on multiple files
    run format-fix.sh "$TEST_TEMP_DIR/file1.txt" "$TEST_TEMP_DIR/file2.txt"
    [ "$status" -eq 0 ]

    # Check both files are fixed
    assert_no_trailing_spaces "$TEST_TEMP_DIR/file1.txt"
    assert_ends_with_newline "$TEST_TEMP_DIR/file1.txt"
    assert_no_trailing_spaces "$TEST_TEMP_DIR/file2.txt"
    assert_ends_with_newline "$TEST_TEMP_DIR/file2.txt"
}

@test "handles non-existent files gracefully" {
    # Run format-fix on non-existent file
    run format-fix.sh "$TEST_TEMP_DIR/non-existent.txt"
    [ "$status" -eq 0 ]  # Should still succeed (file is skipped)
}

@test "requires at least one argument" {
    # Run format-fix without arguments
    run format-fix.sh
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Usage:" ]]
}

@test "preserves file permissions" {
    # Create a file with specific permissions
    echo "test content  " > "$TEST_TEMP_DIR/test.txt"
    chmod 755 "$TEST_TEMP_DIR/test.txt"

    # Get original permissions
    local original_perms
    original_perms=$(stat -c %a "$TEST_TEMP_DIR/test.txt" 2>/dev/null || stat -f %A "$TEST_TEMP_DIR/test.txt")

    # Run format-fix
    run format-fix.sh "$TEST_TEMP_DIR/test.txt"
    [ "$status" -eq 0 ]

    # Check permissions unchanged
    local new_perms
    new_perms=$(stat -c %a "$TEST_TEMP_DIR/test.txt" 2>/dev/null || stat -f %A "$TEST_TEMP_DIR/test.txt")
    [ "$original_perms" = "$new_perms" ]
}

@test "handles empty files" {
    # Create empty file
    touch "$TEST_TEMP_DIR/empty.txt"

    # Run format-fix
    run format-fix.sh "$TEST_TEMP_DIR/empty.txt"
    [ "$status" -eq 0 ]

    # File should still be empty
    [ ! -s "$TEST_TEMP_DIR/empty.txt" ]
}

@test "handles files with only whitespace" {
    # Create file with only spaces and tabs
    printf "   \t\t   \n\n\t\n" > "$TEST_TEMP_DIR/whitespace.txt"

    # Run format-fix
    run format-fix.sh "$TEST_TEMP_DIR/whitespace.txt"
    [ "$status" -eq 0 ]

    # File should be empty now
    [ ! -s "$TEST_TEMP_DIR/whitespace.txt" ]
}

@test "ignores files matching --ignore pattern" {
    # Create test files with trailing spaces
    mkdir -p "$TEST_TEMP_DIR/fixtures"
    printf "line with spaces  \n" > "$TEST_TEMP_DIR/fixtures/ignored.txt"
    printf "line with spaces  \n" > "$TEST_TEMP_DIR/processed.txt"

    # Run format-fix with ignore pattern
    run format-fix.sh --ignore "$TEST_TEMP_DIR/fixtures/**" "$TEST_TEMP_DIR/fixtures/ignored.txt" "$TEST_TEMP_DIR/processed.txt"
    [ "$status" -eq 0 ]

    # Check that ignored file still has trailing spaces
    grep -q "  $" "$TEST_TEMP_DIR/fixtures/ignored.txt"

    # Check that processed file has no trailing spaces
    ! grep -q "  $" "$TEST_TEMP_DIR/processed.txt"
}

@test "handles --ignore with no matching files" {
    # Create test file
    printf "line with spaces  \n" > "$TEST_TEMP_DIR/test.txt"

    # Run format-fix with ignore pattern that doesn't match
    run format-fix.sh --ignore "nonexistent/**" "$TEST_TEMP_DIR/test.txt"
    [ "$status" -eq 0 ]

    # Check that file was processed (no trailing spaces)
    ! grep -q "  $" "$TEST_TEMP_DIR/test.txt"
}

@test "requires pattern argument for --ignore option" {
    # Run format-fix with --ignore but no pattern
    run format-fix.sh --ignore
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Error: --ignore requires a pattern argument" ]]
}

@test "supports comma-separated ignore patterns" {
    # Create test files with different extensions
    mkdir -p "$TEST_TEMP_DIR/src"
    printf "line with spaces  \n" > "$TEST_TEMP_DIR/src/file.js"
    printf "line with spaces  \n" > "$TEST_TEMP_DIR/src/file.ts"
    printf "line with spaces  \n" > "$TEST_TEMP_DIR/src/file.py"

    # Run format-fix with comma-separated ignore patterns
    run format-fix.sh --ignore "$TEST_TEMP_DIR/src/*.js,$TEST_TEMP_DIR/src/*.ts" \
        "$TEST_TEMP_DIR/src/file.js" "$TEST_TEMP_DIR/src/file.ts" "$TEST_TEMP_DIR/src/file.py"
    [ "$status" -eq 0 ]

    # Check that .js and .ts files still have trailing spaces (ignored)
    grep -q "  $" "$TEST_TEMP_DIR/src/file.js"
    grep -q "  $" "$TEST_TEMP_DIR/src/file.ts"

    # Check that .py file has no trailing spaces (processed)
    ! grep -q "  $" "$TEST_TEMP_DIR/src/file.py"
}

@test "handles comma-separated patterns with spaces" {
    # Create test files
    mkdir -p "$TEST_TEMP_DIR/test"
    printf "line with spaces  \n" > "$TEST_TEMP_DIR/test/file1.txt"
    printf "line with spaces  \n" > "$TEST_TEMP_DIR/test/file2.txt"
    printf "line with spaces  \n" > "$TEST_TEMP_DIR/test/file3.txt"

    # Run format-fix with comma-separated patterns with spaces
    run format-fix.sh --ignore "$TEST_TEMP_DIR/test/file1.txt , $TEST_TEMP_DIR/test/file2.txt" \
        "$TEST_TEMP_DIR/test/file1.txt" "$TEST_TEMP_DIR/test/file2.txt" "$TEST_TEMP_DIR/test/file3.txt"
    [ "$status" -eq 0 ]

    # Check that file1.txt and file2.txt still have trailing spaces (ignored)
    grep -q "  $" "$TEST_TEMP_DIR/test/file1.txt"
    grep -q "  $" "$TEST_TEMP_DIR/test/file2.txt"

    # Check that file3.txt has no trailing spaces (processed)
    ! grep -q "  $" "$TEST_TEMP_DIR/test/file3.txt"
}
