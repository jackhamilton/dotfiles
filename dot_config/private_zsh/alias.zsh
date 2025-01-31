alias cd=z
alias cat="bat -P"
alias curl=curlie
alias pacin="sudo pacman -S"
alias ls=lsd
alias gcc="sccache gcc"
alias cmake="cmake -DCMAKE_C_COMPILER_LAUNCHER=sccache -DCMAKE_CXX_COMPILER_LAUNCHER=sccache"
alias vdiff="nvim -d"
alias cedit="chezmoi edit"
alias capply="chezmoi apply"
alias cp="xcp"
alias gittop="git rev-parse --show-toplevel | cd"
alias pls="sudo"
alias q="exit"
alias tlist="tmux list-sessions"
alias tdet="tmux detach"
alias tatt="tmuxAttach"
alias tmain="tmuxAttachMain"
alias lg="lazygit"
alias gdvim="nvim --listen /tmp/godot.pipe"
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
