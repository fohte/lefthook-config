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

- **editorconfig**: Fixes files according to `.editorconfig` settings
  - Uses a pure POSIX shell script implementation (no external dependencies)
  - Ensures files end with a newline (`insert_final_newline`)
  - Removes trailing whitespace (`trim_trailing_whitespace`)
  - Converts line endings (`end_of_line`)
  - Converts indentation style (`indent_style`, `indent_size`)
  - Preserves line-break spaces in Markdown files

## EditorConfig Implementation

This configuration uses a **pure shell script** implementation of EditorConfig, eliminating the need for Node.js, Bun, or any other runtime dependencies.

### Features

- **Zero dependencies**: Works with just POSIX shell (sh)
- **Automatic download**: Script is downloaded on first use if not present
- **Full EditorConfig support**: 
  - `trim_trailing_whitespace`
  - `insert_final_newline`
  - `end_of_line` (lf, crlf, cr)
  - `indent_style` (space, tab)
  - `indent_size`
  - Pattern matching for file-specific rules

### Manual Installation

If you prefer to include the script in your repository:

```bash
mkdir -p scripts
curl -o scripts/editorconfig-fix.sh \
  https://raw.githubusercontent.com/fohte/lefthook-config/main/scripts/editorconfig-fix.sh
chmod +x scripts/editorconfig-fix.sh
```

### Testing the Script

You can test the script manually:

```bash
# Apply EditorConfig settings to specific files
./scripts/editorconfig-fix.sh file1.txt file2.js

# Dry run mode (show what would be changed)
./scripts/editorconfig-fix.sh --dry-run file.txt

# Debug mode (verbose output)
DEBUG=true ./scripts/editorconfig-fix.sh file.txt
```

## EditorConfig Setup

Each repository needs an `.editorconfig` file.
See this repository's [`.editorconfig`](./.editorconfig) for an example.

## Customization

To override settings locally, use `lefthook-local.yml`:

```yaml
pre-commit:
  commands:
    editorconfig:
      skip: true  # Skip this hook
```

## Why Shell Script?

Unlike the original `eclint` implementation that requires Node.js/Bun, this pure shell script approach:

- **Works everywhere**: No need to install language runtimes
- **Fast startup**: No runtime initialization overhead
- **Minimal footprint**: Single ~400 line shell script
- **Easy to audit**: Readable POSIX shell code
- **Self-contained**: Can be embedded directly in your project