{ pkgs, lib, ... }: {
  programs.zsh = {
    enable = true;
    initExtra = builtins.readFile ./.zshrc + ''
      # Function to auto-attach to Zellij session or create a new one
      zellij_auto_attach() {
        if [[ -z "$ZELLIJ" ]]; then
          if zellij list-sessions >/dev/null 2>&1; then
            zellij attach -c
          else
            zellij
          fi
        fi
      }

      # Run the auto-attach function
      zellij_auto_attach
    '';
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
