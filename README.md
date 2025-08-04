# Lefthook Common Configuration

共通の Lefthook 設定を提供するリポジトリです。

## 使い方

各リポジトリの `lefthook.yml` に以下を追加:

```yaml
remotes:
  - git_url: https://github.com/fohte/lefthook-config
    configs:
    - base.yml
```

## 提供される hooks

### base.yml

言語に依存しない基本的な hooks:

- **editorconfig**: `.editorconfig` の設定に基づいてファイルを修正
  - ファイル末尾に改行を確保 (`insert_final_newline`)
  - 末尾の空白を削除 (`trim_trailing_whitespace`)
  - Markdown ファイルでは改行用の空白は保持

## 必要なツール

この設定は `bunx` を使用して自動的に `eclint` を実行します。
追加のインストールは不要です（Bun が必要です）。

## EditorConfig 設定

各リポジトリに `.editorconfig` ファイルが必要です。
このリポジトリの `.editorconfig` を参考にしてください。

## カスタマイズ

ローカルで設定を上書きしたい場合は、`lefthook-local.yml` を使用してください:

```yaml
pre-commit:
  commands:
    editorconfig:
    skip: true  # この hook をスキップ
```
