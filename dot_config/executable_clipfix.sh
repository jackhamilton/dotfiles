#!/usr/bin/env sh
# Find-and-replaces any text copied to the clipboard.
#
# Somewhere in your linux config, it runs wl-paste --type text.
# To use this script, replace that call with:
# /bin/sh -c 'wl-paste --type text --watch /home/jack/.config/clipfix.sh'
# replacing the .sh with whereever you've put this. Make sure
# to use absolute paths, it's often not able to expand ~ yet.
# 
# If you can't find your call, the following in your
# .zshrc or .bashrc will also work:
#
# pkill -9 -f wl-paste
# /bin/sh -c 'wl-paste --type text --watch /home/jack/.config/clipfix.sh' &
# wl-paste --type image --watch cliphist store &
#
#
# Oh, and make sure you chmod +x the script when you copy it.

orig="$(cat)"
[ -n "$orig" ] || exit 0

new="$(printf '%s' "$orig" | sed 's#x\.com#fxtwitter.com#g')"

# if you use a clipboard manager. cliphist store with whatever you use
printf '%s' "$new" | cliphist store

if [ "$new" != "$orig" ]; then
  printf '%s' "$new" | wl-copy
fi
