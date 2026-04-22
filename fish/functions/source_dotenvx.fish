function source_dotenvx --description 'dotenvxで.envファイルを読み込み環境変数に設定する'
    if contains -- -h $argv; or contains -- --help $argv
        echo "使い方: source_dotenvx [-f <ファイル>]"
        echo ""
        echo "dotenvxを使って.envファイルをパースし、現在のシェルに環境変数として設定する。"
        echo ""
        echo "オプション:"
        echo "  -f <ファイル>  読み込む.envファイルを指定 (デフォルト: .env)"
        echo "  -h, --help     このヘルプを表示"
        return 0
    end

    set -l env_file .env
    set -l i 1
    while test $i -le (count $argv)
        switch $argv[$i]
            case -f
                set i (math $i + 1)
                if test $i -gt (count $argv)
                    echo "source_dotenvx: -f にはファイルパスが必要です" >&2
                    return 1
                end
                set env_file $argv[$i]
        end
        set i (math $i + 1)
    end

    if not command -q dotenvx
        echo "source_dotenvx: dotenvx が見つかりません" >&2
        return 1
    end

    if not test -f $env_file
        echo "source_dotenvx: $env_file が見つかりません" >&2
        return 1
    end

    if not command -q jq
        echo "source_dotenvx: jq が見つかりません" >&2
        return 1
    end

    dotenvx get -f $env_file 2>/dev/null | jq -r 'to_entries[] | "\(.key)=\(.value)"' | while read -l line
        set -l kv (string split -m 1 '=' -- $line)
        if test (count $kv) -eq 2
            set -gx $kv[1] $kv[2]
        end
    end
end
