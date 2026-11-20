function ovpn --description 'Connect using the local ProtonVPN configuration'
    set -l credentials /opt/ovpn/login.conf
    set -l configuration "$HOME/Downloads/uk-644.protonvpn.udp.ovpn"

    if not test -r "$credentials"
        printf 'ovpn: credentials file is unavailable: %s\n' "$credentials" >&2
        return 1
    end
    if not test -r "$configuration"
        printf 'ovpn: configuration file is unavailable: %s\n' "$configuration" >&2
        return 1
    end

    command sudo openvpn --config "$configuration" --auth-user-pass "$credentials" $argv
end
