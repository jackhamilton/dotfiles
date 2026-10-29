function tmuxAttachSession --argument-names session
    tmuxEnsureSession "$session"
    and command tmux attach-session -d -t "$session"
end
