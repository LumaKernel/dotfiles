## 実験的な実行

`node -e` や `bun -e` を利用しない。ファイルを作成し、shebangを書く。
chmodと実際の実行は分ける (&& でやらない)。 ./foo.local.ts のように直接実行する。
また、何度も作り替えず、同じファイルを書き換えて利用せよ。

## MCPの利用

- browser/playwright/chrome-devtools mcpはそれぞれすべて別のものです。存在しなくても、指示なしに勝手に他のものを利用しないでください。
- context7/searchもまた別のものです。勝手に代替しないでください。

## TypeScript Best Practices

- You should not use "as" keyword. You can use type guard functions (no need to write is... because it's now inferred)
- 関数型の手法を全面的に利用
- 参照等価性、テスタビリティ、構造化、レイヤリングを意識
- イミュータブルな方法を取る。readonlyを付ける

## Test Best Practices

- 全体: t-wada推奨の方法
- フロントエンドテスト: Kent C. Dodds の Testing Trophy

## 再発防止・変更漏れ防止

問題が起きたあと、またコードを変更するときは常に以下を意識する:

- **型エラー・チェックエラーとして検出できないか？** 変更が必要な箇所を見落とした場合、それをコンパイル時に検出できる仕組みにできないか考える
- **exhaustive check を活用する。** switch文やunion型の分岐では網羅性チェックを必ず入れ、変化に強制的に対応させる
- **プロパティ追加の検出:** オブジェクトのプロパティが増えたことに気付けなかった場合、`{ knownProp1, knownProp2, ...rest } = obj; assertRestExhaustive(rest);` パターンの利用を検討する
- **変更時に一緒にすべきことをコード内に明記する。** 関連するファイル・テスト・型定義など、一緒に変更すべきものをコメントやドキュメントで明示しておく（テストをどう更新すべきかも含め）
- **gitコミット差分を振り返る。** 問題が漏れた場合、差分を見て「この変更を最初からするにはどうすれば良かったか」を考え、仕組みとして再発を防ぐ

## Git

- `git checkout` を使わない。代わりに用途に応じた専用コマンドを使う:
  - ブランチ切り替え・作成: `git switch` / `git switch -c`
  - ブランチ削除・管理: `git branch -d` / `git branch -D`
  - ファイルの復元: `git restore` / `git restore --staged`

## sayコマンド

- 日本語の文章を読み上げる場合は `-v Kyoko` を指定する

## Python

- `python`, `python3`, `pip`, `pip3` を直接使わない。代わりに `uv` を使う:
  - スクリプト実行: `uv run python script.py`
  - パッケージインストール: `uv pip install` / `uv add`
  - 仮想環境作成: `uv venv`

## rmが必要な場合(削除したい場合)

以下のような方法を取る

- mvで.trashedなどを付けたものにリネームする
- mvで<proj>/.trash/に移動する
