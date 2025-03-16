{ unstable, ... }: {
  home.packages =
    (with unstable; [
      pam-reattach
      coreutils
      eza
      fd
      jq
      pastel
      ripgrep
      sd
      sops
      act
      age
      anki-bin
      alejandra
      awscli2
      blast-bin
      bore-cli
      bun
      cabal-install
      cachix
      dbt
      deno
      direnv
      docker
      fastfetch
      ffmpeg_5
      figlet
      fzf
      ghc      
      go
      jdk11
      librsvg
      libwebp
      lolcat
      lsd
      monitorcontrol
      nodejs
      ollama
      openssl
      optipng
      radicle-node
      redis
      rustup
      skhd
      unixtools.script
      uv
      watch
      yabai
      yazi
    ]);

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "custom";
      vim_keys = true;
    };
  };
}
