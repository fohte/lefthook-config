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

## Available configurations

### base.yml
- **pre-commit/format**: Automatic code formatting
  - Removes trailing whitespace
  - Ensures final newline
  - Excludes: `*.{png,jpg,jpeg,gif,ico,pdf,svg,woff,woff2,ttf,eot}`
