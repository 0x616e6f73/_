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
    '';
    enableAutosuggestions = true;
    shellAliases = {
      nix-rebuild = "darwin-rebuild switch --flake ~/_";
      nix-gc = "nix-collect-garbage --delete-old";
    };
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
