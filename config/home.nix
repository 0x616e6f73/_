{ config, pkgs, lib, ... }:

{
  home.username = "ay";
  home.homeDirectory = "/Users/ay";
  home.stateVersion = "23.11";

  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;

  home.file.".config/wezterm/wezterm.lua".text = builtins.readFile ./wezterm.lua;

  programs.bat = {
    enable = true;
    config.theme = "Flexoki";
  };

  imports = [
    ./packages.nix
    ./zsh.nix
    ./zellij.nix
    ./helix.nix
    ./tools/git.nix
    ./tools/gpg.nix
    ./tools/ssh.nix
  ];

}
