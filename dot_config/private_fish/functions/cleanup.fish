function cleanup
    command nix-collect-garbage
    or return $status

    if type -q paru
        command paru -Sccd
    end
end
