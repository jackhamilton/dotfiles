_zoxide_z_autocomplete() {
    if [[ $CURRENT == 2 && -n $PREFIX ]]; then
        local -a directories
        directories=( "${(@f)$(command zoxide query --list -- "$PREFIX" 2>/dev/null)}" )

        if (( ${#directories} )); then
            local -a display_directories
            local directory
            for directory in "${directories[@]}"; do
                if [[ $directory == "$HOME" || $directory == "$HOME/"* ]]; then
                    display_directories+=( "~${directory#"$HOME"}" )
                else
                    display_directories+=( "$directory" )
                fi
            done

            compadd -U -S / -d display_directories -- "${directories[@]}"
            return
        fi
    fi

    __zoxide_z_complete
}

_zoxide_register_autocomplete_completion() {
    (( ${+functions[compdef]} )) || return

    compdef _zoxide_z_autocomplete z
    add-zsh-hook -d precmd _zoxide_register_autocomplete_completion
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _zoxide_register_autocomplete_completion
