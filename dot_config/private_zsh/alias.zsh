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
#alias gittop="cd $(git rev-parse --show-toplevel)"
alias pls="sudo"
gitup ()
{
    git add .
    git commit -m "$1"
    git push
}

