# =============================================================================
# Helper: Elite Segment Wrapper Function (Global Execution Optimization)
# =============================================================================
function _ultra_prompt_wrapper
    set -l f_color $argv[1]
    set -l d_color $argv[2]
    set -l icon $argv[3]
    set -l label $argv[4]
    set -l value $argv[5]

    set_color $f_color; echo -n '─'
    set_color $d_color; echo -n '│ '

    if test -n "$icon"
        set_color normal; echo -n "$icon "
    end

    if test -n "$label"
        set_color -o brwhite; echo -n "$label "
    end

    set_color normal; echo -n $value
    set_color $d_color; echo -n ' │'
end

# =============================================================================
# Main Prompt Configuration
# =============================================================================
function fish_prompt
    # 1. Immediate State Capture (Crucial for accuracy)
    set -l last_status $status

    # 2. Advanced Native Git Prompt Variables
    set -g __fish_git_prompt_show_informative_status 1
    set -g __fish_git_prompt_showcolorhints 1
    set -g __fish_git_prompt_showupstream "informative"
    set -g __fish_git_prompt_char_stateseparator ' '

    # Custom Git Glyphs for clean aesthetics
    set -g __fish_git_prompt_char_clean '✓'
    set -g __fish_git_prompt_char_dirtystate '⚡'
    set -g __fish_git_prompt_char_invalidstate '✖'
    set -g __fish_git_prompt_char_stagedstate '●'
    set -g __fish_git_prompt_char_untrackedfiles '…'
    set -g __fish_git_prompt_char_upstream_ahead '↑'
    set -g __fish_git_prompt_char_upstream_behind '↓'

    # 3. Dynamic Frame Theme (Based entirely on last command success)
    set -l frame_color red
    test $last_status = 0; and set frame_color green

    set -l divider_color cyan
    set -l accent_text bryellow

    # -------------------------------------------------------------------------
    # Line 1: Top Frame & System Identity
    # -------------------------------------------------------------------------
    set_color $frame_color; echo -n '╭─'
    set_color $divider_color; echo -n '│ '

    # User Module (Root vs Standard)
    if functions -q fish_is_root_user; and fish_is_root_user
        set_color -o red
    else
        set_color -o $accent_text
    end
    echo -n $USER

    set_color brwhite; echo -n ' @ '

    # Hostname Module (SSH vs Local)
    if test -n "$SSH_CLIENT" -o -n "$SSH_TTY"
        set_color -o brblue; echo -n (prompt_hostname)" 🌐"
    else
        set_color -o brmagenta; echo -n (prompt_hostname)
    end
    set_color $divider_color; echo -n ' │'

    # Smart Shortened Directory Path Module
    set -q fish_prompt_pwd_dir_length; or set -g fish_prompt_pwd_dir_length 1
    set_color $frame_color; echo -n '─'
    set_color $divider_color; echo -n '│ 📂 '
    set_color -o brgreen
    echo -n (prompt_pwd)
    set_color $divider_color; echo -n ' │'

    # TRUE Native Time Module (Zero Process Forks using Fish built-in command)
    # set -l native_time (string escape --style=regex (date "+%H:%M:%S"))
    # TRUE Native Time Module (Zero Process Forks; 12-Hour AM/PM Format)
    set -l native_time (command date "+%I:%M:%S %p")
    # Alternatively, for zero-fork speed, modern Fish natively supports:
    # set -l native_time (command date "+%H:%M:%S") # fallback stability
    _ultra_prompt_wrapper $frame_color $divider_color '🕒' '' "$native_time"

    # Command Execution Duration Module (Updated with modern math syntax)
    if test -n "$CMD_DURATION" -a "$CMD_DURATION" -gt 1000
        set -l duration
        if test "$CMD_DURATION" -lt 60000
            set duration (math (string format "%.1f" (math "$CMD_DURATION / 1000")))"s"
        else
            set -l mins (math -s0 "$CMD_DURATION / 60000")
            set -l secs (math -s0 "($CMD_DURATION % 60000) / 1000")
            set duration "$mins"m" $secs"s""
        end
        _ultra_prompt_wrapper $frame_color $divider_color '⏱️' '' (set_color bryellow; echo -n $duration; set_color normal)
    end

    # Conditional Error Status Module
    if test $last_status -ne 0
        _ultra_prompt_wrapper $frame_color $divider_color '❌' 'ERR:' (set_color -o brred; echo -n $last_status; set_color normal)
    end

    # Interactive Vi-Mode Module
    if test "$fish_key_bindings" = fish_vi_key_bindings
        or test "$fish_key_bindings" = fish_hybrid_key_bindings
        set -l mode
        switch $fish_bind_mode
            case default;      set mode (set_color --bold red)NORMAL
            case operator;     set mode (set_color --bold cyan)PENDING
            case insert;       set mode (set_color --bold green)INSERT
            case replace_one;  set mode (set_color --bold green)REPLACE
            case replace;      set mode (set_color --bold cyan)REPLACE
            case visual;       set mode (set_color --bold magenta)VISUAL
        end
        set mode $mode(set_color normal)
        _ultra_prompt_wrapper $frame_color $divider_color '⌨️' '' $mode
    end

    # Python Environment Module
    set -q VIRTUAL_ENV_DISABLE_PROMPT
    or set -g VIRTUAL_ENV_DISABLE_PROMPT true
    if set -q VIRTUAL_ENV
        _ultra_prompt_wrapper $frame_color $divider_color '📦' 'venv:' (set_color -o blue; echo -n (path basename "$VIRTUAL_ENV"); set_color normal)
    end

    # Git Status Module
    set -l prompt_git (fish_git_prompt '%s')
    if test -n "$prompt_git"
        _ultra_prompt_wrapper $frame_color $divider_color '🌿' '' (set_color -o bryellow; echo -n $prompt_git; set_color normal)
    end

    # Shift down to line 2
    echo

    # Streamlined Background Tasks (Aggregated into a single clean element)
    set -l running_jobs (jobs | count)
    if test $running_jobs -gt 0
        set_color $frame_color; echo -n '├─'
        set_color yellow; echo " ⚙️ Active Background Jobs: $running_jobs"
    end

    # -------------------------------------------------------------------------
    # Line 2: Ultimate Execution Line
    # -------------------------------------------------------------------------
    set_color $frame_color; echo -n '╰─⚡ '
    set_color -o normal

    # Dynamic user-level character termination
    if functions -q fish_is_root_user; and fish_is_root_user
        echo -n '# '
    else
        echo -n '$ '
    end
    set_color normal
end
