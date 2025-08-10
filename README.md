# fohte/lefthook-config

[@fohte](https://github.com/fohte)'s shared Lefthook configuration.

## Usage

1. Install lefthook globally:
```bash
# Using mise (global)
mise use -g lefthook --pin

# or using Homebrew
brew install lefthook

# or using npm
npm install -g lefthook
```

2. Create `lefthook.yml` in your repository:
```yaml
remotes:
  - git_url: https://github.com/fohte/lefthook-config
    configs:
      - base.yml
```

3. Install git hooks:
```bash
lefthook install
```

## What it does

- Removes trailing whitespace from lines
- Ensures files end with a newline
- Runs automatically on `git commit`
- Skips binary files (images, fonts, etc.)
