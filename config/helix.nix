{ pkgs, ... }: {
  programs.helix = {
    enable = true;

    settings = {
      theme = "base16_transparent";

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
          right = [ "diagnostics" "position-percentage" "file-encoding"  "file-type" ];

          mode = {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
        };
      };
    };
  };
}
