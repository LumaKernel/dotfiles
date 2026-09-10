---
name: luma-intro-effect-schema
description: "Effect Schemaをプロジェクトに導入する。Zodが既にある場合は完全移行+削除。ない場合は新規導入。双方向スキーマ・AST表現・3型パラメータの理論的優位性を活かす形で導入する。"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Agent, AskUserQuestion
---

# Effect Schema 導入スキル

Zodの代替として、または新規に、Effect Schemaをプロジェクトに導入する。

**このスキルの核心: 移行はAPIの機械的な置き換えではない。** 各変換でユーザーに「Zodではできなかったこと」「この設計が何を保証するか」を具体的に示し、理論的な優位性を体感させながら進める。

## 教育方針

移行の各ステップで、以下の「教えるべき瞬間」を逃さずユーザーに伝える:

### 瞬間1: 型パラメータの意味（最初のスキーマ定義時）

Zodの `z.infer<typeof X>` は1つの型しか取れない。Effect Schemaの `Schema<Type, Encoded, Requirements>` は3つ。最初のStructを書いたとき、`typeof X.Type` と `typeof X.Encoded` の両方が存在することを見せ、「ワイヤ上の型とアプリ内の型を区別できる」ことを伝える。

```typescript
const User = Schema.Struct({
  name: Schema.String,
  createdAt: Schema.DateFromString, // ← ここがポイント
})
typeof User.Type     // { name: string, createdAt: Date }
typeof User.Encoded  // { name: string, createdAt: string }  ← Zodにはこれがない
```

「JSONでは string、アプリ内では Date。この区別がスキーマ1つで型安全に表現される。Zodだと `.transform()` 後の逆変換を自分で書くか、型を `as` で誤魔化すしかなかった。」

### 瞬間2: 双方向性の恩恵（transform移行時）

Zodの `.transform()` を見つけたら、ただ置き換えるのではなく:

1. **まず問う**: 「この変換の逆方向、プロジェクトのどこかで手書きしていませんか？」
2. Grep で逆変換（`.toISOString()`, `JSON.stringify`, 手動の serialize関数等）を探す
3. 見つかったら: 「これです。Zodだと parse は片方向なので、serialize を別の場所で手書きしている。Effect Schemaなら decode/encode が1つのスキーマに閉じます。この手書き serialize は消せます。」
4. 見つからなくても: 「今は逆変換が不要でも、APIレスポンスを返す側やキャッシュに書く側が増えたとき、encode が既にある状態で始められます。」

### 瞬間3: 依存の可視化（refine移行時）

Zodの `.refine()` に副作用（DB問い合わせ、外部API呼び出し等）がある箇所を見つけたら:

```typescript
// Zodの現状: dbがどこから来るか型に現れない
z.string().refine(async (email) => {
  const exists = await db.checkEmail(email)  // ← dbはクロージャから暗黙に取得
  return !exists
})
```

「この `db` はどこから来ていますか？ クロージャ? グローバル? モジュールスコープ? Zodの型は `ZodString` としか言わない。テストで差し替えたいとき、モック注入の方法がバリデーション定義からは分からない。」

```typescript
// Effect Schema: 依存が型に現れる
Schema.String.pipe(
  Schema.filterEffect((email) =>
    Effect.flatMap(DbService, (db) => db.isUnique(email))
  )
)
// 型: Schema<string, string, DbService>
//                              ^^^^^^^^^ 「このバリデーションにはDbServiceが必要」と型が宣言する
```

「Requirements に `DbService` が現れた。このスキーマを使う側は DbService を提供しないとコンパイルが通らない。テストでは TestDbService を差し込める。依存が暗黙ではなく型レベルで強制される。」

### 瞬間4: 合成の閉包性（スキーマを組み合わせるとき）

Union や transform を重ねたとき、3型パラメータが正しく伝播することを見せる:

```typescript
const Input = Schema.Union(
  Schema.Struct({ type: Schema.Literal("text"), body: Schema.String }),
  Schema.Struct({ type: Schema.Literal("date"), body: Schema.DateFromString }),
)
// Type:    { type: "text", body: string } | { type: "date", body: Date }
// Encoded: { type: "text", body: string } | { type: "date", body: string }
```

「Union の中に DateFromString がある。Type 側では Date になり、Encoded 側では string のまま。合成しても型パラメータが崩れない。Zodだと `.transform()` を union の中で使うと `input` / `output` の型が複雑に絡まって `as` が必要になりがち。」

### 瞬間5: エラーのツリー構造（バリデーションエラー発生時）

最初にバリデーションエラーが出たとき、TreeFormatter の出力を見せる:

「Zodの ZodError はフラットな issues 配列。Effect Schema の ParseError はネストされたツリーで、どの階層のどのフィールドのどの条件が失敗したか、構造的に辿れる。」

## Step 0: 現状分析

### 0a. パッケージマネージャの特定

`package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `bun.lockb` のどれがあるか確認。以降のインストールコマンドはそれに合わせる。

### 0b. Zod の有無と利用状況

```
grep -r "from \"zod\"" --include="*.ts" --include="*.tsx" -l
grep -r "from '@effect/schema'" --include="*.ts" --include="*.tsx" -l
grep -r "from 'effect/Schema'" --include="*.ts" --include="*.tsx" -l
```

以下を把握:
- Zodを使っているファイル数と用途（バリデーション、フォーム、API、型生成）
- Zodに依存するライブラリ（react-hook-form/zod, trpc, drizzle-zod 等）
- 既にEffect Schemaが部分的に入っているか

### 0c. Zodの使い方パターンの分類と教育機会の特定

Zodの利用を以下に分類し、**各パターンでどの「教えるべき瞬間」が発動するか**を紐付ける:

| パターン | 移行難易度 | 教育機会 |
|---------|-----------|---------|
| 単純な型定義 (`z.object`, `z.string` 等) | 低 | 瞬間1: Type/Encoded の分離を見せる |
| `.transform()` | 中 | 瞬間2: 逆変換の手書きを探して消す |
| `.refine()` / `.superRefine()` | 中 | 瞬間3: 副作用の依存を型に出す |
| スキーマの union / intersection | 低 | 瞬間4: 合成しても型パラメータが保たれる |
| フォームライブラリ連携 (zodResolver等) | 高 | アダプタが必要。後述 |
| tRPC連携 | 高 | tRPCがEffect Schemaを受け付けるか確認が必要 |
| drizzle-zod等のORM連携 | 高 | 代替手段の調査が必要 |

### 0d. 結果をユーザーに提示

分析結果を表にまとめ、移行プランをユーザーに提示して承認を得る。以下を含める:

- Zodファイル数と分類別の内訳
- **各分類で「何が良くなるか」の要約** — 単なる作業リストではなく、移行の動機を伝える
- 高難易度の連携箇所とその対応方針
- 段階的移行にするか一括移行にするか

**承認を得てから次へ進む。**

## Step 1: Effect Schemaのインストール

```bash
# effectとschemaの両方が必要
npm install effect @effect/schema
# または pnpm add / yarn add / bun add
```

注意: `@effect/schema` は `effect` パッケージに依存する。両方インストールする。

## Step 2: 移行の準備（Zod移行時のみ）

プロジェクトのschema定義が集約されている場所（`src/lib/schema.ts`, `src/schemas/` 等）を特定し、Effect Schema版を隣に作る。

### 2a. インポートの規約

```typescript
import { Schema } from "effect"
// または
import * as S from "effect/Schema"
```

プロジェクト内で統一する。既存のインポートスタイルに合わせる。AskUserQuestionで好みを聞く。

### 2b. Zod → Effect Schema 変換チートシート（移行時の参照用）

基本型:
```typescript
// Zod                          → Effect Schema
z.string()                      → Schema.String
z.number()                      → Schema.Number
z.boolean()                     → Schema.Boolean
z.literal("x")                  → Schema.Literal("x")
z.enum(["a", "b"])              → Schema.Literal("a", "b")
z.array(z.string())             → Schema.Array(Schema.String)
z.optional(z.string())          → Schema.optional(Schema.String)
z.nullable(z.string())          → Schema.NullOr(Schema.String)
z.union([z.string(), z.number()]) → Schema.Union(Schema.String, Schema.Number)
```

オブジェクト:
```typescript
// Zod
const User = z.object({ name: z.string(), age: z.number() })
type User = z.infer<typeof User>

// Effect Schema — ★瞬間1: ここで Type と Encoded の分離を説明する
const User = Schema.Struct({ name: Schema.String, age: Schema.Number })
type User = typeof User.Type           // decoded型（アプリ内で使う型）
type UserEncoded = typeof User.Encoded // encoded型（ワイヤ上の表現）
// この例では同じだが、DateFromString等を含むと分離する
```

バリデーション:
```typescript
// Zod
z.string().min(1).max(100)

// Effect Schema
Schema.String.pipe(Schema.minLength(1), Schema.maxLength(100))
```

Transform — ★瞬間2: 双方向性を説明する:
```typescript
// Zod (片方向 — 逆変換は自分で書く必要がある)
z.string().transform((s) => new Date(s))

// Effect Schema (双方向 — decode と encode が1つのスキーマに閉じる)
Schema.transform(Schema.String, Schema.DateFromSelf, {
  decode: (s) => new Date(s),
  encode: (d) => d.toISOString(),
  strict: true,
})
// さらに良い: 組み込みの Schema.DateFromString を使えば自分で書く必要すらない
```

Refinement:
```typescript
// Zod
z.string().refine((s) => s.includes("@"), { message: "Must be email" })

// Effect Schema
Schema.String.pipe(
  Schema.filter((s) => s.includes("@") ? undefined : "Must be email")
)
```

副作用付きバリデーション — ★瞬間3: 依存の型安全性を説明する:
```typescript
// Zod (.refine に副作用を入れるが、依存は型に現れない)
z.string().refine(async (email) => {
  const exists = await db.checkEmail(email)
  return !exists
})

// Effect Schema (Requirements型パラメータにDbServiceが現れる)
Schema.String.pipe(
  Schema.filterEffect((email) =>
    Effect.flatMap(DbService, (db) => db.isUnique(email))
  )
)
// 型: Schema<string, string, DbService> ← 依存が型に現れる
```

パース実行:
```typescript
// Zod
const result = User.safeParse(input)  // { success, data, error }
const data = User.parse(input)        // throws

// Effect Schema
const result = Schema.decodeUnknownEither(User)(input)  // Either<User, ParseError>
const data = Schema.decodeUnknownSync(User)(input)       // throws
// encode (逆方向) — Zodにはこの操作が存在しない
const encoded = Schema.encodeSync(User)(data)
```

## Step 3: ファイルごとの移行（Zod移行時）

### 移行順序

1. **共有スキーマ定義**（他から参照される型）を先に移行 → 瞬間1を発動
2. **APIレイヤー**（リクエスト/レスポンスの型）を移行 → 瞬間2を発動（双方向性の恩恵）
3. **バリデーション層**（refine/superRefine）を移行 → 瞬間3を発動（依存の可視化）
4. **フォーム連携**を最後に移行 — アダプタが必要な場合があるため

### 各ファイルの移行手順

1. ファイル内の全 `z.` 呼び出しを Effect Schema に置換
2. `z.infer<typeof X>` → `typeof X.Type` に置換
3. `.parse()` / `.safeParse()` → `Schema.decodeUnknownSync` / `Schema.decodeUnknownEither` に置換
4. **双方向性の発掘**: `.transform()` を見つけたら、プロジェクト内で対応する逆変換（手書きserialize）を Grep で探す。見つかったら「これが消せます」と伝えて encode 側に統合する
5. **依存の発掘**: `.refine()` に副作用がある箇所を見つけたら、その依存がどこから来ているかを示し、`filterEffect` + `Requirements` に置き換える価値を説明する
6. `import { z } from "zod"` を削除
7. 型チェック (`tsc --noEmit`) を通す
8. **最初のバリデーションエラーが出たら瞬間5を発動**: TreeFormatter の出力を見せて、Zodとの構造の違いを説明する

### フォームライブラリ連携

zodResolverを使っている場合、Effect Schemaのresolverが必要。`@hookform/resolvers` にEffect Schema版があるか確認。なければ薄いアダプタを書く:

```typescript
import { Schema } from "effect"
import type { Resolver } from "react-hook-form"

const effectSchemaResolver = <A, I>(
  schema: Schema.Schema<A, I>
): Resolver<A> => async (values) => {
  const result = Schema.decodeUnknownEither(schema)(values)
  // Either → react-hook-form の形式に変換
  // ...
}
```

**注意**: このアダプタが複雑になる場合はAskUserQuestionでユーザーに相談する。フォーム連携だけZodを残す判断もあり得る（その場合はスキーマ定義の二重管理を避けるため、Effect Schema → Zod への変換レイヤーを1箇所に閉じ込める）。

## Step 4: Zod の完全削除（Zod移行時）

1. `grep -r "from ['\"]zod['\"]" --include="*.ts" --include="*.tsx"` でZodの残存を確認
2. 残存が0になったら `npm uninstall zod` (+ zod関連パッケージも)
3. `package.json` からzod関連が消えたことを確認
4. `tsc --noEmit` が通ることを確認

## Step 5: 新規導入ガイドライン（Zodなし or 移行完了後）

プロジェクト内にEffect Schemaの使い方ガイドを残す（READMEのセクションまたは `docs/schema.md`）。内容:

1. **インポート規約**: Step 2aで決めた形式
2. **スキーマ定義の置き場所**: どのディレクトリに定義するか
3. **decode/encodeの使い分け**: いつ `decodeUnknown` を使い、いつ `decode` を使うか
4. **Brand型の活用**: `Schema.brand` で名目的型安全性を得る

```typescript
const UserId = Schema.String.pipe(Schema.brand("UserId"))
type UserId = typeof UserId.Type // string & Brand<"UserId">
```

5. **`as` 禁止との相性**: Effect Schemaは `as` なしで型が付く設計。型ガード不要

ドキュメントの要否はAskUserQuestionでユーザーに聞く。不要なら作らない。

## 設計判断の指針

- **双方向性が不要な箇所でも Effect Schema を使う**: API統一のため。片方向しか使わなくてもペナルティはない
- **`as` を絶対に使わない**: Effect Schemaの型推論を信頼する。型が合わない場合はスキーマ定義が間違っている
- **`readonly` がデフォルト**: Effect Schemaの出力型はデフォルトでimmutable。CLAUDE.mdのimmutable方針と合致
- **filterEffect で依存を型に出す**: バリデーションに副作用がある場合、Promiseで投げずにEffectの依存注入を使う

## 完了条件

- [ ] `effect` と `@effect/schema` がインストールされている
- [ ] Zodが存在した場合: `zod` パッケージが `package.json` から削除されている（フォーム連携等で残す判断をした場合はその理由が明示されている）
- [ ] `tsc --noEmit` が通る
- [ ] 既存テストが通る
- [ ] 双方向性が活きる箇所（Date変換、APIシリアライズ等）で encode が定義されている
- [ ] 移行中に少なくとも「教えるべき瞬間」の1〜3をユーザーに伝えた（該当パターンが存在する場合）
