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

  home.file.".config/helix/themes/arkdark.toml".text = ''
    "ui.background" = { bg = "#151515" }
    "ui.text" = { fg = "#D4D4D4" }
    "ui.selection" = { fg = "#FFFFFF" }
    "comment" = { fg = "#6A9955" }
    "constant" = { fg = "#569CD6" }
    "constant.numeric" = { fg = "#B5CEA8" }
    "string" = { fg = "#CE9178" }
    "variable" = { fg = "#9CDCFE" }
    "keyword" = { fg = "#C586C0" }
    "operator" = { fg = "#D4D4D4" }
    "function" = { fg = "#DCDCAA" }
    "type" = { fg = "#4EC9B0" }
    "ui.cursor" = { fg = "#D4D4D4", modifiers = ["reversed"] }
    "ui.cursor.primary" = { fg = "#D4D4D4", modifiers = ["reversed"] }
    "ui.linenr" = { fg = "#858585" }
    "ui.linenr.selected" = { fg = "#C6C6C6" }
    "ui.statusline" = { fg = "#D4D4D4", bg = "#007ACC" }
    "ui.popup" = { bg = "#252526" }
    "ui.window" = { bg = "#252526" }
    "ui.help" = { bg = "#252526", fg = "#D4D4D4" }
    "markup.heading" = { fg = "#4EC9B0", modifiers = ["bold"] }
    "markup.list" = { fg = "#C586C0" }
    "markup.bold" = { fg = "#D4D4D4", modifiers = ["bold"] }
    "markup.italic" = { fg = "#D4D4D4", modifiers = ["italic"] }
    "markup.link.url" = { fg = "#569CD6", modifiers = ["underlined"] }
    "markup.link.text" = { fg = "#CE9178" }
    "markup.quote" = { fg = "#608B4E" }
    "markup.raw" = { fg = "#CE9178" }
    [palette]
    background = "#151515"
    foreground = "#D4D4D4"
  '';
}
