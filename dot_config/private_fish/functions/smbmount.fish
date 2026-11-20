function smbmount --description 'Mount the local media share'
    set -l credentials "$HOME/.credentials"
    if not test -r "$credentials"
        printf 'smbmount: credentials file is unavailable: %s\n' "$credentials" >&2
        return 1
    end

    command sudo mount -v -t cifs -o "credentials=$credentials,gid=1000,uid=1000,username=jack" //192.168.1.11/jack /mnt/media $argv
end
