function tmuxEnsureSession --argument-names session
    command tmux has-session -t "$session" 2>/dev/null
    or command tmux new-session -d -s "$session" -n (path basename "$PWD")
end
