---
name: cover
description: テストカバレッジを計測し、カバレッジが低い箇所のテストを追加してカバレッジを上げる。
allowed-tools: Read, Glob, Grep, Agent, Bash, Edit, Write
---

プロジェクトのテストカバレッジを計測し、カバレッジが不足している箇所を特定してテストを追加する。

## 手順

1. プロジェクトの言語・テストフレームワークを特定する
2. カバレッジ計測を実行する（後述の言語別コマンド参照）
3. カバレッジレポートを解析し、カバレッジが低いファイル・関数を特定する
4. 影響の大きい箇所（ビジネスロジック、分岐の多い関数）から優先的にテストを追加する
5. テスト追加後に再度カバレッジを計測し、改善を確認する

## カバレッジレポート形式

可能な限り **lcov** 形式で出力する。lcovは行単位のカバレッジ情報をテキストで持ち、解析しやすい。

- ファイル: 通常 `coverage/lcov.info` や `lcov.info` に出力される
- 読み方: `SF:` でファイルパス、`DA:行番号,実行回数` で各行のカバレッジ、`LH:` がヒット行数、`LF:` が総行数

lcovが使えない場合は、テキストのサマリ出力（例: `--coverage` のコンソール出力）をパースする。

## 言語別カバレッジ計測コマンド

### TypeScript / JavaScript
```bash
# Jest
npx jest --coverage --coverageReporters=lcov --coverageReporters=text
# Vitest
npx vitest run --coverage --coverage.reporter=lcov --coverage.reporter=text
```

### Python
```bash
uv run pytest --cov --cov-report=lcov --cov-report=term-missing
```

### Go
```bash
go test -coverprofile=coverage.out ./...
go tool cover -func=coverage.out  # サマリ表示
```

### Rust
```bash
cargo llvm-cov --lcov --output-path lcov.info
cargo llvm-cov report
```

## カバレッジ解析の粒度

以下の優先順で対象を絞る:

1. **ファイル単位**: カバレッジ率が最も低いファイルを特定する
2. **関数単位**: そのファイル内でカバレッジが0%または低い関数を特定する
3. **分岐単位**: 関数内で未カバーの分岐（if/else, match/switch, エラーハンドリング）を特定する

## テスト追加の方針

- 既存のテストファイル・テストパターンに倣う
- カバレッジのためだけの無意味なテストは書かない。振る舞いを検証するテストにする
- エッジケース（境界値、エラーケース、空入力）を優先する
- モックは最小限にし、実際の振る舞いをテストする

## テストドキュメントの書き方

ユーザー目線で、「どういうシチュエーションで」「なにをして」「どうなることを期待するか」というのをしっかり分かりやすいように書く。
ユーザー目線というのは、内部状態や実装に関せず、フロントエンドであれば画面のどのようなボタンをどのように探すか、API利用であれば、どのような物体を認識して利用するか、という起点で記述する。
まず、テストライブラリの提供する方法でコメントを記述することを優先し、コードコメントは最終手段とせよ。(例: expectのmessage引数、title、など。)

