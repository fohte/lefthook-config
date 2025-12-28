# fohte/lefthook-config

[![GitHub Release](https://img.shields.io/github/v/release/fohte/lefthook-config)](https://github.com/fohte/lefthook-config/releases/latest)
[![CI](https://img.shields.io/github/actions/workflow/status/fohte/lefthook-config/test.yml?branch=master)](https://github.com/fohte/lefthook-config/actions/workflows/test.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

[@fohte](https://github.com/fohte)'s shared [Lefthook](https://github.com/evilmartians/lefthook) configuration.

## Usage

1. Install lefthook:

   **Option A: Per-repository (recommended for projects already using mise)**

   ```bash
   mise use --pin lefthook
   ```

   **Option B: Global**

   ```bash
   # Using mise
   mise use -g --pin lefthook

   # Using Homebrew
   brew install lefthook

   # Using npm
   npm install -g lefthook
   ```

2. Create `lefthook.yml` in your repository:

   ```yaml
   remotes:
     - git_url: https://github.com/fohte/lefthook-config
       ref: v0.1.8
       configs:
         - base.yml
   ```

3. Install git hooks:

   ```bash
   lefthook install
   ```

## Available Hooks

### `base.yml`

Language-agnostic hooks that can be used across any project regardless of programming language.

#### `pre-commit`

| Hook         | Description                                      | Requirements                                             |
| ------------ | ------------------------------------------------ | -------------------------------------------------------- |
| `format`     | Remove trailing whitespace, ensure final newline | [basefmt](https://github.com/fohte/basefmt) (mise)       |
| `prettier`   | Auto-format with Prettier                        | [Prettier](https://prettier.io/) (bun/pnpm/npm/mise)     |
| `shellcheck` | Lint shell scripts                               | [ShellCheck](https://www.shellcheck.net/) (mise)         |
| `shfmt`      | Format shell scripts                             | [shfmt](https://github.com/mvdan/sh) (mise)              |
| `actionlint` | Lint GitHub Actions workflow files               | [actionlint](https://github.com/rhysd/actionlint) (mise) |
