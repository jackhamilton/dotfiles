set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx TMUX_PLUGIN_MANAGER_PATH "$HOME/.config/tmux/plugins"
if type -q sccache
    set -gx RUSTC_WRAPPER sccache
end
set -gx HOMEBREW_AUTO_UPDATE_SECS 604800
set -gx ISNIXSHELL yes
set -gx STARSHIP_CONFIG "$HOME/.config/starship.toml"
set -l terminfo_dirs "$HOME/.nix-profile/share/terminfo"
if set -q TERMINFO_DIRS
    set -a terminfo_dirs (string split : -- "$TERMINFO_DIRS")
end
if not contains -- /usr/share/terminfo $terminfo_dirs
    set -a terminfo_dirs /usr/share/terminfo
end
set -gx TERMINFO_DIRS (string join : -- $terminfo_dirs)

if test -r "$HOME/.config/themester/.themecache"
    _apply_themester_environment (command cat "$HOME/.config/themester/.themecache")
end

if test -d "$HOME/Library/Application Support/jj"
    set -gx JJ_CONFIG "$HOME/Library/Application Support/jj/config.toml"
end

if test -e "$HOME/.gtkrc-2.0"
    set -gx GTK2_RC_FILES "$HOME/.gtkrc-2.0"
end

fish_add_path --prepend "$HOME/.nix-profile/bin" "$HOME/bin" /usr/local/bin /opt/homebrew/bin
fish_add_path --append "$HOME/.cargo/bin" "$HOME/.local/bin"

if test -x "$HOME/.local/share/tmux-window-name-venv/bin/python3"
    fish_add_path --prepend "$HOME/.local/share/tmux-window-name-venv/bin"
end
