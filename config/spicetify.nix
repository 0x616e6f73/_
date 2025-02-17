{ config, ... }: {
  home.file.".config/spicetify/Themes/Vesper/color.ini".text = ''
    [Vesper]
    text               = E6D7C3
    subtext            = E6D7C3
    main               = 101010
    sidebar            = 101010
    player             = 101010
    card               = 101010
    shadow             = 101010
    selected-row       = 7C89CD
    button             = FFC799
    button-active      = FF8080
    button-disabled    = 4A3C2E
    tab-active         = 7C89CD
    notification       = FFC799
    notification-error = E5524F
    misc              = FFC799
  '';

  home.file.".config/spicetify/Themes/Vesper/user.css".text = ''
    * {
      font-family: "Geist Mono" !important;
    }
    .main-type-mestro,
    .main-type-ballad {
      font-weight: 500 !important;
    }
    * {
      -webkit-font-smoothing: antialiased;
      -moz-osx-font-smoothing: grayscale;
    }
  '';

  home.file.".config/spicetify/config-xpui.ini".text = ''
    [Setting]
    spotify_path            = /Applications/Spotify.app/Contents/Resources
    prefs_path             = ${config.home.homeDirectory}/Library/Application Support/Spotify/prefs
    current_theme          = Vesper
    color_scheme           = 
    inject_css             = 1
    replace_colors         = 1
    overwrite_assets       = 0
    spotify_launch_flags   = 
    check_spicetify_upgrade = 0

    [Preprocesses]
    disable_sentry        = 1
    disable_ui_logging    = 1
    remove_rtl_rule      = 1
    expose_apis          = 1
    disable_upgrade_check = 1

    [AdditionalOptions]
    extensions            = 
    custom_apps          = 
    sidebar_config       = 1
    home_config         = 1
    experimental_features = 1
  '';

  home.activation.setupSpicetify = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ -d "/Applications/Spotify.app" ]; then
      rm -rf ~/.config/spicetify/Themes
      mkdir -p ~/.config/spicetify/Themes/Vesper
      spicetify config spotify_path /Applications/Spotify.app/Contents/Resources
      spicetify config prefs_path "$HOME/Library/Application Support/Spotify/prefs"
      spicetify backup
      spicetify apply
    fi
  '';
}
