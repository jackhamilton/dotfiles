# Keep type-ahead completion, but never let a slow backend monopolize ZLE.
zstyle ':autocomplete:*' delay 0.10
zstyle ':autocomplete:*' timeout 30.0
zstyle ':autocomplete:*' min-input 2
zstyle ':autocomplete:*:*' list-lines 8

# zsh-autocomplete computes completions in a zpty, but an old zpty can keep
# producing output after the command line has changed.  Cancel that work
# before autocomplete schedules the next generation.  The completion widget
# remains enabled and slow results are allowed to arrive when the buffer is
# unchanged.
autoload -Uz add-zle-hook-widget
_super_autocomplete_cancel_stale() {
    [[ -v _autocomplete__lbuffer ]] || return 0
    [[ $_autocomplete__lbuffer == "$LBUFFER" && $_autocomplete__rbuffer == "$RBUFFER" ]] && return 0

    if [[ -v _autocomplete_async_fd && $_autocomplete_async_fd -ge 10 ]]; then
        zle -F "$_autocomplete_async_fd" 2>/dev/null
        exec {_autocomplete_async_fd}<&- 2>/dev/null
        unset _autocomplete_async_fd
    fi
    zpty -d AUTOCOMPLETE 2>/dev/null || true
    unset _autocomplete__curcontext _autocomplete__lbuffer _autocomplete__rbuffer
}
add-zle-hook-widget line-pre-redraw _super_autocomplete_cancel_stale

zinit light marlonrichert/zsh-autocomplete
zinit light NICHOLAS85/z-a-eval

zinit wait lucid for \
        zdharma-continuum/fast-syntax-highlighting \
        OMZP::alias-finder \
        zpm-zsh/undollar \
        chisui/zsh-nix-shell \
        zsh-users/zsh-completions \
        jeffreytse/zsh-vi-mode \
