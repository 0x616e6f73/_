{
  programs.zellij = {
    enable = true;
    settings = {
      pane_frames = false;
      theme = "ashys";
    };
  };
  home.file.".config/zellij/themes/ashys.yaml".source = ./themes/zellij.yaml;
}
