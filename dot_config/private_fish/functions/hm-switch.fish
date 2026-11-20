function hm-switch --argument-names profile
    command home-manager switch --flake "$HOME/Documents/GitHub/nixos-config/home-manager#$profile"
end
