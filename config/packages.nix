{ lib, pkgs, unstable, config, ... }: {
  home.packages =
    (with pkgs; [
    ])
    ++
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
      alejandra
      awscli2
      bore-cli
      bun
      cabal-install
      cachix
      docker
      ffmpeg_5
      fzf
      ghc      
      go
      htop
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
      redis
      rustup
      skhd
      unixtools.script
      watch
      yabai
      yazi
     ]);
}
