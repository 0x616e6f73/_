{ config, pkgs, ... }: {
  home.file.".config/ghostty/config".text = ''
    # Background and foreground
    background = #0a0a0a
    foreground = #E6D7C3

    # Font settings
    font-family = Geist Mono
    font-size = 16

    # Window settings
    background-opacity = 0.8
    background-blur-radius = 10
    macos-option-as-alt = true
    macos-titlebar-style = hidden
    window-padding-x = 10
    window-padding-y = 10

    # Color adjustments
    cursor-color = #E6D7C3
    selection-background = #3C3836
    selection-foreground = #E6D7C3

    # Vibrant blur effect (macOS only)
    macos-non-native-fullscreen = true
    
    # Key bindings
    keybind = ctrl+shift+t=new_tab
    keybind = ctrl+shift+w=close_surface
    keybind = ctrl+shift+l=next_tab
    keybind = ctrl+shift+h=previous_tab

    # Color scheme (adjust to make colors more vibrant)
    palette = 0=#282828
    palette = 1=#CC241D
    palette = 2=#98971A
    palette = 3=#D79921
    palette = 4=#458588
    palette = 5=#B16286
    palette = 6=#689D6A
    palette = 7=#A89984
    palette = 8=#928374
    palette = 9=#FB4934
    palette = 10=#B8BB26
    palette = 11=#FABD2F
    palette = 12=#83A598
    palette = 13=#D3869B
    palette = 14=#8EC07C
    palette = 15=#EBDBB2
  '';
}
