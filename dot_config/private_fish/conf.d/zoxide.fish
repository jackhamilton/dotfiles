if status is-interactive; and type -q zoxide
    zoxide init --cmd cd fish | source
    complete --command cd --no-files --arguments '(__fish_zoxide_complete)'
end
