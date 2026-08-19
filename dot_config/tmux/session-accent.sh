#!/bin/sh

# Give grouped tmux sessions distinct active-window accents and mark windows
# active in another attached session with a dimmed version of that accent.
# Updates are event-driven and do not add work to status refreshes.
set -eu

apply_accent() {
	session_id=$1
	accent_index=${session_id#\$}

	case $((accent_index % 4)) in
		0) accent=colour78; dim_accent='#375b43' ;;  # green
		1) accent=colour75; dim_accent='#374f67' ;;  # blue
		2) accent=colour221; dim_accent='#675b37' ;; # yellow
		3) accent=colour208; dim_accent='#67431b' ;; # orange
	esac

	tmux set-option -q -t "$session_id" @session_accent "$accent"
}

refresh_accents() {
	# Serialize hook-triggered refreshes so one update cannot clear another's
	# window markers between its clear and assign phases.
	lock_name=session-accent-update
	tmux wait-for -L "$lock_name"
	trap 'tmux wait-for -U "$lock_name" 2>/dev/null || true' 0 1 2 15

	tmux list-windows -a -F '#{window_id}' | sort -u | while IFS= read -r window_id; do
		tmux set-option -quw -t "$window_id" @session_activity_accent
	done

	tmux list-sessions -F '#{session_id}' | while IFS= read -r session_id; do
		apply_accent "$session_id"

		attached=$(tmux display-message -p -t "$session_id:" '#{session_attached}')
		if [ "$attached" -gt 0 ]; then
			active_window=$(tmux display-message -p -t "$session_id:" '#{window_id}')
			tmux set-option -qw -t "$active_window" @session_activity_accent "$dim_accent"
		fi
	done
}

if [ "${1:-}" = "--all" ]; then
	refresh_accents
fi
