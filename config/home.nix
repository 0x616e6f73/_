{ config, pkgs, lib, ... }:
{
  home.username = "ay";
  home.homeDirectory = lib.mkForce "/Users/ay";
  home.stateVersion = "24.11";
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

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };
    
  # Yazi configuration
  home.file.".config/yazi/themes/yazi.toml".source = ./themes/yazi.toml;
  
  # Zellij Theme
  home.file.".config/zellij/themes/custom.kdl".source = ./themes/zellij.kdl;

  home.file.".config/btop/themes/custom.theme".text = ''
    # Theme: Custom (matching your Nix system theme)
    theme[main_bg]="#0a0a0a"
    theme[title]="#E6D7C3"
    theme[hi_fg]="#FFC799"
    theme[inactive_fg]="#4A3C2E"
    theme[main_fg]="#E6D7C3"
    theme[cpu_box]="#FF8080"
    theme[memory_box]="#7C89CD"
    theme[net_box]="#D4B483"
    theme[process_box]="#99FFE4"
    theme[cpu_start]="#FF8080"
    theme[cpu_mid]="#FFC799"
    theme[cpu_end]="#E6D7C3"
    theme[free_start]="#7C89CD"
    theme[free_mid]="#99FFE4"
    theme[free_end]="#E6D7C3"
    theme[cached_start]="#D4B483"
    theme[cached_mid]="#FFC799"
    theme[cached_end]="#E6D7C3"
    theme[available_start]="#99FFE4"
    theme[available_mid]="#FFC799"
    theme[available_end]="#E6D7C3"
    theme[used_start]="#FF8080"
    theme[used_mid]="#FFC799"
    theme[used_end]="#E6D7C3"
    theme[process_start]="#E6D7C3"
    theme[process_mid]="#D4B483"
    theme[process_end]="#7C89CD"
    theme[graph_text]="#E6D7C3"
    theme[meter_bg]="#0a0a0a80"
    theme[div_line]="#4A3C2E"
    theme[selected_bg]="#2A2A2A"
    theme[selected_fg]="#FFC799"
    theme[temp_start]="#7C89CD"
    theme[temp_mid]="#FFC799"
    theme[temp_end]="#FF8080"
    theme[cpu_temp]="#FF8080"
    theme[cpu_temp_mid]="#FFC799"
    theme[cpu_temp_high]="#E5524F"
    theme[free_end]="#99FFE4"
    theme[cached_end]="#D4B483"
    theme[available_end]="#7C89CD"
    theme[used_end]="#FF8080"
    theme[func_fg]="#7C89CD"
  '';

  programs.bat = {
    enable = true;
    config = {
      theme = "arabia";
      style = "plain";
    };
    themes = {
      arabia = {
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
