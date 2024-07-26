
RANDOMSEED=$(date +%s)
RANDOM=$(($RANDOMSEED/3600))
export THEMENUM=$RANDOM
LOCALTHEME=$(((($THEMENUM % 22) % 17) + 1))
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
        THEMESTR="catppuccin_mocha"
        ;;
    5)
        THEMESTR="catppuccin_frappe"
        ;;
    6)
        THEMESTR="catppuccin_macchiato"
        ;;
    7)
        THEMESTR="catppuccin_mocha"
        ;;
    8)
        THEMESTR="gruvbox"
        ;;
    9)
        THEMESTR="gruvbox_material"
        ;;
    10)
        THEMESTR="nightfox"
        ;;
    11)
        THEMESTR="rose-pine"
        ;;
    12)
        THEMESTR="kanagawa_wave"
        ;;
    13)
        THEMESTR="kanagawa_dragon"
        ;;
    14)
        THEMESTR="dracula"
        ;;
    15)
        THEMESTR="inferno"
        ;;
    16)
        THEMESTR="nordic"
        ;;
    17)
        THEMESTR="oceanic_next"
        ;;
esac
rm "$HOME/.config/alacritty/themes/themes/current.toml"
ln -s "$HOME/.config/alacritty/themes/themes/$THEMESTR.toml" "$HOME/.config/alacritty/themes/themes/current.toml"
alacritty msg config -r -w -1
