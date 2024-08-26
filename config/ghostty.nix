{ config, pkgs, ... }: {
  home.file.".config/ghostty/config".text = ''
    background = #0a0a0a
    foreground = #E6D7C3
    font-family = MesloLGS NF
    font-size = 13
    window-padding = 10
    opacity = 0.8
    macos-option-as-alt = true
    
    keybind = ctrl+shift+t=new_tab
    keybind = ctrl+shift+w=close_surface
    keybind = ctrl+shift+l=next_tab
    keybind = ctrl+shift+h=previous_tab
  '';
}
