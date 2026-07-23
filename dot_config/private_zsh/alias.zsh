alias cd=z
alias eza="eza --icons=always"
alias cat="bat -P"
alias curl=curlie
alias pacin="sudo pacman -S"
alias pacupd="paru -Syu"
alias gcc="sccache gcc"
alias cmake="cmake -DCMAKE_C_COMPILER_LAUNCHER=sccache -DCMAKE_CXX_COMPILER_LAUNCHER=sccache"
alias vdiff="nvim -d"
alias cedit="chezmoi edit"
alias capply="chezmoi apply" #--exclude=templates"
alias cp="xcp"
alias gittop="git rev-parse --show-toplevel | cd"
alias q="exit"
alias tlist="tmux list-sessions"
alias detach="tmux detach"
alias attach="tmuxAttach"
alias tmain="tmuxAttachMain"
alias tmain2="tmuxAttachMain2"
alias lg="lazygit"
alias lj="lazyjj"
alias gdvim="nvim --listen /tmp/godot.pipe"
alias ovpn="sudo openvpn --config /$HOME/Downloads/uk-644.protonvpn.udp.ovpn --auth-user-pass /opt/ovpn/login.conf"
alias themer="eval \$(themester -r)"
alias smbmount="sudo mount -v -t cifs -o credentials=/home/jack/.credentials,gid=1000,uid=1000,username=jack //192.168.1.11/jack /mnt/media"
alias archive="yt-dlp --live-from-start --cookies-from-browser firefox --extractor-args youtubetab:skip=authcheck --windows-filenames --write-thumbnail --embed-thumbnail --embed-metadata --embed-info-json"
alias killall="pkill -9 -f"
alias skrg="sk --ansi -i -c 'rg --color=always --line-number \"{}\"'"
alias jira="jiratui ui --search-on-startup --focus-item-on-startup 1"
gitup ()
{
    git add .
    git commit -m "$1"
    git push
}
tmuxAttachMain ()
{
    tmux new-session -A -D -s "main"
}
tmuxAttachMain2 ()
{
    tmux has-session -t "main" 2>/dev/null || tmux new-session -d -s "main"
    tmux new-session -A -D -t "main" -s "main-2" -f active-pane
}
tmuxAttach ()
{
    tmux new-session -A -D -s "$1"
}
flake()
{
    nix flake init --template "https://flakehub.com/f/the-nix-way/dev-templates/*#$1"
}
switch()
{
    home-manager switch --flake ~/.config/home-manager/.#$1
}
cleanup ()
{
    nix-collect-garbage
    paru -Sccd
}
# nix-upgrade 25.11 ex.
nix-upgrade()
{
    nix-channel --add https://channels.nixos.org/nixos-$1 nixos
    nix-channel --update
    nix-collect-garbage -d
}
