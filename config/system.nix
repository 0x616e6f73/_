{ pkgs, lib, ... }: {
  nix.package = lib.mkDefault pkgs.nix;
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  time.timeZone = "America/New_York";

  system.patches = [
    (pkgs.writeText "pam_tid.patch" ''
      --- /etc/pam.d/sudo	2023-09-28 09:27:50
      +++ /etc/pam.d/sudo	2023-09-28 09:27:54
      @@ -1,4 +1,6 @@
       # sudo: auth account password session
      +auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so
      +auth       sufficient     pam_tid.so
       auth       include        sudo_local
       auth       sufficient     pam_smartcard.so
       auth       required       pam_opendirectory.so
    '')
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.shells = [ pkgs.zsh ];
  programs.zsh.enable = true;

  environment.variables = {
    PATH = lib.mkForce "/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:$PATH";
  };

  system.defaults = {
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
    screencapture.type = "png";
    finder = {
      ShowPathbar = true;
      ShowStatusBar = true;
    };
  };

  # Homebrew configuration
  homebrew = {
    enable = true;
    caskArgs = {
      no_quarantine = true;
    };
    masApps = {
      # Things = 904280696;
    };
    casks = [
      "craft"
      "cursor"
      "dbngin"
      "keycastr"
      "minecraft"
      "obs"
      "orbstack"
      "plex"
      "spotify"
      "tailscale"
    ];
  };
}
