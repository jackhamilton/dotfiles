# Directory-change hooks
_rename_tmux_window() {
    [[ $TERM_PROGRAM == tmux ]] || return 0
    "$TMUX_PLUGIN_MANAGER_PATH/tmux-window-name/scripts/rename_session_windows.py" \
        >/dev/null 2>&1 &!
}
add-zsh-hook chpwd _rename_tmux_window

# Define direnv-instant's functions without running its eager initialization.
typeset -g __DIRENV_INSTANT_HOOKED=1
eval "$(direnv-instant hook zsh)"
functions[_direnv_instant_usr1_handler]=$functions[TRAPUSR1]

# Compatibility: direnv-instant 1.2.0 and zsh-autocomplete 20f6c34
#
# direnv-instant applies environment updates by sending SIGUSR1 to the shell;
# its generated hook handles that signal with the TRAPUSR1 function saved above.
# zsh-autocomplete's asynchronous completion can remove TRAPUSR1 after a
# completion is opened and cancelled. Without a handler, the next SIGUSR1 takes
# its default action and terminates the shell.
#
# Restore the saved handler before ZLE redraws the command line. Do not replace
# this with the old `_direnv_handler` workaround: direnv-instant no longer
# defines that function. Before removing this compatibility hook, validate in an
# allowed .envrc directory: invoke completion, cancel it, confirm TRAPUSR1 still
# exists, send `kill -USR1 $$`, and confirm the same shell remains alive.
_restore_direnv_usr1_trap() {
    (( $+functions[TRAPUSR1] )) ||
        functions[TRAPUSR1]=$functions[_direnv_instant_usr1_handler]
}
autoload -Uz add-zle-hook-widget
add-zle-hook-widget line-pre-redraw _restore_direnv_usr1_trap

# Start on directory changes and register cleanup only after a daemon exists.
functions[_direnv_instant_start]=$functions[_direnv_hook]
_direnv_hook() {
    add-zsh-hook zshexit _direnv_exit_cleanup
    _direnv_instant_start "$@"
}
add-zsh-hook chpwd _direnv_hook

# A shell opened directly in a direnv project needs its environment immediately.
if [[ -f .envrc ]]; then
    _direnv_hook
fi
