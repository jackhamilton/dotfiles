export TMUX_PLUGIN_MANAGER_PATH="$HOME/.config/tmux/plugins"
source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
export _JAVA_AWT_WM_NONREPARENTING=1
export SDL_VIDEODRIVER='wayland,x11,windows'

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export SDL_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/usr/local/bin"

if [[ $(uname) == "Darwin" ]]; then
    # export PATH="$PATH:/Library/Developer/CommandLineTools/usr/bin/sourcekit-lsp"
    export PATH="$PATH:/opt/homebrew/bin"
    export ANDROID_HOME="/$HOME/Library/Android/sdk"
    export JAVA_HOME="/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home"
    export PATH="$JAVA_HOME/bin:$HOME/.maestro/maestro/bin:$PATH"
else
    export PATH="$PATH:$HOME/Android/Sdk/platform-tools"
    export ANDROID_HOME="$HOME/Android/sdk"
    export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
fi
export RUSTC_WRAPPER=sccache
export HOMEBREW_AUTO_UPDATE_SECS=604800
