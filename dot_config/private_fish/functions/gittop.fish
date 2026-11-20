function gittop --description 'Change to the current Git repository root'
    set -l root (command git rev-parse --show-toplevel)
    and cd -- "$root"
end
