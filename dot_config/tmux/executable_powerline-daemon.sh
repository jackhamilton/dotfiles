#!/usr/bin/env bash

# Keep powerline rendering out of tmux's synchronous status formatter.
set -u

home="${HOME}/.config/tmux/plugins/tmux-powerline"
interval=${TMUX_POWERLINE_DAEMON_INTERVAL:-15}
lock="${TMPDIR:-/tmp}/tmux-powerline-daemon-${USER}.lock"

if [ -f "$lock/pid" ]; then
  owner=$(cat "$lock/pid" 2>/dev/null || true)
  if [ -n "$owner" ] && kill -0 "$owner" 2>/dev/null; then exit 0; fi
  rm -f "$lock/pid"
  rmdir "$lock" 2>/dev/null || true
fi
mkdir "$lock" 2>/dev/null || exit 0
printf '%s\n' "$$" >"$lock/pid"
trap 'rm -f "$lock/pid"; rmdir "$lock" 2>/dev/null || true' EXIT HUP INT TERM

while tmux list-sessions >/dev/null 2>&1; do
  panes=$(tmux list-panes -a -F '#{pane_id}') || exit 0
  while IFS= read -r pane; do
    [ -n "$pane" ] || continue
    (
      export TMUX_PANE="$pane"
      left=$("$home/powerline.sh" left 2>/dev/null) || left=''
      right=$("$home/powerline.sh" right 2>/dev/null) || right=''
      session_info=$(tmux display-message -p -t "$pane" '#S:#I.#P' 2>/dev/null) || session_info=''
      left=${left//\#S:\#I.\#P/$session_info}
      tmux set-option -p -t "$pane" @tp_powerline_left "$left" 2>/dev/null || true
      tmux set-option -p -t "$pane" @tp_powerline_right "$right" 2>/dev/null || true
    ) &
  done <<<"$panes"
  wait
  sleep "$interval"
done
