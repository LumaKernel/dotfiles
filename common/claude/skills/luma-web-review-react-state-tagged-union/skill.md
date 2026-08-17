---
name: luma-web-review-react-state-tagged-union
description: "Reactコンポーネントのステート設計をレビューし、型上で不正な組み合わせが許容されている箇所や、tagged union / useActionState を使うべき箇所を指摘する。"
allowed-tools: Read, Glob, Grep, Agent
---

プロジェクト全体のReactコンポーネントを対象に、ステートの型設計に関するレビューを行う。

## 対象ファイル

Glob/Grep で `.tsx` ファイルを探索し、`useState` を複数使っているコンポーネントを中心にレビューする。

## 観点

### 1. 不正な状態の組み合わせが型上で許容されていないか

複数の `useState` が連動して変化するパターンを探す。以下が典型的なアンチパターン:

```typescript
// BAD: isLoading=true かつ data が存在する、error が存在するのに isLoading=false でない、等の不正状態が型上で許容される
const [isLoading, setIsLoading] = useState(false);
const [data, setData] = useState<Data | null>(null);
const [error, setError] = useState<Error | null>(null);
```

これを tagged union で表現すべき:

```typescript
// GOOD: 不正な組み合わせが型上で存在できない
type State =
  | { readonly status: "idle" }
  | { readonly status: "loading" }
  | { readonly status: "success"; readonly data: Data }
  | { readonly status: "error"; readonly error: Error };

const [state, setState] = useState<State>({ status: "idle" });
```

探すべきシグナル:
- `isLoading` / `isSubmitting` / `isPending` 系の boolean と、`data` / `error` / `result` 系の nullable state が共存
- `status` や `phase` 的な文字列 state と、それに紐づくデータが別々の useState
- `setX` と `setY` が常にセットで呼ばれている（状態遷移が原子的でない）
- boolean フラグが3つ以上ある（2^n の組み合わせのうち有効なのはごく一部のはず）

### 2. useActionState を使うべき箇所

React 19 の `useActionState` で置き換えられるパターンを探す:

- フォーム送信で `useState` + `onSubmit` ハンドラ内で手動で loading/error/success を管理しているもの
- Server Action を呼んでいるが `useActionState` を使っていないもの
- `useTransition` + 手動ステート管理で form action 相当のことをしているもの

### 3. useReducer で十分な箇所

tagged union + `useState` より `useReducer` のほうが自然なケース:
- 状態遷移が3パターン以上あり、各遷移で複数フィールドが変わる
- ただし `useActionState` で済むなら useReducer も不要

## レビュー手順

1. `useState` を2つ以上使っているコンポーネントを Grep で列挙
2. 各コンポーネントの状態の組み合わせを分析
3. 不正な組み合わせが存在しうるか判定
4. 修正提案を作成（プロジェクトにタスク管理の仕組みがある場合は、タスク化も提案する）

## 報告フォーマット

各指摘について以下を含める:

- **ファイル:行** — コンポーネント名
- **現状の問題**: どの状態の組み合わせが不正か、具体的に列挙
- **提案**: tagged union / useActionState / useReducer のいずれを使うべきか、型定義の例を添えて
- **優先度**: high（バグの温床）/ medium（可読性・保守性）/ low（軽微な改善）

high は「実際に不正状態に陥るコードパスが存在する」もの。medium は「型上は許容されるが現状のコードでは不正状態にならない」もの。

各コメントの末尾に `🤖 Made by Claude` を付与する。
