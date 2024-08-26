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
        command hx "$@"
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
    };
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
