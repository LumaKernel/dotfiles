---
name: linking-github
description: GitHub issue/PR本文中の専門用語・ファイルパス・引用などをリンク化する。文章本体は一切変更しない。
allowed-tools: Bash, Read, Glob, Grep, Agent
---

GitHub issue や PR の本文（body）に含まれる専門用語・ファイルパス・引用などを検出し、リンク化する。文章の内容・表現は一切変えず、リンクの付与のみを行う。

## 対象

- issue body
- PR body
- PR/issue コメント

## 手順

1. 対象を取得する。`gh pr view` はProjects Classic廃止の影響で使えないため、`gh api` を利用する:
   ```bash
   # PR bodyの取得
   gh api repos/{owner}/{repo}/pulls/{number} --jq '.body'
   # issue bodyの取得
   gh api repos/{owner}/{repo}/issues/{number} --jq '.body'
   # コメントの取得
   gh api repos/{owner}/{repo}/issues/{number}/comments --jq '.[].body'
   ```
   owner/repo は `gh repo view --json owner,name` から取得する。
2. 本文を読み、リンク化すべき箇所を特定する
3. リポジトリの実態を確認する（ファイルパスが実在するか、関数名が正しいかなど）
4. リンク化した本文を `gh api` で更新する:
   ```bash
   # PR bodyの更新
   gh api repos/{owner}/{repo}/pulls/{number} -X PATCH -F body=@/tmp/updated-body.md
   # issue bodyの更新
   gh api repos/{owner}/{repo}/issues/{number} -X PATCH -F body=@/tmp/updated-body.md
   ```
   本文は一時ファイルに書き出してから `-F body=@<file>` で渡す（エスケープ問題の回避）。

## リンク化の対象と方法

### ファイルパス・コードへの参照
- `src/foo/bar.ts` → リポジトリ内の該当ファイルへのGitHubリンク（デフォルトブランチのpermalink）
- `FooClass#method` や関数名 → 該当箇所への行番号付きリンク（実際にGrepして確認する）
- 行番号が記載されている場合（例: `foo.ts:42`）→ 行番号付きリンク

### 専門用語・技術用語
- ライブラリ名・フレームワーク名 → 公式サイトまたは公式リポジトリへのリンク
- RFC・仕様名 → 該当RFCや仕様書へのリンク
- AWS/GCP/Azureなどのサービス名 → 公式ドキュメントへのリンク

### GitHub内参照
- issue/PR番号の言及（`#123` 形式でないもの、例: 「issue 123で議論した」）→ `#123` 形式に変換
- 他リポジトリへの言及 → `owner/repo#123` 形式に変換
- コミットSHA → GitHubのコミットリンク

### 引用・外部参照
- 「〜のドキュメントによると」のような言及 → 該当ドキュメントへのリンク
- エラーメッセージやログの引用 → 関連するissueやドキュメントへのリンク（確実なもののみ）

## 厳守事項

- **文章の内容・表現は一切変更しない。** リンクの付与（Markdown記法の追加）のみを行う
- 既にリンク化されている箇所は触らない
- リンク先が不確実なものはリンク化しない（推測でリンクを貼らない）
- ファイルパスは実在確認してからリンク化する
- 更新前に差分をユーザーに提示し、確認を取ってから適用する
