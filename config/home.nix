{ config, pkgs, lib, ... }:
{
  home.username = "ay";
  home.homeDirectory = lib.mkForce "/Users/ay";
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

  sops = {
    defaultSopsFile = ../secrets/git_config.yaml;
    age.keyFile = "/Users/ay/.config/sops/age/keys.txt";
  };

  sops.secrets.git_config = {
    path = "${config.home.homeDirectory}/.gitconfig-secret";
  };

  # This ensures the secret is readable by your user
  home.file.".gitconfig-secret".mode = "0600";

  # Optional: Add this if you want to use the secret in your Git configuration
  # programs.git = {
  #   enable = true;
  #   includes = [{ path = config.sops.secrets.git_config.path; }];
  # };
}
