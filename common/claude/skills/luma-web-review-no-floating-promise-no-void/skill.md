---
name: luma-web-review-no-floating-promise-no-void
description: "no-floating-promises の ignoreVoid: false 化と、void 式を consumePromise 的手法へ置換するレビュー・修正を行う。"
allowed-tools: Read, Glob, Grep, Edit, Write, Bash, LSP, Agent
---

プロジェクトの `@typescript-eslint/no-floating-promises` ルールで `void` による抑制を禁止し、既存の `void promiseExpr` を適切なハンドリングに置換する。

## 1. eslint 設定の変更

`@typescript-eslint/no-floating-promises` に `"ignoreVoid": false` を設定する。

```jsonc
// 例
"@typescript-eslint/no-floating-promises": ["error", { "ignoreVoid": false }]
```

既に `ignoreVoid` が未指定(デフォルト `true`)または明示的に `true` のケースを探し、`false` に変更する。

## 2. なぜ void を禁止するか

`void promise` は「lint を黙らせる」だけで何も解決しない:

- エラーが握り潰される（unhandled rejection になるか、完全に消える）
- 実行順序が保証されない事実が隠蔽される
- 「意図的に fire-and-forget している」のか「await を忘れた」のか区別がつかない

## 3. 既存の `void ...` を置換する

プロジェクト内の `void ` を含む箇所を Grep で洗い出し、それぞれ以下のいずれかに置換する。

### 判断フロー

1. **本当に await すべきではないか？** → `await` に変更（最も多いケース）
2. **fire-and-forget が意図的だが、エラーは捕捉したい** → `consumePromise` 的ヘルパーを使う
3. **fire-and-forget かつエラーも無視してよい（テスト等）** → `consumePromise` でエラーログだけ出す

### consumePromise の実装方針

プロジェクトに合った形で1つ選んで導入する。いずれも「Promise を意図的に消費している」ことを明示する目的。

#### A. 最小実装（推奨）

```typescript
/** 意図的な fire-and-forget。エラーはコンソールに出す。 */
const consumePromise = (p: Promise<unknown>): void => {
  p.catch((e: unknown) => {
    console.error("Unhandled promise in fire-and-forget:", e);
  });
};
```

#### B. エラー監視サービス連携版（Sentry 等がある場合）

```typescript
const consumePromise = (p: Promise<unknown>): void => {
  p.catch((e: unknown) => {
    captureException(e); // Sentry 等
  });
};
```

いずれの場合も:

- `.catch` を付けることで unhandled rejection を防ぐ
- 関数名で「意図的に結果を捨てている」ことがコード上で明示される
- `void` と違い、エラー時の挙動が定義される

### 配置場所

プロジェクトの utils / shared 層に1ファイルで置く。既に類似のヘルパーがあれば再利用する。

## 4. 確認

変更後、以下を実行して lint エラーが解消されていることを確認する:

```bash
npx eslint --no-warn-ignored '**/*.ts' '**/*.tsx'
```

残存する `void` 式がないことも Grep で確認する。

## 5. 報告

- 変更した eslint 設定箇所
- `void` → `await` に変えた箇所の数
- `void` → `consumePromise` に変えた箇所の数と、選んだ実装方針
- 判断に迷った箇所があれば列挙
