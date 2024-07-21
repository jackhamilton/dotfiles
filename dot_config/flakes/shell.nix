{
    description = "Home manager configuration";

    inputs = {
        nixpkgs.url = "nixpkgs/24.05";
        home-manager.url = "github:nix-community/home-manager/release-24.05";
        # darwin = {
        #     url = "github:lnl7/nix-darwin/master";
        #     inputs.nixpkgs.follows = "nixpkgs";
        # };
        flake-utils = {
            url = "github:numtide/flake-utils";
        };
    };

    outputs = { self, nixpkgs, /*darwin, */flake-utils, home-manager }:
        flake-utils.lib.eachDefaultSystem(system:
            let
                pkgs = import nixpkgs { inherit system; };
            in {
                packages.hello = pkgs.hello;
                devShell = pkgs.mkShell {
                    buildInputs = [ pkgs.cowsay ];
                };
            }
        );
}
