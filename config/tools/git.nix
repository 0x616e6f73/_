{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userEmail = "170067277+0x616e6f73@users.noreply.github.com";
    userName = "0x616e6f73";
    aliases = {
      redo = "commit --amend -S";
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
      core = {
        editor = "${pkgs.helix}/bin/helix";
      };
      pull = {
        rebase = true;
      };
      init = {
        defaultBranch = "main";
      };
      protocol = {
        version = 2;
      };
      submodule = {
        fetchJobs = 4;
      };
      merge = {
        conflictstyle = "diff3";
      };
      push = {
        autoSetupRemote = true;
      };
    };
  };
}
