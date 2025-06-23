# プッシュされていないコミットとプルされていないコミットの数を表示する関数
# 使用方法: git_unpushed_unpulled [remote_name]
# remote_name: リモートリポジトリの名前。デフォルトは 'origin' です。
function git_unpushed_unpulled
    # ヘルプオプションのチェック
    if test (count $argv) -gt 0
        # `test` コマンドで `or` を使用するように修正
        if test "$argv[1]" = "--help"; or test "$argv[1]" = "-h"
            echo "使用方法: git_unpushed_unpulled [remote_name]"
            echo ""
            echo "プッシュされていないコミットとプルされていないコミットの数を表示します。"
            echo "remote_name: リモートリポジトリの名前。デフォルトは 'origin' です。"
            echo "例:"
            echo "  git_unpushed_unpulled        # 'origin' リモートを使用"
            echo "  git_unpushed_unpulled upstream # 'upstream' リモートを使用"
            return 0
        end
    end

    # 現在のディレクトリがGitリポジトリ内にあることを確認
    if not git rev-parse --is-inside-work-tree > /dev/null 2>&1
        echo "Gitリポジリではありません。"
        return 1
    end

    # リモート名を引数から取得。引数がない場合は 'origin' をデフォルトとする
    set -l remote_name "origin"
    if test (count $argv) -gt 0
        set remote_name $argv[1]
    end

    # 指定されたリモートが存在するか確認
    if not git remote show $remote_name > /dev/null 2>&1
        echo "リモート '$remote_name' が存在しません。"
        return 1
    end

    # リモートの最新の変更をマージせずにフェッチする
    # これにより、リモート追跡ブランチ (例: origin/master) が更新されます
    git fetch $remote_name --quiet

    # 現在のブランチにアップストリームが設定されているか確認
    # ここでは、指定されたリモートに属するアップストリームブランチを使用します
    set -l upstream_branch (git rev-parse --abbrev-ref @{u} 2>/dev/null)

    # アップストリームブランチが設定されていない場合、デフォルトのリモートを使用
    if test -z "$upstream_branch"
        set -l current_branch (git rev-parse --abbrev-ref HEAD)
        set upstream_branch "$remote_name/$current_branch"
        if not git rev-parse --verify "$upstream_branch" > /dev/null 2>&1
            echo "現在のブランチ ($current_branch) にアップストリームブランチが設定されていません。"
            echo "次のように設定してください: git branch --set-upstream-to=$remote_name/<ブランチ名>"
            return 1
        end
    else
        # 既存のアップストリームブランチが指定されたリモートに属しているか確認
        if not string match --quiet --regex "^$remote_name/" "$upstream_branch"
            echo "警告: 現在のブランチのアップストリーム ($upstream_branch) は指定されたリモート ($remote_name) と一致しません。"
            echo "unpush/unpullのカウントはアップストリームブランチに対して行われます。"
            # ただし、処理は継続します。
        end
    end


    # プッシュされていないコミット数を計算 (ローカルのHEADにあるが、アップストリームにはないコミット)
    # HEAD は現在のローカルブランチの先端です
    # $upstream_branch はリモート追跡ブランチの先端です
    set -l unpushed_count (git rev-list HEAD --not $upstream_branch | wc -l | tr -d '[:space:]')

    # プルされていないコミット数を計算 (アップストリームにあるが、ローカルのHEADにはないコミット)
    set -l unpulled_count (git rev-list $upstream_branch --not HEAD | wc -l | tr -d '[:space:]')

    # 要求された形式で結果を表示
    echo "unpush=$unpushed_count,unpull=$unpulled_count"
end

