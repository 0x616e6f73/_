{ pkgs, ... }:

let
  # Import the secret configuration
  secretConfig = import ./secret-git-config.nix;
in
{
  programs.git = {
    enable = true;
    aliases = {
      redo = "commit --amend -S";
      switch-account = "!f() { git config user.name \"$(git config user.$1.name)\"; git config user.email \"$(git config user.$1.email)\"; echo \"Switched to $1\"; }; f";
      check-account = "!git config --list | grep -E \"^user\\.(name|email)\" | sort";
    };
    ignores = [
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      "Icon\r"
      "._*"
      ".DocumentRevisions-V100"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      ".com.apple.timemachine.donotpresent"
      ".AppleDB"
      ".AppleDesktop"
      "Network Trash Folder"
      "Temporary Items"
      ".apdisk"
      "*~"
    ];
    lfs.enable = true;
    delta.enable = true;
    extraConfig = {
      core.editor = "${pkgs.helix}/bin/helix";
      pull.rebase = true;
      init.defaultBranch = "main";
      protocol.version = 2;
      submodule.fetchJobs = 4;
      merge.conflictstyle = "diff3";
      push.autoSetupRemote = true;

      # User configurations (imported from secret config)
      user = secretConfig.users;

      # Conditional includes based on directory
      includeIf = secretConfig.includeIf;

      # URL configurations for each account
      url = secretConfig.url;
    };
  };
}
