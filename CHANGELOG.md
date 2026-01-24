# Changelog

## [0.1.13](https://github.com/fohte/lefthook-config/compare/v0.1.12...v0.1.13) (2026-01-24)


### Bug Fixes

* **pre-commit/rust:** run clippy on test code ([#47](https://github.com/fohte/lefthook-config/issues/47)) ([7dc7bd3](https://github.com/fohte/lefthook-config/commit/7dc7bd3bbf8a6b76dc28f6fb7ef2b4114fa97e64))

## [0.1.12](https://github.com/fohte/lefthook-config/compare/v0.1.11...v0.1.12) (2026-01-21)


### Features

* **pre-commit:** extract pre-commit hooks for Rust to rust.yml ([#45](https://github.com/fohte/lefthook-config/issues/45)) ([a4f1047](https://github.com/fohte/lefthook-config/commit/a4f10477d3e0ac9daa1217ae1360d5f97713b243))

## [0.1.11](https://github.com/fohte/lefthook-config/compare/v0.1.10...v0.1.11) (2026-01-01)


### Features

* adopt generic-boilerplate via Copier ([#33](https://github.com/fohte/lefthook-config/issues/33)) ([2df4d1e](https://github.com/fohte/lefthook-config/commit/2df4d1e504a072b38efd5424db773588cc769874))
* **pre-commit:** add hooks for Rust ([#40](https://github.com/fohte/lefthook-config/issues/40)) ([e506a0c](https://github.com/fohte/lefthook-config/commit/e506a0c693a93b4290990109014b63b79d273328))

## [0.1.10](https://github.com/fohte/lefthook-config/compare/v0.1.9...v0.1.10) (2025-12-28)


### Bug Fixes

* **commit-msg:** support mise for commitlint ([#31](https://github.com/fohte/lefthook-config/issues/31)) ([55e7a11](https://github.com/fohte/lefthook-config/commit/55e7a11c7e6096796b9f2359aa7504c2aa59a902))

## [0.1.9](https://github.com/fohte/lefthook-config/compare/v0.1.8...v0.1.9) (2025-12-28)


### Features

* **commit-msg:** add commitlint integration ([#29](https://github.com/fohte/lefthook-config/issues/29)) ([d8fc9f4](https://github.com/fohte/lefthook-config/commit/d8fc9f46c6d7dd2aa54b03e4cee88c0d8257847c))

## [0.1.8](https://github.com/fohte/lefthook-config/compare/v0.1.7...v0.1.8) (2025-12-28)


### Features

* **copier:** add linter to detect `gh:` prefix in `_src_path` ([#27](https://github.com/fohte/lefthook-config/issues/27)) ([a53424b](https://github.com/fohte/lefthook-config/commit/a53424b89025f163bcb167920f7f2b7a89d7c2b6))

## [0.1.7](https://github.com/fohte/lefthook-config/compare/v0.1.6...v0.1.7) (2025-12-27)


### Features

* **shfmt:** add `--apply-ignore` flag ([#25](https://github.com/fohte/lefthook-config/issues/25)) ([86a6c65](https://github.com/fohte/lefthook-config/commit/86a6c65e01e39a29d437d729328456cec0378b92))

## [0.1.6](https://github.com/fohte/lefthook-config/compare/v0.1.5...v0.1.6) (2025-12-24)


### Bug Fixes

* exclude zsh files from shellcheck and shfmt ([#22](https://github.com/fohte/lefthook-config/issues/22)) ([cba356f](https://github.com/fohte/lefthook-config/commit/cba356f39b7fe2e9e1209e52d7a3920b5b9b6743))
* **pre-commit:** Fix Prettier error when symlinks are passed ([#21](https://github.com/fohte/lefthook-config/issues/21)) ([c137cc4](https://github.com/fohte/lefthook-config/commit/c137cc4b11c412ef0a7b462f41e1fea905e40452))

## [0.1.5](https://github.com/fohte/lefthook-config/compare/v0.1.4...v0.1.5) (2025-12-19)


### Features

* Add actionlint to pre-commit hook ([#19](https://github.com/fohte/lefthook-config/issues/19)) ([5f1aba7](https://github.com/fohte/lefthook-config/commit/5f1aba7d74f3386a7bea0cc6d77b61ef7c23d95b))

## [0.1.4](https://github.com/fohte/lefthook-config/compare/v0.1.3...v0.1.4) (2025-12-19)


### Bug Fixes

* Fix shellcheck/shfmt running on non-shell files ([#17](https://github.com/fohte/lefthook-config/issues/17)) ([055f0f2](https://github.com/fohte/lefthook-config/commit/055f0f27d9ef6cce76456e22a3fa0935b817f544))

## [0.1.3](https://github.com/fohte/lefthook-config/compare/v0.1.2...v0.1.3) (2025-12-19)


### Features

* Add prettier pre-commit hook ([#14](https://github.com/fohte/lefthook-config/issues/14)) ([8710f55](https://github.com/fohte/lefthook-config/commit/8710f554c776e8b1fd9f67af097cfec90d16a95c))
* Add shellcheck and shfmt pre-commit hooks ([#11](https://github.com/fohte/lefthook-config/issues/11)) ([c7d88d9](https://github.com/fohte/lefthook-config/commit/c7d88d9d6c4413654c3a8b652f34b57868c2f5d9))


### Bug Fixes

* Handle filenames with spaces and colons in shell detection ([#13](https://github.com/fohte/lefthook-config/issues/13)) ([1e0355a](https://github.com/fohte/lefthook-config/commit/1e0355aee5eca9e2ac38dafbac0bd37f9a6af751))

## [0.1.2](https://github.com/fohte/lefthook-config/compare/v0.1.1...v0.1.2) (2025-12-19)


### Features

* Replace format-fix.sh with basefmt ([#9](https://github.com/fohte/lefthook-config/issues/9)) ([2b67280](https://github.com/fohte/lefthook-config/commit/2b67280f2b39ffaccbf6648478d689982254e43b))

## [0.1.1](https://github.com/fohte/lefthook-config/compare/v0.1.0...v0.1.1) (2025-12-19)


### Features

* Add CI/CD workflow for automated formatting ([#3](https://github.com/fohte/lefthook-config/issues/3)) ([0a865a9](https://github.com/fohte/lefthook-config/commit/0a865a93427e4708ed04f8b828d578c885b56b61))
* Add common lefthook configuration ([#1](https://github.com/fohte/lefthook-config/issues/1)) ([fbdd509](https://github.com/fohte/lefthook-config/commit/fbdd5098579567b1baef6d8d8ec6aea0f78f0ce2))
* Add release-please for semver management ([#6](https://github.com/fohte/lefthook-config/issues/6)) ([83768cb](https://github.com/fohte/lefthook-config/commit/83768cb14824759b063432ece2d6943abd3761f1))


### Bug Fixes

* Set initial version to 0.1.0 for release-please ([#8](https://github.com/fohte/lefthook-config/issues/8)) ([73016c7](https://github.com/fohte/lefthook-config/commit/73016c78c40c4b18b19a1f939c74cdfaf7021908))
