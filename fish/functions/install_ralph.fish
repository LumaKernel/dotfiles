function install_ralph --description 'Install ralph (AI agent loop) to scripts/ralph/ directory'
    # Parse arguments
    set -l target_dir ""
    set -l show_help false
    set -l tool "claude"
    set -l localize_ja true
    set -l skip_next false

    for i in (seq (count $argv))
        if $skip_next
            set skip_next false
            continue
        end

        set -l arg $argv[$i]
        switch $arg
            case -h --help
                set show_help true
            case -t --tool
                set -l next_i (math $i + 1)
                if test $next_i -le (count $argv)
                    set tool $argv[$next_i]
                    set skip_next true
                else
                    echo "[ERROR] --tool requires an argument (claude or amp)"
                    return 1
                end
            case --no-ja
                set localize_ja false
            case --ja
                set localize_ja true
            case '*'
                if test -z "$target_dir"
                    set target_dir $arg
                end
        end
    end

    if $show_help
        echo "Usage: install_ralph [OPTIONS] [TARGET_DIR]"
        echo ""
        echo "Install ralph (AI agent loop) from GitHub to scripts/ralph/ directory."
        echo "https://github.com/snarktank/ralph"
        echo ""
        echo "Arguments:"
        echo "  TARGET_DIR    Base directory to install (default: current directory)"
        echo "                Files will be placed in TARGET_DIR/scripts/ralph/"
        echo ""
        echo "Options:"
        echo "  -t, --tool TOOL   AI tool to use: claude (default) or amp"
        echo "  --ja              Localize .md files to Japanese (default: on)"
        echo "  --no-ja           Skip Japanese localization"
        echo "  -h, --help        Show this help message"
        echo ""
        echo "Files installed (scripts/ralph/):"
        echo "  - ralph.sh       Main orchestration script"
        echo "  - CLAUDE.md      Prompt template (for claude)"
        echo "  - prompt.md      Prompt template (for amp)"
        echo "  - prd.json       Example PRD file"
        echo ""
        echo "Skills installed (for claude only, in .claude/skills/):"
        echo "  - prd/SKILL.md   PRD generator command (/prd)"
        echo "  - ralph/SKILL.md PRD to JSON converter (/ralph)"
        echo ""
        echo "Note: Existing files will NOT be overwritten."
        return 0
    end

    # Validate tool option
    if test "$tool" != "claude" -a "$tool" != "amp"
        echo "[ERROR] Invalid tool: $tool (must be 'claude' or 'amp')"
        return 1
    end

    # Set default target directory
    if test -z "$target_dir"
        set target_dir (pwd)
    end

    # Validate target directory exists
    if not test -d "$target_dir"
        echo "[ERROR] Target directory does not exist: $target_dir"
        return 1
    end

    # Check claude command if localization is enabled
    if $localize_ja
        if not command -q claude
            echo "[WARN] claude command not found, skipping Japanese localization"
            set localize_ja false
        end
    end

    set -l ralph_dir "$target_dir/scripts/ralph"
    set -l base_url "https://raw.githubusercontent.com/snarktank/ralph/main"

    echo "[INFO] Installing ralph for: $tool"
    if $localize_ja
        echo "[INFO] Japanese localization: enabled"
    end

    # Files to download: local_name remote_path
    set -l files "ralph.sh ralph.sh" "prd.json prd.json.example"

    if test "$tool" = "claude"
        set -a files "CLAUDE.md CLAUDE.md"
    else
        set -a files "prompt.md prompt.md"
    end

    # Create scripts/ralph directory if it doesn't exist
    if not test -d "$ralph_dir"
        echo "[INFO] Creating directory: $ralph_dir"
        mkdir -p "$ralph_dir"
    end

    set -l download_count 0
    set -l skip_count 0
    set -l md_files_to_localize

    for file_pair in $files
        set -l parts (string split ' ' $file_pair)
        set -l local_name $parts[1]
        set -l remote_name $parts[2]
        set -l local_path "$ralph_dir/$local_name"
        set -l remote_url "$base_url/$remote_name"

        # Check if file already exists (defensive: don't overwrite)
        if test -e "$local_path"
            echo "[SKIP] File already exists: $local_path"
            set skip_count (math $skip_count + 1)
            continue
        end

        echo "[INFO] Downloading: $remote_name -> $local_path"
        if not curl --proto '=https' --tlsv1.2 -sSf -L "$remote_url" -o "$local_path"
            echo "[ERROR] Failed to download: $remote_url"
            return 1
        end
        set download_count (math $download_count + 1)

        # Track .md files for localization
        if string match -q "*.md" "$local_name"
            set -a md_files_to_localize "$local_path"
        end
    end

    # Make ralph.sh executable
    set -l ralph_script "$ralph_dir/ralph.sh"
    if test -f "$ralph_script"
        chmod +x "$ralph_script"
        echo "[INFO] Made executable: $ralph_script"
    end

    # Install skills for Claude Code
    if test "$tool" = "claude"
        set -l skills_dir "$target_dir/.claude/skills"
        set -l skill_names prd ralph

        for skill_name in $skill_names
            set -l skill_dir "$skills_dir/$skill_name"
            set -l skill_file "$skill_dir/SKILL.md"
            set -l remote_url "$base_url/skills/$skill_name/SKILL.md"

            if test -e "$skill_file"
                echo "[SKIP] Skill already exists: $skill_file"
                set skip_count (math $skip_count + 1)
                continue
            end

            if not test -d "$skill_dir"
                echo "[INFO] Creating directory: $skill_dir"
                mkdir -p "$skill_dir"
            end

            echo "[INFO] Downloading skill: $skill_name -> $skill_file"
            if not curl --proto '=https' --tlsv1.2 -sSf -L "$remote_url" -o "$skill_file"
                echo "[ERROR] Failed to download skill: $remote_url"
                return 1
            end
            set download_count (math $download_count + 1)

            # Track for localization
            set -a md_files_to_localize "$skill_file"
        end
    end

    # Localize .md files to Japanese
    if $localize_ja; and test (count $md_files_to_localize) -gt 0
        echo ""
        echo "[INFO] Localizing files to Japanese..."
        set -l localize_prompt "Translate this markdown file to Japanese. Keep the structure, formatting, and any code blocks intact. Output ONLY the translated content, no explanations."

        for md_file in $md_files_to_localize
            echo "[INFO] Localizing: $md_file"
            set -l original_content (cat "$md_file")
            set -l translated (claude -p "$localize_prompt" < "$md_file" 2>/dev/null)

            if test $status -eq 0; and test -n "$translated"
                printf '%s\n' $translated > "$md_file"
                echo "[INFO] Localized: $md_file"
            else
                echo "[WARN] Failed to localize: $md_file (keeping original)"
            end
        end
    end

    echo ""
    echo "[DONE] Ralph installed to: $ralph_dir"
    echo "       Downloaded: $download_count file(s), Skipped: $skip_count file(s)"
    echo ""
    echo "Next steps:"
    echo "  1. Edit $ralph_dir/prd.json to define your tasks"
    if test "$tool" = "claude"
        echo "  2. Use /prd to generate PRD, /ralph to convert to prd.json"
    end
    echo "  3. Run: $ralph_dir/ralph.sh"
end
