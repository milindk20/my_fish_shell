function fish_prompt
        # 1. Capture status immediately
        set -l last_status $status

        # 2. Configure Git prompt styles
        set -q __fish_git_prompt_showupstream
        or set -g __fish_git_prompt_showupstream auto
        set -g __fish_git_prompt_char_stateseparator ' '

        # 3. Premium Color Palette Configuration
        set -l frame_color red
        test $last_status = 0; and set frame_color green
        
        set -l divider_color cyan
        set -l accent_text bryellow

        # 4. Premium Segment Wrapper Function
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
    
        # Line 1: Top Frame & System Identity
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
    
        # Dynamic Directory Path Module
        set_color $frame_color; echo -n '─'
        set_color $divider_color; echo -n '│ 📂 '
        set_color -o brgreen
        echo -n (prompt_pwd)
        set_color $divider_color; echo -n ' │'
    
        # Compact 24-Hour Time Module
        _ultra_prompt_wrapper $frame_color $divider_color '🕒' '' (date +%H:%M:%S)

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
    
        # Battery Indicator Module
        if type -q acpi; and acpi -a 2>/dev/null | string match -rq off
                _ultra_prompt_wrapper $frame_color $divider_color '⚡' '' (acpi -b | cut -d' ' -f 4-)
        end
    
        # Shift down to line 2
        echo
    
        # Active Background Engine Tasks
        for job in (jobs)
                set_color $frame_color; echo -n '├─'
                set_color yellow; echo " ⚙️  $job"
        end
    
        # Line 2: Ultimate Execution Line
        set_color $frame_color; echo -n '╰─⚡ '
        set_color -o normal; echo -n '$ '
        set_color normal
end