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
      # Remove "Zellij" from bottom left and set session name to date
      session_name = "date +%Y-%m-%d";
      default_layout = "compact";
      default_mode = "normal";
      mouse_mode = true;
      scroll_buffer_size = 10000;
      copy_command = "pbcopy";
      copy_clipboard = "system";
      copy_on_select = true;
      scrollback_editor = "hx";
      # Enable auto-numbering of tabs
      auto_layout = true;
      # Enable process name as tab name
      tab_template = "#{index}:#{process_name}";
    };
  };
  home.file.".config/zellij/themes/ashys.yaml".source = ./themes/zellij.yaml;
}
