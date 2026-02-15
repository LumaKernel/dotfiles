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

## rmが必要な場合(削除したい場合)

以下のような方法を取る

- mvで.trashedなどを付けたものにリネームする
- mvで<proj>/.trash/に移動する
