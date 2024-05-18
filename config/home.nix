{ pkgs, ... }: {
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  users.users.ay = {
    name = "ay";
    home = "/Users/ay";
  };

  home-manager.users.ay = { pkgs, lib, ... }: {
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
  };
}
