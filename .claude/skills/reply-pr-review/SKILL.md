---
name: reply-pr-review
description: PRのunresolvedなレビューコメントに対して、調査・事実確認の上で返答または解消する。
allowed-tools: Read, Glob, Grep, Agent, Bash
---

PRのunresolvedなレビューコメントを取得し、各コメントに対して返答または解消を行う。`gh pr diff` や `gh api` を利用する（`gh pr view` はProjects Classic廃止の影響で使えない）。

## 手順

1. `gh pr diff` で変更内容を把握する
2. GraphQL APIでunresolvedなレビュースレッドを取得する。クエリ内の `!` がbashのヒストリ展開に干渉するため、`-F query=@<file>` でファイルから渡す:
   ```bash
   # 一時ファイルにクエリを書き出す
   cat > /tmp/review-threads.graphql <<'GRAPHQL'
   query($owner: String!, $repo: String!, $pr: Int!) {
     repository(owner: $owner, name: $repo) {
       pullRequest(number: $pr) {
         reviewThreads(first: 100) {
           nodes {
             isResolved
             comments(first: 50) {
               nodes { author { login } body path line createdAt }
             }
           }
         }
       }
     }
   }
   GRAPHQL
   ```
   ```bash
   gh api graphql -F query=@/tmp/review-threads.graphql \
     -f owner=OWNER -f repo=REPO -F pr=PR_NUMBER
   ```
   `isResolved: false` のスレッドのみを対象とする。OWNER/REPO/PR_NUMBERは `gh repo view --json owner,name` と `gh pr view --json number` または引数から取得する。
3. 各コメントの指摘内容を正確に理解する
4. 指摘に関連するコードや仕様を実際に確認し、事実関係を調査する
5. 調査結果に基づいて返答する。返答は `gh api` で該当スレッドにreplyする

## 姿勢

- レビュー指摘に対して従順に従うだけではなく、事実確認を行った上で判断する
- 指摘が正しい場合: 修正を行い、何をどう直したか具体的に返答する
- 指摘が誤りや誤解に基づく場合: 根拠を示して丁寧に反論・説明する
- 判断が分かれる場合: 双方の立場を整理し、トレードオフを明示した上で意見を述べる
- 不明な点がある場合: 推測で回答せず、何が不明かを明確にして確認を求める

## コメント共通ルール

根拠と引用+ソースを必ず提示する。各技術用語 (クラウド関連、規格名) はすべて細かく公式ドキュメントやRFCへのリンク化をして提示する。付随して見るべきリンクがあれば最後に列挙する。推測に基いた内容は書かない。

コメントはなるべく、対応する行への直接のレビューにする。また、変更提案も可能であればするが、自明な1通りのやりかたがあるときに限定し、そうでなければ、ニュートラルに列挙のみする。

脅威に関する修正提案などは、それを実現しうる具体的な方法を一緒に提案する。

各コメントの末尾に `🤖 Made by Claude` を付与する。
