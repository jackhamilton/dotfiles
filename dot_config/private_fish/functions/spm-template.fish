function spm-template --description 'Initialize a Swift package and populate it from spm-template'
    set -l temp_root /tmp
    if set -q TMPDIR
        set temp_root $TMPDIR
    end

    set -l template_dir (mktemp -d "$temp_root/spm-template.XXXXXX")
    or return $status

    command git clone --branch main --single-branch https://github.com/jackhamilton/spm-template.git "$template_dir"
    set -l clone_status $status
    if test $clone_status -ne 0
        printf 'spm-template: failed to clone template (exit %d)\n' $clone_status >&2
        command rm -rf -- "$template_dir"
        return $clone_status
    end

    command swift package init $argv 2>&1
    set -l init_status $status
    if test $init_status -ne 0
        printf 'spm-template: swift package init failed (exit %d)\n' $init_status >&2
        command rm -rf -- "$template_dir"
        return $init_status
    end

    command rsync -a --exclude=.git/ "$template_dir/" ./
    set -l rsync_status $status
    command rm -rf -- "$template_dir"

    if test $rsync_status -ne 0
        printf 'spm-template: failed to copy template (exit %d)\n' $rsync_status >&2
    end
    return $rsync_status
end
