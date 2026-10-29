if status is-interactive
    set -g fish_greeting
    fish_vi_key_bindings
end

alias eza='command eza --icons=always'
alias cat='command bat -P'
alias curl='command curlie'
alias pacin='sudo pacman -S'
alias pacupd='paru -Syu'
alias gcc='sccache gcc'
alias cmake='command cmake -DCMAKE_C_COMPILER_LAUNCHER=sccache -DCMAKE_CXX_COMPILER_LAUNCHER=sccache'
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

function gittop
    set -l root (command git rev-parse --show-toplevel)
    and cd -- "$root"
end

function skrg
    command sk --ansi -i -c 'rg --color=always --line-number {}' $argv
end

function themer
    _apply_themester_environment (command themester -r)
end

function _apply_themester_environment
    for assignment in $argv
        set -l name (string match --regex '^export ([A-Za-z_][A-Za-z0-9_]*)=' -- "$assignment")[2]
        if test -n "$name"
            set -l value (string replace --regex '^export [A-Za-z_][A-Za-z0-9_]*=' '' -- "$assignment" | string trim --chars '"')
            set -gx $name "$value"
        end
    end
end

if test -r "$HOME/.config/themester/.themecache"
    _apply_themester_environment (command cat "$HOME/.config/themester/.themecache")
end

if test -r /opt/ovpn/login.conf
    function ovpn
        sudo openvpn --config "$HOME/Downloads/uk-644.protonvpn.udp.ovpn" --auth-user-pass /opt/ovpn/login.conf $argv
    end
end

if test -r /home/jack/.credentials
    function smbmount
        sudo mount -v -t cifs -o credentials=/home/jack/.credentials,gid=1000,uid=1000,username=jack //192.168.1.11/jack /mnt/media $argv
    end
end
