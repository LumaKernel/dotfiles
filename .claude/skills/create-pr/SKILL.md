---
name: create-pr
description: PRを作成する。ブランチの全コミットを分析し、簡潔なPRを作成する。
allowed-tools: Bash
---

PRを作成する。`gh pr view` はProjects Classic廃止の影響で使えないため、`gh pr create` と `gh api` を利用する。

## 手順

1. 現在のブランチの状態を確認する:
   - `git status` で未コミットの変更を確認
   - `git log --oneline main..HEAD`（またはベースブランチ）で全コミットを確認
   - `git diff main...HEAD` で差分全体を把握
2. ベースブランチからの **全コミット** を分析してPRを作成する（最新コミットだけでなく全体を見る）
3. リモートにpushされていなければ `git push -u origin HEAD` する
4. `gh pr create` でPRを作成する

## PRフォーマット

- タイトル: 70文字以内、変更の本質を簡潔に
- 本文: 以下のテンプレートに従う

```
## Summary
<箇条書き1-3点。変更の目的と内容>

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

## 注意事項

- Test Plan セクションは **書かない**
- 本文はHEREDOCで渡す（フォーマット崩れ防止）
- 作成後、PRのURLを返す
