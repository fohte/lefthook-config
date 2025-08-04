# Lefthook Common Configuration

Common Lefthook configuration for consistent code quality across repositories.

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
  - Ensures files end with a newline (`insert_final_newline`)
  - Removes trailing whitespace (`trim_trailing_whitespace`)
  - Preserves line-break spaces in Markdown files

## Requirements

This configuration uses `bunx` to automatically run `eclint`.
Bun must be installed on your system. You can find installation instructions [here](https://bun.sh/docs/installation).

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
