#!/usr/bin/env -S deno run --allow-env=TOOL_INPUT

interface Rule {
  readonly pattern: RegExp;
  readonly message: string;
}

const markdownRules: readonly Rule[] = [
  {
    pattern: /\.md"/,
    message:
      "マークダウンファイルへの書き込み: **強調**(bold/italic)を使用しないこと。ユーザーから明示的に指示された場合のみ許可。",
  },
];

export function check(input: string): readonly string[] {
  const messages: string[] = [];
  for (const rule of markdownRules) {
    if (rule.pattern.test(input)) {
      messages.push(rule.message);
    }
  }
  return messages;
}

if (import.meta.main) {
  const toolInput = Deno.env.get("TOOL_INPUT") ?? "";
  const results = check(toolInput);
  if (results.length > 0) {
    console.log(results.join("\n"));
  }
}
