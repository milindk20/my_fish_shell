# =============================================================================
# Helper: Neo-Aesthetic Segment Wrapper (Capsule Design)
# =============================================================================
function _ultra_prompt_wrapper
    set -l bg_color $argv[1]
    set -l fg_color $argv[2]
    set -l icon $argv[3]
    set -l label $argv[4]
    set -l value $argv[5]

    # Smooth Left Pill Cap
    set_color $bg_color; echo -n " "
    set_color -b $bg_color

    # Icon Element
    if test -n "$icon"
        set_color $fg_color; echo -n "$icon "
    end

    # Text Label Element
    if test -n "$label"
        set_color -o brwhite; echo -n "$label "
    end

    # Inner Payload Data
    set_color $fg_color; echo -n $value

    # Smooth Right Pill Cap
    set_color normal; set_color $bg_color; echo -n ""
    set_color normal
end

# =============================================================================
# Main Prompt Configuration
# =============================================================================
function fish_prompt
    set -l last_status $status

    # Advanced Native Git Configuration
    set -g __fish_git_prompt_show_informative_status 1
    set -g __fish_git_prompt_showcolorhints 1
    set -g __fish_git_prompt_showupstream "informative"
    set -g __fish_git_prompt_char_stateseparator ' '
    
    # Elegant Pastel Git Glyphs
    set -g __fish_git_prompt_char_clean '✔'
    set -g __fish_git_prompt_char_dirtystate ' ⟳'
    set -g __fish_git_prompt_char_invalidstate ' ✖'
    set -g __fish_git_prompt_char_stagedstate ' ●'
    set -g __fish_git_prompt_char_untrackedfiles ' …'
    set -g __fish_git_prompt_char_upstream_ahead ' ↑'
    set -g __fish_git_prompt_char_upstream_behind ' ↓'

    # --- Elite Pastel Color Palette (Dracula/Nord Theme Fusion) ---
    set -l co_bg_dark     303446
    set -l co_user_bg     8cfaff  # Electric Ice
    set -l co_user_fg     232634
    set -l co_dir_bg      b5eafe  # Soft Mint
    set -l co_dir_fg      232634
    set -l co_git_bg      f9e2af  # Pastel Wheat
    set -l co_git_fg      232634
    set -l co_time_bg     cba6f7  # Lavender
    set -l co_time_fg     232634
    set -l co_stats_bg    eeba6f  # Amber Gold
    set -l co_stats_fg    232634
    
    # Dynamic Frame Accents based on command integrity
    set -l frame_color    81a1c1  # Sleek Frost Blue
    test $last_status = 0; or set frame_color b48ead  # Muted Coral Red

    # -------------------------------------------------------------------------
    # Line 1: Top Frame & Styled Segment Capsules
    # -------------------------------------------------------------------------
    set_color $frame_color; echo -n '╭─'

    # 1. Identity Segment (User @ Host)
    set -l host_icon "💻"
    if test -n "$SSH_CLIENT" -o -n "$SSH_TTY"
        set host_icon "🌐"
    end
    _ultra_prompt_wrapper $co_user_bg $co_user_fg $host_icon "" "$USER@(prompt_hostname)"

    # 2. Directory Capsule
    set -q fish_prompt_pwd_dir_length; or set -g fish_prompt_pwd_dir_length 2
    _ultra_prompt_wrapper $co_dir_bg $co_dir_fg "📂" "" (prompt_pwd)

    # 3. Native Fluid Git Module
    set -l prompt_git (fish_git_prompt '%s')
    if test -n "$prompt_git"
        _ultra_prompt_wrapper $co_git_bg $co_git_fg "🌿" "" $prompt_git
    end

    # 4. Humanized Command Duration Module
    if test -n "$CMD_DURATION" -a "$CMD_DURATION" -gt 1000
        set -l duration
        if test "$CMD_DURATION" -lt 60000
            set duration (math -s1 "$CMD_DURATION / 1000")"s"
        else
            set -l mins (math -s0 "$CMD_DURATION / 60000")
            set -l secs (math -s0 "($CMD_DURATION % 60000) / 1000")
            set duration "$mins"m" $secs"s""
        end
        _ultra_prompt_wrapper $co_stats_bg $co_stats_fg "⏱️" "" $duration
    end

    # 5. Native Clock Engine
    _ultra_prompt_wrapper $co_time_bg $co_time_fg "🕒" "" (date "+%H:%M:%S")

    # 6. Failure State Banner
    if test $last_status -ne 0
        _ultra_prompt_wrapper ea999c 232634 "⚠️" "ERR" $last_status
    end

    # 7. Virtual Environments (Python Context)
    if set -q VIRTUAL_ENV
        _ultra_prompt_wrapper 81c8be 232634 "📦" "" (path basename "$VIRTUAL_ENV")
    end

    # 8. Interactive Vi Mode State
    if test "$fish_key_bindings" = fish_vi_key_bindings
        or test "$fish_key_bindings" = fish_hybrid_key_bindings
        set -l mode_color f2d5cf
        set -l mode_text "NORM"
        switch $fish_bind_mode
            case default;      set mode_color e5c890; set mode_text "NORMAL"
            case insert;       set mode_color a6d189; set mode_text "INSERT"
            case visual;       set mode_color ca9ee6; set mode_text "VISUAL"
            case replace_one -f case replace; set mode_color e78284; set mode_text "REPLACE"
        end
        _ultra_prompt_wrapper $mode_color 232634 "⌨️" "" $mode_text
    end

    # Shift down to line 2
    echo

    # Render Active Background Jobs 
    for job in (jobs)
        set_color $frame_color; echo -n '├─'
        set_color e5c890; echo " ⚙️  $job"
    end

    # -------------------------------------------------------------------------
    # Line 2: Terminal Interactive Core
    # -------------------------------------------------------------------------
    set_color $frame_color; echo -n '╰─'
    
    # Interactive status coloring for execution indicator
    if functions -q fish_is_root_user; and fish_is_root_user
        set_color -o e78284; echo -n '⚡ # '
    else
        set_color -o a6d189; echo -n '✨ $ '
    end
    set_color normal
end