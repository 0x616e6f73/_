{ config, ... }: {
  programs.ssh = {
    enable = true;
    compression = true;
    controlMaster = "auto";
    controlPath = "/tmp/ssh-%C";
    forwardAgent = true;
    serverAliveInterval = 0;
    serverAliveCountMax = 3;
    hashKnownHosts = false;
    userKnownHostsFile = "~/.ssh/known_hosts";
    extraConfig = ''
      ControlPersist no
    '';
    includes = [
      "${config.home.homeDirectory}/.ssh/private.config"
      "${config.home.homeDirectory}/.orbstack/ssh/config"
    ];
    matchBlocks = {
      "*" = {
        compression = true;
        forwardAgent = true;
      };
      "github.com-ay" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_ay_github";
      };
      "github.com-a0" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_a0_github";
      };
      "github.com-db" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_t0_github";
      };
    };
  };
}
