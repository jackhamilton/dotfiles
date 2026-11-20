function _apply_themester_environment --description 'Apply environment assignments emitted by Themester'
    for assignment in $argv
        set -l name (string match --regex '^export ([A-Za-z_][A-Za-z0-9_]*)=' -- "$assignment")[2]
        if test -n "$name"
            set -l value (string replace --regex '^export [A-Za-z_][A-Za-z0-9_]*=' '' -- "$assignment" | string trim --chars '"')
            set -gx $name "$value"
        end
    end
end
