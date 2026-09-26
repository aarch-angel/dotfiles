function fish_user_key_bindings
    __mode_bind default,insert ctrl-l 'fish_greeting; echo -e "\n"' repaint
    __mode_bind default,insert ctrl-z 'fg 2>/dev/null' repaint

    #bind -M insert \eF 'thefuck-command-line'  # Bind Alt-f to thefuck
    #bind -M insert \ef 'fuck'
end

function __mode_bind -d "Bind keys with multiple modes at once"
    # Usage: __mode_bind mode1,mode2,mode3 [bind_args...]

    set -l modes (string split ',' $argv[1])
    set -l bind_args $argv[2..] # all remaining arguments

    # Bind to each specified mode
    for mode in $modes
        bind -M $mode $bind_args
    end
end
