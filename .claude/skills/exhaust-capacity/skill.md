---
name: exhaust-capacity
description: プロジェクトのすべてのgit trackedファイルをトップダウンに順に確認し、容量・サイズの観点で調査する。Dockerイメージ・ボリューム等ファイルとして直接表れないものも対象。進捗は exhaust-capacity-{date}.ai-state.md で管理し、中断・再開が可能。
allowed-tools: Read, Glob, Grep, Agent, Bash, Edit, Write
---

luma-exhaust の派生。まず luma-exhaust のスキル定義を必ず読む。進捗ファイルは `exhaust-capacity-{date}.ai-state/report.md`。

## 対象範囲の確認

最初のショットの前に、まず対象範囲をユーザーに確認する。選択肢を提示:

1. `/` (ルートから) — デフォルト。マシン全体のディスク使用状況を調査
2. cwd (現在のプロジェクトディレクトリから) — プロジェクトスコープに限定
3. 他のディスク / マウントポイント — `df -h` で一覧を出し、対象を選んでもらう

ルート or 他ディスクの場合は git tracked に限定せず、`du -sh` ベースでトップダウンに大きいディレクトリから掘っていく。cwd の場合は luma-exhaust の git ls-files ベースの進行に従う。

## 作業の順序

トップダウン: 対象ルートから深さ優先でディレクトリを上から順に処理する。luma-exhaust の展開ルールに従うが、展開時に `du -sh` でディレクトリサイズも記録する。

## ファイル外の調査対象

git tracked ファイルをすべて見た後、以下のようなファイルツリーに直接表れない容量消費源を調査する。プロジェクトに該当するものだけを対象とする:

- Docker: `docker system df`, `docker images`, `docker volume ls` でイメージ・ボリューム・ビルドキャッシュのサイズを確認。Dockerfile / compose.yaml があれば、不要レイヤー・multi-stage の有無を確認
- パッケージキャッシュ: `node_modules` のサイズ、`pip cache`、`uv cache` 等
- ビルド成果物: `dist/`, `.next/`, `build/`, `.turbo/` 等 gitignore されているが容量を食うもの
- ログ・一時ファイル: `.log`, `.tmp`, core dump 等
- Git 自体: `.git/` のサイズ。`git count-objects -vH` で packfile や loose objects のサイズを確認。巨大ファイルの履歴が残っていないか `git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | sort -rnk3 | head -20`
- OS / ランタイム固有: `.DS_Store` の散在、`__pycache__`、`.pyc`

該当するものが見つかったら進捗ファイルの「ファイル外の調査」セクションに記録する。

## 進捗ファイルの追加要素

luma-exhaust のツリーに加え、以下のセクションを持つ:

```markdown
## サイズ概況

| 対象 | サイズ | 備考 |
|------|--------|------|
| git tracked 全体 | 12MB | |
| node_modules/ | 450MB | |
| .git/ | 85MB | |
| Docker images | 2.3GB | 3 images |

## ファイル外の調査

- [ ] Docker (Dockerfile あり → 対象)
- [ ] パッケージキャッシュ
- [ ] ビルド成果物
- [ ] Git 履歴
- [x] OS固有  # skip: .DS_Store なし

## 発見事項

- #1 [src/assets/video.mp4] 45MB — git tracked されている動画ファイル。LFS or 外部ストレージへの移行候補
- #2 [Docker] ビルドキャッシュ 8GB — `docker builder prune` で回収可能
```

## 最初のショット

skill 呼び出し直後の最初のショットでは、実際の詳細調査を開始しない。以下の整理のみを行う:

1. 対象範囲を確認する（上記「対象範囲の確認」参照）。`df -h` の結果も添えて選択肢を提示し、ユーザーの回答を待つ
2. luma-exhaust のスキル定義を読む
3. 対象範囲に応じてファイルリストを取得する（cwd なら `git ls-files`、ルート/他ディスクなら `du -sh /* 2>/dev/null | sort -rh | head -20` 等）
4. 進捗ファイル (`exhaust-capacity-{date}.ai-state/report.md`) を作成し、トップレベルのツリーとサイズ概況を列挙する
5. ファイル外の調査対象のうち、このプロジェクトに該当するものをチェックリスト化する

整理が完了したら、以下のloopプロンプトを提示し、loopを設定してよいか確認する。承認されたらloopを設定し、そのまま作業を開始する。

```
/loop 10m /exhaust-capacity {進捗ファイル名} の続きをやる
```
