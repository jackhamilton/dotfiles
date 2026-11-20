if status is-interactive
    if type -q direnv-instant
        direnv-instant hook fish | source
    else if type -q direnv
        direnv hook fish | source
    end
end
