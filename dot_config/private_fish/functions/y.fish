function y --description 'Open Yazi and change to its last directory on exit'
    set -l temp_file (mktemp -t yazi-cwd.XXXXXX)
    or return $status

    command yazi $argv --cwd-file="$temp_file"
    set -l yazi_status $status

    if test -r "$temp_file"
        set -l cwd (string collect < "$temp_file")
        if test -n "$cwd" -a "$cwd" != "$PWD" -a -d "$cwd"
            cd -- "$cwd"
        end
    end

    command rm -f -- "$temp_file"
    return $yazi_status
end
