{ config, pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin or pkgs.stdenv.isDarwin;
  username  = if isDarwin then "jackhamilton" else "jack";
  homedir  = if isDarwin then "/Users/${username}" else "/home/${username}";
in
{
  imports = [
    ./repos.nix
  ];

  home.username      = username;
  home.homeDirectory = homedir;
  home.stateVersion  = "24.05";

  home.packages = with pkgs;
    [
      lsd bat curlie zoxide bitwarden-cli chezmoi cloc fzf difftastic cowsay
      fd github-cli imagemagick pipx ripgrep sccache wget sesh grex hyperfine
      pastel sd watchexec xcp go lazygit neovim htop tmux
    ]
    ++ lib.optionals isDarwin [ xcbeautify ]
    ++ lib.optionals (!isDarwin) [ wezterm handbrake krita inkscape ];

  programs.git = {
    enable = true;
    userName = "jackhamilton";
    userEmail = "jackham800@gmail.com";
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.starship.enable = true;
  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    ISNIXSHELL = "yes";
  };
}
