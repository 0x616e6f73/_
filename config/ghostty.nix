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
    background-blur-radius = 30
    macos-option-as-alt = true
    macos-titlebar-style = hidden
    window-padding-x = 10
    window-padding-y = 10

    # Color adjustments
    cursor-color = #E6D7C3
    selection-background = #2A2A2A
    selection-foreground = #E6D7C3

    # Vibrant blur effect (macOS only)
    macos-non-native-fullscreen = true

    # Key bindings
    keybind = ctrl+shift+t=new_tab
    keybind = ctrl+shift+w=close_surface
    keybind = ctrl+shift+l=next_tab
    keybind = ctrl+shift+h=previous_tab

    # Color scheme (aligned with helix theme)
    palette = 0=#0a0a0a     # Black (background)
    palette = 1=#E5524F     # Red (constants)
    palette = 2=#D4B483     # Green (variables)
    palette = 3=#FFC799     # Yellow (peach accent)
    palette = 4=#7C89CD     # Blue (functions)
    palette = 5=#FF8080     # Magenta (keywords)
    palette = 6=#99FFE4     # Cyan (strings)
    palette = 7=#E6D7C3     # White (bone)
    palette = 8=#4A3C2E     # Bright Black (comments)
    palette = 9=#FF7300     # Bright Red (storage)
    palette = 10=#FABD2E    # Bright Green (golden yellow)
    palette = 11=#FFC799    # Bright Yellow (peach)
    palette = 12=#7C89CD    # Bright Blue (functions)
    palette = 13=#FF8080    # Bright Magenta (keywords)
    palette = 14=#99FFE4    # Bright Cyan (strings)
    palette = 15=#E6D7C3    # Bright White (bone)
  '';
}
