# fohte/lefthook-config

[@fohte](https://github.com/fohte)'s shared Lefthook configuration.

## Usage

1. Install lefthook globally:

```bash
mise use -g lefthook --pin
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

## Available Hooks

### `base.yml`

#### `pre-commit`

| Hook         | Description                                      | Requirements                   |
| ------------ | ------------------------------------------------ | ------------------------------ |
| `format`     | Remove trailing whitespace, ensure final newline | `basefmt` (mise)               |
| `prettier`   | Auto-format with Prettier                        | `prettier` (bun/pnpm/npm/mise) |
| `shellcheck` | Lint shell scripts                               | `shellcheck` (mise)            |
| `shfmt`      | Format shell scripts                             | `shfmt` (mise)                 |
