# fohte/lefthook-config

[@fohte](https://github.com/fohte)'s Lefthook configuration for consistent code quality across repositories.

## Usage

Add the following to your `lefthook.yml`:

```yaml
remotes:
  - git_url: https://github.com/fohte/lefthook-config
    configs:
      - base.yml
```

## Available Hooks

### base.yml

Language-agnostic hooks for basic code quality:

- **format**: Simple formatting fixes
  - Removes trailing whitespace from all lines
  - Ensures files end with a newline
  - Pure POSIX shell script (no dependencies)
  - Automatically skips binary files

## Why This Approach?

This minimal approach focuses on the most common and universally applicable formatting rules:

1. **Trailing whitespace removal** - Trailing spaces are almost never intentional and can cause issues with diffs
2. **Final newline** - POSIX standard requires text files to end with a newline

Unlike full EditorConfig implementations, this approach:
- **No configuration needed** - Works the same for all files
- **No runtime dependencies** - Just POSIX shell
- **Fast** - Simple sed operations, no parsing required
- **Predictable** - Same behavior across all projects

## Manual Testing

```bash
# Test the script directly
./scripts/format-fix.sh file1.txt file2.js

# Check what would be changed
diff file.txt <(./scripts/format-fix.sh file.txt && cat file.txt)
```

## Customization

To skip this hook locally, use `lefthook-local.yml`:

```yaml
pre-commit:
  commands:
    format:
      skip: true  # Skip formatting
```
