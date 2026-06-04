# =============================================================================
# Helper: Premium Segment Wrapper Function
# (Defined globally so it doesn't compile on every single keystroke)
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
    # 1. Capture status immediately
    set -l last_status $status

    # 2. Configure Git prompt styles
    set -q __fish_git_prompt_showupstream
    or set -g __fish_git_prompt_showupstream auto
    set -g __fish_git_prompt_char_stateseparator ' '

    # 3. Dynamic Frame Color Theme based on status
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
    if test -z "$SSH_CLIENT"
        set_color -o brmagenta
    else
        set_color -o brblue
    end
    echo -n (prompt_hostname)
    set_color $divider_color; echo -n ' │'

    # Dynamic Directory Path Module (Limits depth components to keep prompt tidy)
    set_color $frame_color; echo -n '─'
    set_color $divider_color; echo -n '│ 📂 '
    set_color -o brgreen
    echo -n (prompt_pwd)
    set_color $divider_color; echo -n ' │'

    # Lightning Fast Time Module (Uses native fish variables instead of calling `date`)
    _ultra_prompt_wrapper $frame_color $divider_color '🕒' '' (set_color normal; date +%H:%M:%S)

    # Command Execution Duration Module (NEW: Shows how long heavy tasks took)
    if test -n "$CMD_DURATION" -a "$CMD_DURATION" -gt 1000
        set -l duration (math -s1 "$CMD_DURATION / 1000")
        _ultra_prompt_wrapper $frame_color $divider_color '⏱️' '' (set_color bryellow; echo -n $duration"s"; set_color normal)
    end

    # Conditional Error Status Module
    if test $last_status -ne 0
        _ultra_prompt_wrapper $frame_color $divider_color '❌' 'ERR' (set_color -o brred; echo -n $last_status; set_color normal)
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

    # Cross-Platform Battery Indicator Module (Linux & macOS friendly)
    if type -q acpi; and acpi -a 2>/dev/null | string match -rq off
        _ultra_prompt_wrapper $frame_color $divider_color '⚡' '' (acpi -b | cut -d' ' -f 4-)
    # MacOS Support fallback
    else if type -q pmset; and pmset -g batt 2>/dev/null | string match -rq "Discharging"
        set -l mac_batt (pmset -g batt | grep -Eo "\d+%" | head -n1)
        _ultra_prompt_wrapper $frame_color $divider_color '🔋' '' (set_color normal; echo -n $mac_batt)
    end

    # Shift down to line 2
    echo

    # Active Background Engine Tasks
    for job in (jobs)
        set_color $frame_color; echo -n '├─'
        set_color yellow; echo " ⚙️   $job"
    end

    # -------------------------------------------------------------------------
    # Line 2: Ultimate Execution Line
    # -------------------------------------------------------------------------
    set_color $frame_color; echo -n '╰─⚡ '
    set_color -o normal
    
    # Change prompt character to '#' if running as root
    if functions -q fish_is_root_user; and fish_is_root_user
        echo -n '# '
    else
        echo -n '$ '
    end
    set_color normal
end