{ pkgs, lib, ... }: {
  programs.zsh = {
    enable = true;
    initExtra = builtins.readFile ./.zshrc;
    initExtraFirst = ''
      function mkcd() {
        if [[ $# -ne 1 ]]; then
          echo "Usage: mkcd <directory>"
          return 1
        fi
        mkdir -p "$1" && cd "$1"
      }
      function hx() {
        wezterm cli set-user-var IS_HELIX true
        command hx "$@"
        wezterm cli set-user-var IS_HELIX false
      }
      function zj() {
        ZELLIJ_SESSION_NAME=$(date '+%Y-%m-%d') zellij "$@"
      }
    '';
    enableAutosuggestions = true;
    shellAliases = {
      nix-rebuild = "darwin-rebuild switch --flake ~/_";
      nix-gc = "nix-collect-garbage --delete-old";
      zellij = "zj";
      "zj das" = "zellij delete-all-sessions";
    };
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
