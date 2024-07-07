{
  programs.zellij = {
    enable = true;
    settings = {
      pane_frames = false;
      theme = "custom";
      ui = {
        pane_frames = {
          rounded_corners = false;
        };
      };
      simplified_ui = true;
      default_mode = "normal";
      mouse_mode = true;
      scroll_buffer_size = 10000;
      copy_command = "pbcopy";
      copy_clipboard = "system";
      copy_on_select = true;
      scrollback_editor = "hx";
      default_layout = "compact";
      session_name = "{{session_name}}";
      layout = {
        default = {
          children = [
            {
              direction = "Vertical";
              split_size = {
                Fixed = 1;
              };
            }
            {
              direction = "Vertical";
              body = true;
            }
          ];
        };
      };
    };
  };
  home.file.".config/zellij/layouts/default.kdl".text = ''
    layout {
        pane size=1 borderless=true {
            plugin location="zellij:tab-bar"
        }
        pane
        pane size=2 borderless=true {
            plugin location="zellij:status-bar"
        }
    }
  '';
}
