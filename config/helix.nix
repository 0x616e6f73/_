{ config, pkgs, ... }: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "arkdark";
      editor = {
        line-number = "absolute";
        mouse = false;
        auto-format = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        statusline = {
          left = [ "mode" "version-control" "spinner" "file-modification-indicator" ];
          center = [ "file-name" ];
          right = [ "diagnostics" "position-percentage" "file-encoding" "file-type" ];
          mode = {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
        };
      };
    };
  };

  home.file.".config/helix/themes/arkdark.toml".source = ./themes/helix.toml;
}
