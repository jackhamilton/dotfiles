{
  description = "Home Manager configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
  let
    # small helper to build a Home Manager config for a given system/identity
    mkHome = { system, username, homeDirectory, modules ? [ ] }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; };
        # your base module(s) + host-specific tweaks
        modules = [
            ./home.nix
            ./repos.nix
        ] ++ modules;

        extraSpecialArgs = {
          inherit username homeDirectory;
        };
      };
  in {
    # Name each target explicitly. Pick names you’ll remember at the CLI.
    homeConfigurations = {
      "darwin" = mkHome {
        system        = "aarch64-darwin";
        username      = "jackhamilton";
        homeDirectory = "/Users/jackhamilton";
      };

      "darwin-intel" = mkHome {
        system        = "x86_64-darwin";
        username      = "jackhamilton";
        homeDirectory = "/Users/jackhamilton";
      };

      "arch" = mkHome {
        system        = "x86_64-linux";
        username      = "jack";
        homeDirectory = "/home/jack";
      };
    };
  };
}
