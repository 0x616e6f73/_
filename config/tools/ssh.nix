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
      "github.com-account1" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_account1_github";
      };
      "github.com-account2" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_account2_github";
      };
      "github.com-account3" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_account3_github";
      };
    };
  };
}
