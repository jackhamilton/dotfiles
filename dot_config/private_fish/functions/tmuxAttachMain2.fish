function tmuxAttachMain2
    command tmux has-session -t main-2 2>/dev/null
    or command tmux new-session -d -t main -s main-2 -f active-pane
    and command tmux attach-session -d -t main-2
end
