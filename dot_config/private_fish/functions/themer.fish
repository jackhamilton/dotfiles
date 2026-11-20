function themer --description 'Apply the current Themester environment'
    if not type -q themester
        printf 'themer: themester is not installed\n' >&2
        return 127
    end

    set -l assignments (command themester -r)
    or return $status
    _apply_themester_environment $assignments
end
