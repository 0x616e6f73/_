{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    aliases = {
      redo = "commit --amend -S";
      account-switch = "!f() { git config user.name \"$(git config user.$1.name)\" && git config user.email \"$(git config user.$1.email)\" && git config core.sshCommand \"ssh -i ~/.ssh/id_ed25519_$1_github\" && echo \"Switched to $1: $(git config user.name) <$(git config user.email)> using SSH key ~/.ssh/id_ed25519_$1_github\"; }; f";
      account-check = "!git config user.name && git config user.email && git config core.sshCommand";
      p = "push";
      pl = "pull";
      f = "fetch";
      s = "status";
      cl = "clone";
      ad = "add .";
      cm = "commit -m";
      lp = "log --pretty=format:'%C(yellow)%h%Creset -%C(red)%an%Creset, %ar : %s'";
    };
    extraConfig = {
      core.editor = "${pkgs.helix}/bin/helix";
      pull.rebase = true;
      init.defaultBranch = "main";
      protocol.version = 2;
      submodule.fetchJobs = 4;
      merge.conflictstyle = "diff3";
      push.autoSetupRemote = true;
      branch.sort = "-committerdate";
      url."git@github.com-ghostty:ghostty-org/".insteadOf = "https://github.com/ghostty-org/";
      url."git@github.com-ay:".insteadOf = "https://github.com/ay-mxn/";
      url."git@github.com-a0:".insteadOf = "https://github.com/0x616e6f73/";
    };
  };

  sops.secrets.git_config = {
    path = "${config.home.homeDirectory}/.gitconfig-secret";
    mode = "0600";
  };

  home.activation.setupGitConfig = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ -f "${config.sops.secrets.git_config.path}" ]; then
      ${pkgs.git}/bin/git config --global --remove-section include || true
      ${pkgs.git}/bin/git config --global include.path "${config.sops.secrets.git_config.path}"
    fi
  '';
}
