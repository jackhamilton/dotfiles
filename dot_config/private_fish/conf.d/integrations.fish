function _rename_tmux_window --on-variable PWD
    test "$TERM_PROGRAM" = tmux
    or return 0

    set -l window_id (command tmux display-message -p -t "$TMUX_PANE" '#{window_id}')
    or return 0

    set -l directory_name (path basename "$PWD")
    if test -z "$directory_name"
        set directory_name /
    end

    command tmux rename-window -t "$window_id" " $directory_name"
    command tmux set-option -w -t "$window_id" automatic-rename-format " $directory_name"
    command tmux set-option -w -t "$window_id" automatic-rename on
    command tmux set-option -w -t "$window_id" @tmux_window_name_enabled 1
end

if status is-interactive
    if type -q fzf
        fzf --fish | source
    end

    if type -q sk
        sk --shell fish | source
    end

    if type -q starship
        starship init fish | source
    end

    if type -q jj
        jj util completion fish | source
    end

    if type -q rustup
        rustup completions fish | source
    end
end
