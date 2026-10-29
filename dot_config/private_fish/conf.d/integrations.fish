if status is-interactive
    if type -q direnv-instant
        direnv-instant hook fish | source
    else if type -q direnv
        direnv hook fish | source
    end

    if type -q fzf
        fzf --fish | source
    end

    if type -q sk
        sk --shell fish | source
    end

    if type -q zoxide
        zoxide init --cmd cd fish | source
    end

    if type -q starship
        starship init fish | source
    end

    if type -q jj
        jj util completion fish | source
    end

    if type -q rustup
        rustup completions fish | source
    end
end
