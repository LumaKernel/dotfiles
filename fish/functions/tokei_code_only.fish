function tokei_code_only --description 'Run tokei excluding non-code files'
    set -l exclude_exts \
        json \
        md \
        txt \
        mdx \
        svg \
        htm \
        html \
        yaml \
        yml

    set -l pattern (string join ',' $exclude_exts)
    tokei -e "*.{$pattern}" $argv
end
