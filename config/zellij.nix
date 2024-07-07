{
  programs.zellij = {
    enable = true;
    settings = {
      pane_frames = false;
      theme = "ashys";
      ui = {
        pane_frames = {
          rounded_corners = false;
        };
      };
      session_name = "";
      tab_bar_alignment = "center";
      hide_session_name = true;
      session_serialization = false;
      simplified_ui = true;
      default_layout = "compact";
      default_mode = "normal";
      mouse_mode = true;
      scroll_buffer_size = 10000;
      copy_command = "pbcopy";
      copy_clipboard = "system";
      copy_on_select = true;
      scrollback_editor = "hx"; # Set to Helix
    };
  };
  home.file.".config/zellij/themes/ashys.yaml".source = ./themes/zellij.yaml;
}
