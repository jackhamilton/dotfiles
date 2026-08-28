#!/usr/bin/env bash

# TPM loads plugins asynchronously from tmux.conf.  Wait for powerline to
# install its options, then replace only its synchronous status commands.
set -u
for attempt in $(jot 20 1); do
  left=$(tmux show-option -gqv status-left 2>/dev/null || true)
  case "$left" in
    *tmux-powerline*/powerline.sh*)
      tmux set-option -g status-left '#{@tp_powerline_left}'
      tmux set-option -g status-right '#{@tp_powerline_right}'
      tmux run-shell -b "$HOME/.config/tmux/powerline-daemon.sh"
      exit 0
      ;;
  esac
  sleep 0.25
done
exit 0
