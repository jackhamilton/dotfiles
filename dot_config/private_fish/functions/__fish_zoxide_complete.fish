function __fish_zoxide_complete
    set -l query (commandline --current-token)

    if test -n "$query"
        set -l directories (command zoxide query --list -- "$query" 2>/dev/null)
        if test (count $directories) -gt 0
            for directory in $directories
                set -l home_length (string length -- "$HOME")
                set -l directory_home_prefix (string sub --length $home_length -- "$directory")

                if test "$directory_home_prefix" = "$HOME"
                    set -l directory_suffix (string sub --start (math $home_length + 1) --length 1 -- "$directory")

                    if test "$directory" = "$HOME"; or test "$directory_suffix" = /
                        set -l query_home_prefix (string sub --length $home_length -- "$query")
                        set -l query_suffix (string sub --start (math $home_length + 1) --length 1 -- "$query")
                        set -l query_is_absolute false

                        if test "$query_home_prefix" = "$HOME"
                            if test "$query" = "$HOME"; or test "$query_suffix" = /
                                set query_is_absolute true
                            end
                        end

                        if test "$query_is_absolute" = true
                            printf '%s\n' "$directory"
                        else
                            printf '~%s\n' (string sub --start (math $home_length + 1) -- "$directory")
                        end
                    else
                        printf '%s\n' "$directory"
                    end
                else
                    printf '%s\n' "$directory"
                end
            end
            return
        end
    end

    __fish_complete_directories
end
