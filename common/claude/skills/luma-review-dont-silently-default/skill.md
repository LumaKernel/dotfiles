---
name: luma-review-dont-silently-default
description: "コードレビュー: silent defaulting（暗黙のフォールバック・決め打ち上限・適当なデフォルト値）を検出し、明示的なエラーや設定要求に置き換えるよう指摘する。"
allowed-tools: Read, Glob, Grep, Agent, Bash
---

PRまたは指定されたコードに対して、「silent defaulting」の観点でレビューを行う。gh pr diffを利用する。

## 原則

プログラムが想定外の状態に遭遇したとき、**黙って何かしらの挙動を選ぶ**のは最悪の選択肢である。開発者がバグに気づけず、ユーザーはデータが欠落・破損しても気づかない。正しい対応は「叫ぶ」こと — エラーを投げる、ログを出す、設定を明示的に要求する。

> "Errors should never pass silently. Unless explicitly silenced." — Zen of Python

## 検出パターン

### 1. 決め打ちの上限値・limit で切り捨て

```typescript
// BAD: 1001件目以降が黙って消える
const results = await fetchAll();
return results.slice(0, 1000);

// BAD: ページネーションの上限を超えたら黙って打ち切り
const MAX_PAGES = 100;
while (page < MAX_PAGES) { ... }
```

問うべきこと: 上限を超えたときユーザー/開発者に通知されるか？ 切り捨てが明示されているか？

### 2. `??` / `||` による安易なフォールバック

```typescript
// BAD: undefinedが来ること自体がバグなのに、黙って0にする
const count = response.count ?? 0;

// BAD: 空文字が来たら"unknown"？ それはデータの欠損では？
const name = user.name || "unknown";

// OK: 設計上optionalで、デフォルトが自明
const pageSize = options.pageSize ?? 20;
```

問うべきこと: その値が欠損すること自体が異常ではないか？ フォールバック先は本当に正しいか？ nullが来る原因をまず調べるべきではないか？

### 3. exhaustive switch/union で throw せず default 挙動を作る

```typescript
// BAD: 新しいstatusが追加されたとき黙って"unknown"扱いになる
switch (status) {
  case "active": return renderActive();
  case "inactive": return renderInactive();
  default: return renderUnknown();
}

// GOOD: 新しいstatusが追加されたらコンパイルエラー or ランタイムエラー
switch (status) {
  case "active": return renderActive();
  case "inactive": return renderInactive();
  default: throw new UnreachableError(status);
}
```

### 4. 環境変数・設定が未設定のとき自明でない挙動になる

```typescript
// BAD: DATABASE_URLが未設定だとlocalhostに繋ぎにいく
const dbUrl = process.env.DATABASE_URL ?? "postgres://localhost:5432/dev";

// BAD: 未設定なのにfalseとして動く
const featureEnabled = process.env.ENABLE_FEATURE === "true";
```

問うべきこと: その環境変数が未設定のとき、起動時にエラーで落ちるべきではないか？

### 5. catch で握りつぶし

```typescript
// BAD: エラーが起きても何事もなかったかのように続行
try { await syncData(); } catch { /* ignore */ }

// BAD: エラーをログに出すがフォールバック値で続行し、呼び出し元はエラーを知らない
try { return await fetchPrice(); } catch (e) {
  console.error(e);
  return 0; // ← 0円として処理が進む
}
```

### 6. 暗黙のtruncation・丸め

```typescript
// BAD: 文字数制限を超えたら黙って切る
const title = input.substring(0, 100);

// BAD: 精度を黙って落とす
const amount = Math.round(price * 100) / 100;
```

問うべきこと: 切り捨て・丸めがユーザーに見える形で通知されるか？ バリデーションで弾くべきでは？

## レビュー手順

1. diff を取得し、変更されたコードを読む
2. 上記パターンに該当する箇所を特定
3. 該当箇所ごとに「その値が欠損/超過すること自体が正常なのか異常なのか」を周辺コードから判断
4. 正常系のデフォルトと異常系の握りつぶしを区別する（正常系のデフォルトは指摘しない）

## 判断基準: 指摘するもの / しないもの

**指摘する:**
- 欠損がバグを示唆するのに黙ってフォールバックしている
- 上限超過時にユーザーへの通知がない
- 新しいvariantの追加を検出できないdefault分岐
- 必須設定が未設定でも動いてしまう
- エラーを握りつぶして偽の成功値を返す

**指摘しない:**
- 設計上optionalなパラメータへの妥当なデフォルト値（pageSize, timeout等）
- UIの表示用フォールバック（アバター画像のplaceholder等）で、データ欠損を別途検知している場合
- 明示的に `// fallback: OK because ...` 等の意図コメントがある場合

## 報告フォーマット

各指摘について以下を含める:

- **ファイル:行** — 該当コード
- **パターン**: 上記6分類のどれか
- **問題**: 何が黙って起きるか、具体的なシナリオ
- **提案**: throw / バリデーション / ログ+通知 / 設定の必須化 など
- **優先度**: high（データ損失・セキュリティ）/ medium（バグ検出の遅延）/ low（改善推奨）

各コメントの末尾に `🤖 Made by Claude` を付与する。
