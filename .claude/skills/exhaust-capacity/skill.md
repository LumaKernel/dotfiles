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

## アプリ・ランタイムの使用量調査

対象範囲がルートの場合、インストール済みアプリやランタイムの容量と最終利用日も調査する。

調査手段 (macOS):
- `/Applications` 配下: `du -sh` でサイズ、`mdls -name kMDItemLastUsedDate` で最終利用日
- Homebrew: `brew list --formula` / `brew list --cask` の一覧、`brew autoremove --dry-run` で不要な依存
- ランタイムバージョン管理 (mise, asdf, nvm, pyenv 等): 古いバージョンが残っていないか。`mise ls` や該当ツールで確認
- Xcode 関連: `~/Library/Developer/` 配下のシミュレータ、アーカイブ、DerivedData

調査手段 (Linux):
- パッケージマネージャ: `dpkg-query -W --showformat='${Installed-Size}\t${Package}\n' | sort -rn | head -30` 等
- snap / flatpak: `snap list`, `flatpak list --app`

行動基準:
- 最終利用日が取得できたものは記録する。長期間未使用のものは削除候補として提案
- アプリ本体の削除は提案に留め、勝手に実行しない（関連ファイルの取りこぼし、ライセンス管理等の問題がある）
- `brew uninstall`, `mise uninstall` 等パッケージマネージャ経由で安全に消せるものはコマンドを提示する
- パッケージマネージャを経由しないもの（.app 直置き等）は AppCleaner 等の利用を提案する

## CLI・ツールの棚卸し

対象範囲がルートの場合、各パッケージマネージャでインストールされたCLI・ツールを調査し、削除候補をスコアリングで提案する。

調査対象:
- Homebrew: `brew list --formula` — セラーのサイズは `brew info --json=v2 <pkg> | jq '.formulae[].installed[].installed_as_dependency'` で依存かどうかも判別
- npm global: `npm ls -g --depth=0`、インストール先は `npm root -g`
- uv/pip: `uv tool list` or `pip list --user`
- cargo: `cargo install --list`、`~/.cargo/bin/` 配下のバイナリサイズ
- go: `ls ~/go/bin/`、バイナリの mtime

各ツールについて以下を収集:
- サイズ: バイナリ or セラーの `du -sh`
- 最終利用日: `stat -f '%a'` (atime) でバイナリの最終アクセス日。atime が無効な環境では mtime で代替
- 依存元: 他のパッケージから依存されているか (`brew uses --installed`, etc.)
- dotfiles 管理下か: Brewfile, package.json (global), Cargo.toml 等に記載があるか検索する

スコアリング (削除しやすさの指標、高いほど削除候補):
- 最終利用日が古い → +
- 他から依存されていない → +
- 非推奨・アーカイブ済み、またはよく知られた上位互換がある → + (例: eza > exa, fd > find 的な関係)
- サイズが大きい → +

行動基準:
- スコア順にソートして提案。削除は勝手に実行しない
- dotfiles の管理ファイル (Brewfile 等) に含まれている場合はその旨を明示し、ツールの削除と合わせて管理ファイルからの削除もするか確認する
- 依存されているものは依存元を明示し、単独では消せないことを示す
- 削除コマンドは各パッケージマネージャの uninstall を提示

## cloneリポジトリの棚卸し

対象範囲がルートの場合、ghq 管理下やその他のclone済みリポジトリを調査し、削除候補をスコアリングで提案する。

調査対象の特定:
- `ghq root` で ghq のルートを取得し、配下を走査
- ghq を使っていない場合は `~/src`, `~/repos`, `~/projects`, `~/dev` 等の慣習的なパスを確認

各リポジトリについて以下を収集:
- サイズ: `du -sh` (`.git/` 含む全体)
- clean 度: `git status --porcelain` の出力行数。0 なら clean、少なければ near-clean
- 最終利用日: `stat -f '%m' .git/FETCH_HEAD` or `.git/HEAD` の mtime、`git log -1 --format='%ci'` の最終コミット日
- リモートの存在: `git remote get-url origin` が有効か (アーカイブ済み・削除済みリポジトリの検出)

スコアリング (削除しやすさの指標、高いほど削除候補):
- サイズが大きい → +
- clean or near-clean → + (未コミットの作業がない)
- 最終利用日が古い → +
- リモートが生きている → + (再clone可能)

行動基準:
- スコア順にソートして提案。削除は勝手に実行しない
- unclean なリポジトリは未プッシュの作業がある可能性を明示
- 削除コマンドは `trash` を使った形で提示

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

## アプリ・ランタイム (ルートスコープ時のみ)

| 名前 | サイズ | 最終利用日 | 判定 |
|------|--------|-----------|------|
| GarageBand.app | 1.2GB | 2023-01-15 | 削除候補 |
| node v18.17.0 (mise) | 85MB | — | v22 に移行済み。`mise uninstall node 18.17.0` |
| iOS 16.4 Simulator | 5.8GB | 2024-02-01 | 削除候補。`xcrun simctl delete unavailable` |

## CLI・ツール棚卸し (ルートスコープ時のみ)

| ツール | マネージャ | サイズ | 最終利用 | dotfiles管理 | スコア |
|--------|-----------|--------|---------|-------------|--------|
| exa | brew | 1.2MB | 2023-09-01 | Brewfile L42 | 5/5 削除候補 (archived, eza が後継) |
| prettier | npm -g | 48MB | 2025-01-15 | — | 3/5 npx で代替可能 |
| cargo-edit | cargo | 12MB | 2024-03-01 | — | 4/5 cargo 1.62+ で `cargo add` ネイティブ化 |

## cloneリポジトリ棚卸し (ルートスコープ時のみ)

| リポジトリ | サイズ | 最終利用 | clean | リモート | スコア |
|-----------|--------|---------|-------|---------|--------|
| github.com/foo/large-repo | 2.1GB | 2023-06-01 | yes | alive | 5/5 削除候補 |
| github.com/bar/old-project | 340MB | 2024-01-15 | yes | alive | 4/5 削除候補 |
| github.com/baz/wip-fork | 180MB | 2024-08-01 | no (3 files) | alive | 2/5 要確認 |

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
