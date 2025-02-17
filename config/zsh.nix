{ pkgs, lib, ... }: {
  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
    };
    initExtra = ''
      # Ensure Nix and Home Manager paths are first in PATH
      export PATH=$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH

      # Ensure nix commands are available
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi

      # Add Homebrew to PATH
      eval "$(/opt/homebrew/bin/brew shellenv)"

      # Function to start Zellij with current date as session name
      function zj() {
        ZELLIJ_SESSION_NAME=$(date '+%Y-%m-%d') command zellij "$@"
      }

      # Function for Helix
      function hx() {
        command hx "$@"
      }

      # Function to create and change to a new directory
      function mkcd() {
        if [[ $# -ne 1 ]]; then
          echo "Usage: mkcd <directory>"
          return 1
        fi
        mkdir -p "$1" && cd "$1"
      }

      # Zellij auto-start (if you want to keep this feature)
      if command -v zellij >/dev/null 2>&1; then
        eval "$(zellij setup --generate-auto-start zsh)"
      fi
    '';
    shellAliases = {
      nix-rebuild = "darwin-rebuild switch --flake ~/_";
      nix-gc = "nix-collect-garbage --delete-old";
      zellij = "zj";
      neofetch = "fastfetch";
    };
    history = {
      size = 10000;
      save = 10000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      share = true;
      extended = false;
    };
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
