---
name: luma-review-test-inline-snapshot-oriented
description: "テストをinline snapshot指向でレビュー・改善する。「どの状況で」「何をして」「どうなるか（何があり、何がないか）」がテストコードを見て一発で明瞭になるようにする。"
allowed-tools: Read, Glob, Grep, Agent, Bash, Edit, Write
---

PRまたは指定されたテストコードに対して、inline snapshot指向の観点でレビューを行う。gh pr diffを利用する。

## 目標

テストコードを読んだだけで以下が一発で明瞭になること (BDD の Given/When/Then):

1. どのような状況のときに (Given)
2. なにをして (When)
3. どうなるか (Then) — 何があり、何がないか

inline snapshot はこれを一つの宣言的記述で達成する。

## 具体例: DB操作テスト

```typescript
it("deactivateAt を過ぎたユーザーが deactivated になる", async () => {
  vi.setSystemTime("2025-09-15");

  await insertUsers([
    { name: "Alice", status: "active", deactivateAt: null },
    { name: "Bob", status: "active", deactivateAt: "2025-09-01" },
    { name: "Charlie", status: "active", deactivateAt: "2025-10-01" },
  ]);

  await runDeactivateCheck();

  expect(await dumpUsers()).toMatchInlineSnapshot(`
    [
      { "name": "Alice", "status": "active", "deactivateAt": null },
      { "name": "Bob", "status": "deactivated", "deactivateAt": "2025-09-01" },
      { "name": "Charlie", "status": "active", "deactivateAt": "2025-10-01" },
    ]
  `);
  expect(
    (await dumpUsers()).find((u) => u.name === "Alice")?.status,
    "deactivateAt が null の Alice は active のまま",
  ).toBe("active");
});
```

Given と Then が同じ構造なので、何が変わり何が変わらなかったかを比較して読める。

snapshotのなにに着目すべきかは、コメントではなく後続する expect + メッセージで書く。

## 検出パターン

### 1. インデックスアクセス + 個別アサーション

`[0]!.`、`[1]!.`、`?.` でプロパティを個別に確認しているパターン。inline snapshot に置き換える。

```typescript
// BAD
expect(result).toHaveLength(2);
expect(result[0]!.name).toBe("Alice");
expect(result[1]!.name).toBe("Bob");

// GOOD
expect(result).toMatchInlineSnapshot(`
  [
    { "id": "a", "name": "Alice", "status": "active" },
    { "id": "b", "name": "Bob", "status": "active" },
  ]
`);
```

### 2. 複数回取得 + 個別チェック

同じ取得関数を複数回呼び、それぞれ個別にアサーションしているパターン。テーブル全体を一括取得する snapshot ユーティリティを提案する。

```typescript
// BAD
const userA = getUser("a");
expect(userA).not.toBeUndefined();
expect(userA?.name).toBe("Alice");
expect(userA?.role).toBe("admin");
const userB = getUser("b");
expect(userB).not.toBeUndefined();
expect(userB?.name).toBe("Bob");
const userC = getUser("c");
expect(userC).toBeUndefined();

// GOOD: dumpUsers() のようなユーティリティを作って一括 snapshot
expect(await dumpUsers()).toMatchInlineSnapshot(`
  [
    { "id": "a", "name": "Alice", "role": "admin" },
    { "id": "b", "name": "Bob", "role": "member" },
  ]
`);
expect(
  (await dumpUsers()).find((u) => u.id === "c"),
  "削除済みユーザー c は含まれない",
).toBeUndefined();
```

テスト用の一括取得・ダンプユーティリティがなければ作成を提案する。

## ステート管理

`{date}-{skill}.ai-state.md` にて管理。以下のフェーズで進める。

### 1. 範囲確認と収集

対象のテストファイルを全て列挙し、各ファイルの検出パターン該当箇所を記録する。

完了条件: 全対象ファイルと該当箇所の一覧ができた

### 2. プラン

収集結果をもとに、修正の優先順位と作業単位を決める。大きすぎる場合はこのショット内で実行に入らず、実装ショットを個別に区切る判断をする。対象ファイルが5種以上なら必ず区切る。

完了条件: 作業単位ごとの実装計画ができた

### 3. 実行

プランに従い、作業単位ごとに実装する。一つの作業単位が完了したら状態を更新する。

完了条件: 全作業単位が完了した
