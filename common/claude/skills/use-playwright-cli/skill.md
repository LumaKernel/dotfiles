---
name: use-playwright-cli
description: "「pw」「pw cli」「playwright-cli」と言われたら、グローバルインストール済みの playwright-cli CLI を使う。MCP でも npx でもない。curlに逃げない。"
allowed-tools: Bash
---

ユーザーが「pw」「pw cli」「playwright-cli」と言ったとき、以下を厳守する。

## playwright-cli とは

- **グローバルにインストール済みの CLI コマンド `playwright-cli`**
- シェルから直接 `playwright-cli <subcommand>` で実行する
- Bash ツールで実行すること

## 絶対にやってはいけないこと

1. **MCP サーバーを使わない** — playwright MCP、browser MCP、chrome-devtools MCP は別物。代替として使わない
2. **`npx playwright` を使わない** — これは Playwright Test Runner であり、playwright-cli ではない
3. **`curl` に逃げない** — URL の取得やページ操作に curl を使わない。playwright-cli を使う
4. **他のツールで代替しない** — playwright-cli が求められているのに、別のツールや MCP で済ませようとしない

## 使い方

まず利用可能なサブコマンドを確認:

```bash
playwright-cli --help
```

ヘルプを見てからサブコマンドを実行する。
