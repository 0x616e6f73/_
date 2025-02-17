{ config, pkgs, lib, ... }:
{
  home.username = "ay";
  home.homeDirectory = lib.mkForce "/Users/ay";
  home.stateVersion = "24.05";
  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;

  imports = [
    ./packages.nix
    ./zsh.nix
    ./zellij.nix
    ./helix.nix
    ./tools/git.nix
    ./tools/gpg.nix
    ./tools/ssh.nix
    ./ghostty.nix
  ];
  # Yazi configuration
  home.file.".config/yazi/themes/yazi.toml".source = ./themes/yazi.toml;
  
  # Zellij Theme
  home.file.".config/zellij/themes/custom.kdl".source = ./themes/zellij.kdl;

  programs.bat = {
      enable = true;
      config = {
        theme = "Ashys";
      };
      themes = {
        Ashys = {
          src = ./themes/bat.tmTheme;
        };
      };
    };

  sops = {
    defaultSopsFile = ../secrets/git_config.yaml;
    age.keyFile = "/Users/ay/.config/sops/age/keys.txt";
  };

  sops.secrets.git_config = {
    path = "${config.home.homeDirectory}/.gitconfig-secret";
    mode = "0600";
  };

  programs.git = {
    enable = true;
    includes = [{ path = config.sops.secrets.git_config.path; }];
  };

  # applying secret after creation
  home.activation.setupGitConfig = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ -f "${config.sops.secrets.git_config.path}" ]; then
      ${pkgs.git}/bin/git config --global --remove-section include || true
      ${pkgs.git}/bin/git config --global include.path "${config.sops.secrets.git_config.path}"
    fi
  '';
}
