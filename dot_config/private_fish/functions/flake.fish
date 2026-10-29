function flake --argument-names template
    command nix flake init --template "https://flakehub.com/f/the-nix-way/dev-templates/*#$template"
end
