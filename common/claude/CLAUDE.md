## CRITICAL: Tool Usage Priority for Refactoring

**When performing refactoring operations (rename, move, etc.) on TypeScript code, ALWAYS use typescript MCP tools (`mcp__typescript_*`) instead of the default Edit/Write tools.**

Specifically for refactoring:

- For renaming symbols: ALWAYS use `mcp__typescript__rename_symbol` instead of Edit/Write
- For moving files: ALWAYS use `mcp__typescript__move_file` instead of Bash(mv) or Write
- For moving directories: ALWAYS use `mcp__typescript__move_directory` instead of Bash(mv)
- For finding references: ALWAYS use `mcp__typescript__find_references` instead of Grep/Bash(grep)
- For type analysis: ALWAYS use `mcp__typescript__get_type_*` tools

**NEVER use Edit, MultiEdit, or Write tools for TypeScript refactoring operations that have a corresponding mcp\__typescript_\* tool.**

## CRITICAL: git commit/push not allowed

Never ask/try to git commit/push. Theses commands are controlled by the user.

## Gemini Search

`gemini` is google gemini cli. You can use it for web search.

Run web search via Task Tool with `gemini -p 'WebSearch: ...'`.

```bash
gemini -p "WebSearch: ..."
```

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
