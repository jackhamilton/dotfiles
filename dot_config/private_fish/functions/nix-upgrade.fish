function nix-upgrade --argument-names version
    command nix-channel --add "https://channels.nixos.org/nixos-$version" nixos
    and command nix-channel --update
    and command nix-collect-garbage -d
end
