function fish_prompt
        # 1. Capture status immediately
        set -l last_status $status

        # 2. Configure Git prompt styles
        set -q __fish_git_prompt_showupstream
        or set -g __fish_git_prompt_showupstream auto
        set -g __fish_git_prompt_char_stateseparator ' '

        # 3. Color Palette Configuration
        set -l frame_color red
        test $last_status = 0; and set frame_color green

        set -l bracket_color cyan

        # 4. Fixed Helper function (No more variable-watching event spam)
        function _enhanced_prompt_wrapper
                set -l f_color $argv[1]
                set -l b_color $argv[2]
                set -l icon $argv[3]
                set -l label $argv[4]
                set -l value $argv[5]

                set_color $f_color; echo -n '─'
                set_color $b_color; echo -n '['

                if test -n "$icon"
                        set_color normal; echo -n "$icon "
                end

                if test -n "$label"
                        set_color -o white; echo -n "$label:"
                end

                set_color normal; echo -n $value
                set_color $b_color; echo -n ']'
        end

        # Line 1: Top Frame Initialization
        set_color $frame_color; echo -n '╭─'
        set_color $bracket_color; echo -n [

        # User Module (Root vs Standard)
        if functions -q fish_is_root_user; and fish_is_root_user
                set_color -o red
        else
                set_color -o yellow
        end
        echo -n $USER

        set_color white; echo -n @

        # Hostname Module (SSH vs Local)
        if test -z "$SSH_CLIENT"
                set_color -o blue
        else
                set_color -o magenta
        end
        echo -n (prompt_hostname)

        # Path Module
        set_color white; echo -n :
        set_color -o normal
        echo -n (prompt_pwd)
        set_color $bracket_color; echo -n ']'

        # Date/Time Module
        _enhanced_prompt_wrapper $frame_color $bracket_color '🕒' '' (date +%X)

        # Conditional Error Module
        if test $last_status -ne 0
                _enhanced_prompt_wrapper $frame_color $bracket_color '❌' 'ERR' (set_color -o red; echo -n $last_status; set_color normal)
        end

        # Vi-Mode Status Module
        if test "$fish_key_bindings" = fish_vi_key_bindings
                or test "$fish_key_bindings" = fish_hybrid_key_bindings
                set -l mode
                switch $fish_bind_mode
                        case default;      set mode (set_color --bold red)N
                        case operator;     set mode (set_color --bold cyan)P
                        case insert;       set mode (set_color --bold green)I
                        case replace_one;  set mode (set_color --bold green)R
                        case replace;      set mode (set_color --bold cyan)R
                        case visual;       set mode (set_color --bold magenta)V
                end
                set mode $mode(set_color normal)
                _enhanced_prompt_wrapper $frame_color $bracket_color '⌨️' '' $mode
        end

        # Python Virtual Environment Module
        set -q VIRTUAL_ENV_DISABLE_PROMPT
        or set -g VIRTUAL_ENV_DISABLE_PROMPT true
        if set -q VIRTUAL_ENV
                _enhanced_prompt_wrapper $frame_color $bracket_color '📦' 'py' (path basename "$VIRTUAL_ENV")
        end

        # Git Module
        set -l prompt_git (fish_git_prompt '%s')
        if test -n "$prompt_git"
                _enhanced_prompt_wrapper $frame_color $bracket_color '🌿' '' $prompt_git
        end

        # Battery Status Module
        if type -q acpi; and acpi -a 2>/dev/null | string match -rq off
                _enhanced_prompt_wrapper $frame_color $bracket_color '⚡' '' (acpi -b | cut -d' ' -f 4-)
        end

        # Move to Line 2
        echo

        # Background Jobs Handling
        for job in (jobs)
                set_color $frame_color; echo -n '├─'
                set_color yellow; echo " ⚙️  $job"
        end

        # Line 2: Terminal Input Line
        set_color $frame_color; echo -n '╰─→ '
        set_color -o normal; echo -n '$ '
        set_color normal
end
