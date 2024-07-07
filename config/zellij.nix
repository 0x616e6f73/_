{
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "custom";
      pane_frames = false;
      ui.pane_frames.rounded_corners = false;
      simplified_ui = true;
      default_mode = "normal";
      mouse_mode = true;
      scroll_buffer_size = 10000;
      copy_command = "pbcopy";
      copy_clipboard = "system";
      copy_on_select = true;
      scrollback_editor = "hx";
      default_layout = "compact";
    };
  };
}
