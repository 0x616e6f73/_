{ config, ... }: {
  programs.ssh = {
    enable = true;
    compression = true;
    controlMaster = "auto";
    controlPath = "/tmp/ssh-%C";
    forwardAgent = true;
    includes = [
      "${config.home.homeDirectory}/.ssh/private.config"
      "${config.home.homeDirectory}/.orbstack/ssh/config"
    ];
    matchBlocks = {
      "github.com-ay" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_ay_github";
      };
      # Keep the other accounts if you still need them
      "github.com-a0" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_a0_github";
      };
      "github.com-db" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_db_github";
      };
    };
  };
}
