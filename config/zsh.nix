{ pkgs, lib, ... }: {
  programs.zsh = {
    enable = true;
    initExtra = builtins.readFile ./.zshrc + ''
      # Add Nix and Home Manager paths
      export PATH=$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH

      # Ensure nix commands are available
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
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
        if command -v wezterm > /dev/null 2>&1; then
          wezterm cli set-user-var IS_HELIX true
          command hx "$@"
          wezterm cli set-user-var IS_HELIX false
        else
          command hx "$@"
        fi
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
