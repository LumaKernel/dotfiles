---
name: luma-exhaust-find-bugs
description: プロジェクトのすべてのgit trackedファイルを網羅的に確認し、確定的なバグ（セキュリティ問題含む）を探す。各バグは必ず再現デモまたは追加テストで証明する。進捗は exhaust-find-bugs.ignore.md で管理し、中断・再開が可能。
allowed-tools: Read, Glob, Grep, Agent, Bash, Edit, Write, WebFetch, WebSearch
---

luma-exhaust の派生。まず luma-exhaust のスキル定義を必ず読む。進捗ファイルは `exhaust-find-bugs-{date}-{commit}.ignore/report.md`。

## 作業内容

確定的なバグを探す。ロジックバグ、セキュリティ脆弱性、競合状態、リソースリーク、境界条件の未定義動作、仕様との矛盾、トランザクションの異常を起こしえる、など。

## バグの証明

バグを見つけたら、必ず以下のいずれかで証明してから報告する:

- A. (優先) 自動テスト追加 → 実行して失敗確認
- B. 再現スクリプト作成 → `exhaust-find-bugs-{date}-{commit}.ignore/test-bug-NNN.{ts,py,sh,...}` にアサーション付きで書き、実行して失敗確認
  - スクリプトの置き場所が重要ならこの場所に限らず `{name}.ignore.{ext}` を任意の場所に置いてよい。
  - 脆弱性などは、ローカルサーバーを立ち上げて実際に到達するためのリクエストを送るスクリプトなど。

### ローカルで再現できない場合の工夫

- まずはテストを足したり、実際にローカルサーバーを立てて実際に動かして成功する方法を模索する。
- SDK・ライブラリの挙動確認: ソースコードをバージョン固定で直接読みに行く。確定しなければ小さなスクリプト（`*.ignore.*`）を書いて実際に実行する
- インフラ関連でローカル再現が不可能な場合: 公式ドキュメントを参照する。
- 確定的な参照（公式ドキュメントに明記）がある場合のみ、参照付きで報告可。いずれも不可能なら報告しない

## Loopプロンプトのカスタマイズ

```
/loop 10m /luma-exhaust-find-bugs {進捗ファイル名} の続きをやる
```

## 進捗ファイルの追加要素

luma-exhaust のツリーに加え、「発見済みバグ」セクションを持つ:

```markdown
## 発見済みバグ

- #1 [Critical] [src/auth.ts:42](./src/auth.ts) — JWT検証でalg=noneを許容
  - 証明: [src/auth.spec.ts](./src/auth.spec.ts) の `test("rejects alg=none")`
- #2 [Major] [src/calc.ts:15](./src/calc.ts) — 浮動小数点丸めで1円ずれる
  - 証明: [test-bug-002.ignore.ts](./test-bug-002.ignore.ts)
```

各バグの記述は、見る人が同等にどのような具体的なコードや検証をもとに進捗ファイルだけ読んで独立して理解できるようにする。

深刻度: Critical / Major / Minor
