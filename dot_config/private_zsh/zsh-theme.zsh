# Replaced by themester, no longer loaded

RANDOMSEED=$(date +%s)
RANDOM=$(($RANDOMSEED/3600))
export THEMENUM=$RANDOM

# export TERMEMU=$(ps -p $PPID -o comm=)
local alacritty=0

# if [[ $TERMEMU ~= "alacritty" ]] then
if [ $alacritty -eq 1 ]; then
    LOCALTHEME=$((($THEMENUM % 16) + 1))
    case $LOCALTHEME in
        1)
            THEMESTR="tokyo-night"
            ;;
        2)
            THEMESTR="iris"
            ;;
        3)
            THEMESTR="tokyo-night-storm"
            ;;
        4)
            THEMESTR="catppuccin_frappe"
            ;;
        5)
            THEMESTR="catppuccin_macchiato"
            ;;
        6)
            THEMESTR="catppuccin_mocha"
            ;;
        7)
            THEMESTR="gruvbox"
            ;;
        8)
            THEMESTR="gruvbox_material"
            ;;
        9)
            THEMESTR="nightfox"
            ;;
        10)
            THEMESTR="rose-pine"
            ;;
        11)
            THEMESTR="kanagawa_wave"
            ;;
        12)
            THEMESTR="kanagawa_dragon"
            ;;
        13)
            THEMESTR="dracula"
            ;;
        14)
            THEMESTR="inferno"
            ;;
        15)
            THEMESTR="nordic"
            ;;
        16)
            THEMESTR="oceanic_next"
            ;;
    esac
    rm "$HOME/.config/alacritty/themes/themes/current.toml"
    ln -s "$HOME/.config/alacritty/themes/themes/$THEMESTR.toml" "$HOME/.config/alacritty/themes/themes/current.toml"
    alacritty msg config -r -w -1
else
    #if [[ $TERMEMU =~ "wezterm" ]] then
    LOCALTHEME=$((($THEMENUM % 19) + 1))
    case $LOCALTHEME in
        1)
            THEMESTR="tokyonight-night"
            ;;
        2)
            THEMESTR="tokyonight_moon"
            ;;
        3)
            THEMESTR="tokyonight_storm"
            ;;
        4)
            THEMESTR="catppuccin-frappe"
            ;;
        5)
            THEMESTR="catppuccin-macchiato"
            ;;
        6)
            THEMESTR="catppuccin-mocha"
            ;;
        7)
            THEMESTR="GruvboxDark"
            ;;
       8)
            THEMESTR="Gruvbox Dark (Gogh)"
            ;;
        9)
            THEMESTR="nightfox"
            ;;
        10)
            THEMESTR="rose-pine"
            ;;
        11)
            THEMESTR="Kanagawa (Gogh)"
            ;;
        12)
            THEMESTR="Kanagawa Dragon (Gogh)"
            ;;
        13)
            THEMESTR="Everblush"
            ;;
        14)
            THEMESTR="Sonokai (Gogh)"
            ;;
        15)
            THEMESTR="Edge Dark (base16)"
            ;;
        16)
            THEMESTR="firewatch"
            ;;
        17)
            THEMESTR="nordfox"
            ;;
        18)
            THEMESTR="Solarized Dark (Gogh)"
            ;;
        19)
            THEMESTR="kanagawabones"
            ;;
    esac
    #    fi
    rm "$HOME/.config/wezterm/dynamic_theme.lua"
    echo "return \"$THEMESTR\"" > "$HOME/.config/wezterm/dynamic_theme.lua"
fi
