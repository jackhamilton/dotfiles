alias cd=z
alias cat="bat -P"
alias curl=curlie
alias pacin="sudo pacman -S"
alias pacupd="paru -Syu"
alias ls=lsd
alias gcc="sccache gcc"
alias cmake="cmake -DCMAKE_C_COMPILER_LAUNCHER=sccache -DCMAKE_CXX_COMPILER_LAUNCHER=sccache"
alias vdiff="nvim -d"
alias cedit="chezmoi edit"
alias capply="chezmoi apply --exclude=templates"
alias cp="xcp"
alias gittop="git rev-parse --show-toplevel | cd"
alias pls="sudo"
alias q="exit"
alias tlist="tmux list-sessions"
alias detach="tmux detach"
alias attach="tmuxAttach"
alias tmain="tmuxAttachMain"
alias lg="lazygit"
alias gdvim="nvim --listen /tmp/godot.pipe"
alias ovpn="sudo openvpn --config /$HOME/Downloads/uk-644.protonvpn.udp.ovpn --auth-user-pass /opt/ovpn/login.conf"
alias themer="eval \$(themester -r)"
alias smbmount="sudo mount -v -t cifs //192.168.1.11/jack /mnt/media -o credentials=/home/jack/.credentials"
alias gitunskip="git update-index --no-skip-worktree $(git ls-files $(git rev-parse --show-toplevel))"
alias gitskips="git update-index --skip-worktree Grindr.xcworkspace/xcshareddata/swiftpm/Package.resolved"
alias archive="yt-dlp --live-from-start --cookies-from-browser firefox --extractor-args youtubetab:skip=authcheck --windows-filenames --write-thumbnail --embed-thumbnail --embed-metadata --embed-info-json"
alias killall="pkill -9 -f"
alias replace="git checkout origin/main"
gitup ()
{
    git add .
    git commit -m "$1"
    git push
}
tmuxAttachMain ()
{
    tmux new -s "main" -d
    tmux attach -d -t "main"
}
tmuxAttach ()
{
    tmux new -s "$1" -d
    tmux attach -d -t "$1"
}
flake()
{
    nix flake init --template "https://flakehub.com/f/the-nix-way/dev-templates/*#$1"
}
switch()
{
    home-manager switch --flake ~/.config/home-manager/.#$1
}
