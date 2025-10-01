{ config, pkgs, lib, ... }:

let
  czWrap = "${(pkgs.writeShellScriptBin "chezmoi" ''
    set -euo pipefail
    export PATH="${pkgs.bitwarden-cli}/bin:${pkgs.coreutils}/bin:${pkgs.findutils}/bin:$PATH"
    exec ${pkgs.chezmoi}/bin/chezmoi "$@"
  '')}/bin/chezmoi";
in {
    home.activation.repoClone = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # if [ ! -d "$HOME/Documents/GitHub/dotfiles/.git" ]; then
    #   echo "Cloning dotfiles..."
    #   ${pkgs.git}/bin/git clone https://github.com/jackhamilton/dotfiles.git "$HOME/Documents/GitHub/dotfiles"
    # else
    #   echo "Updating dotfiles"
    #   ${pkgs.git}/bin/git -C "$HOME/Documents/GitHub/dotfiles" pull
    # fi

    ${czWrap} init --apply https://github.com/jackhamilton/dotfiles.git
    '';
}
