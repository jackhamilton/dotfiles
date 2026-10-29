set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx TMUX_PLUGIN_MANAGER_PATH "$HOME/.config/tmux/plugins"
set -gx RUSTC_WRAPPER sccache
set -gx HOMEBREW_AUTO_UPDATE_SECS 604800
set -gx STARSHIP_CONFIG "$HOME/.config/starship.toml"

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

if test (uname) = Darwin
    set -gx ANDROID_HOME "$HOME/Library/Android/sdk"
    set -gx JAVA_HOME /opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home
    fish_add_path --prepend "$JAVA_HOME/bin" "$HOME/.maestro/maestro/bin"
    fish_add_path --append "$HOME/.cargo/bin"
else
    set -gx ANDROID_HOME "$HOME/Android/sdk"
    fish_add_path --prepend "$ANDROID_HOME/tools" "$ANDROID_HOME/tools/bin" "$ANDROID_HOME/platform-tools"
    fish_add_path --append "$HOME/Android/Sdk/platform-tools" "$HOME/.local/bin"

    if test -x /usr/bin/pacman
        fish_add_path --append /home/linuxbrew/.linuxbrew/bin
    end

    set -gx _JAVA_AWT_WM_NONREPARENTING 1
    set -gx SDL_VIDEODRIVER 'wayland,x11,windows'
    set -gx GTK_IM_MODULE fcitx
    set -gx QT_IM_MODULE fcitx
    set -gx SDL_IM_MODULE fcitx
    set -gx XMODIFIERS @im=fcitx

    set -l xdg_data_dirs /usr/share /var/lib/flatpak/exports/share "$HOME/.local/share/flatpak/exports/share"
    if set -q XDG_DATA_DIRS
        set -a xdg_data_dirs (string split : -- $XDG_DATA_DIRS)
    end
    set -gx XDG_DATA_DIRS (string join : -- $xdg_data_dirs)
end
