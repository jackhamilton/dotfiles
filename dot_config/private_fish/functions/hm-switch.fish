function hm-switch --argument-names profile
    command home-manager switch --flake "$HOME/.config/home-manager/.$profile"
end
