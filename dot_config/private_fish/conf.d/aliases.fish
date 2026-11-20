alias ls='ls-wrapper'
alias cat='command bat -P'
alias curl='command curlie'
alias vdiff='nvim -d'
alias cedit='chezmoi edit'
alias capply='chezmoi apply'
alias cp='xcp'
alias q='exit'
alias tlist='tmux list-sessions'
alias detach='tmux detach'
alias attach='tmuxAttach'
alias tmain='tmuxAttachMain'
alias tmain2='tmuxAttachMain2'
alias lg='lazygit'
alias lj='lazyjj'
alias gdvim='nvim --listen /tmp/godot.pipe'
alias archive='yt-dlp --live-from-start --cookies-from-browser firefox --extractor-args youtubetab:skip=authcheck --windows-filenames --write-thumbnail --embed-thumbnail --embed-metadata --embed-info-json'
alias killall='pkill -9 -f'
alias jira='jiratui ui --search-on-startup --focus-item-on-startup 1'

if type -q pacman
    alias pacin='sudo pacman -S'
end

if type -q paru
    alias pacupd='paru -Syu'
end

if type -q sccache
    alias gcc='sccache gcc'
    alias cmake='command cmake -DCMAKE_C_COMPILER_LAUNCHER=sccache -DCMAKE_CXX_COMPILER_LAUNCHER=sccache'
end
