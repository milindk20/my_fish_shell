function fish_prompt
    # Colors
    set user_color (set_color -o blue)
    set host_color (set_color -o green)
    set path_color (set_color -o blue)
    set success_color (set_color -o green)
    set error_color (set_color -o red)
    set symbol_color (set_color -o white)
    set reset_color (set_color normal)

    # Components
    set user (whoami)
    set host (hostname -s)   # short hostname
    set cwd (string replace -r "^$HOME" "~" (pwd))

    # Build prompt
    echo -n "$user_color$user$reset_color@$host_color$host "
    echo -n "$path_color$cwd$reset_color"

    echo
    echo -n "❯❯❯❯ $reset_color"
end

