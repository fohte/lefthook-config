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

- **end-of-file-fixer**: ファイル末尾に改行を確保
- **trailing-whitespace**: 末尾の空白を削除（Markdown の改行は保持）

## スクリプトについて

各 hook の実装は `.lefthook/scripts/` 以下のシェルスクリプトで行われています。
これらのスクリプトは自動的にダウンロードされ、実行されます。

## カスタマイズ

ローカルで設定を上書きしたい場合は、`lefthook-local.yml` を使用してください:

```yaml
pre-commit:
  commands:
    trailing-whitespace:
      skip: true  # この hook をスキップ
```