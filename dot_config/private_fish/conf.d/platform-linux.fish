if test (uname) != Darwin
    set -l android_home "$HOME/Android/Sdk"
    if not test -d "$android_home"; and test -d "$HOME/Android/sdk"
        set android_home "$HOME/Android/sdk"
    end
    if test -d "$android_home"
        set -gx ANDROID_HOME "$android_home"
        fish_add_path --prepend "$ANDROID_HOME/platform-tools"
    end
    fish_add_path --append "$HOME/.local/bin"

    if test -x /usr/bin/pacman
        fish_add_path --append /home/linuxbrew/.linuxbrew/bin
    end

    set -l emsdk_fish "$HOME/Documents/GitHub/godot/emsdk/emsdk_env.fish"
    if test -r "$emsdk_fish"
        source "$emsdk_fish" >/dev/null
    end

    set -gx _JAVA_AWT_WM_NONREPARENTING 1
    set -gx SDL_VIDEODRIVER 'wayland,x11,windows'
    set -gx GTK_IM_MODULE fcitx
    set -gx QT_IM_MODULE fcitx
    set -gx SDL_IM_MODULE fcitx
    set -gx XMODIFIERS @im=fcitx

    set -l xdg_data_dirs
    if set -q XDG_DATA_DIRS
        set -a xdg_data_dirs (string split : -- "$XDG_DATA_DIRS")
    end
    for directory in /usr/share /var/lib/flatpak/exports/share "$HOME/.local/share/flatpak/exports/share"
        if not contains -- "$directory" $xdg_data_dirs
            set -a xdg_data_dirs "$directory"
        end
    end
    set -gx XDG_DATA_DIRS (string join : -- $xdg_data_dirs)
end
