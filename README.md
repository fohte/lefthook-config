# fohte/lefthook-config

Minimal lefthook configuration for code formatting.

## Usage

```yaml
# lefthook.yml
remotes:
  - git_url: https://github.com/fohte/lefthook-config
    configs:
      - base.yml
```

## What it does

- Removes trailing whitespace from lines
- Ensures files end with a newline
- Runs automatically on `git commit`
- Skips binary files (images, fonts, etc.)

## Requirements

- Bash
- Git
