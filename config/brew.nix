{ ... }: {
  homebrew = {
    enable = true;
    caskArgs = {
      no_quarantine = true;
    };
    masApps = {
      # Things = 904280696;
    };
    casks = [
      "cleanshot"
      "craft"
      "cursor"
      "dbngin"
      "discord"
      "keycastr"
      "microsoft-teams"
      "minecraft"
      "obs"
      "orbstack"
      "plex"
      "spotify"
      "tailscale"
    ];
  };
}
