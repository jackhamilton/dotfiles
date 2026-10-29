function ls-wrapper
    if type -q eza
        command eza --icons=always $argv
    else
        command ls $argv
    end
end
