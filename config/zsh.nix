{ ... }: {
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

      # Add prompt positioning function
      autoload -Uz add-zsh-hook

      fix-prompt-bottom() {
        local lines
        lines=$(tput lines)
        print -n "\e[''${lines};H"
        [[ -n $ZLE ]] && zle reset-prompt
      }
      
      add-zsh-hook precmd fix-prompt-bottom
    '';
    shellAliases = {
      ff = "fastfetch";
      gf = "git f";
      gs = "git s";
      gp = "git p";
      gpl = "git pl";
      gcl = "git cl";
      gad = "git ad";
      gcm = "git cm";
      glp = "git lp";
      nix-rebuild = "darwin-rebuild switch --flake ~/_ --show-trace";
      nix-gc = "nix-collect-garbage --delete-old";
      zellij = "zj";
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
   settings = {
     add_newline = true;
     # TODO: add all the other formatting for languages / technologies (as seen here https://github.com/smithumble/starship-cockpit/blob/main/starship.toml)
     format = "$directory$git_branch$git_status$git_metrics$fill$cmd_duration$rust$line_break$character";

     character = {
       success_symbol = "[λ](#7C89CD)";
       error_symbol = "[λ](#E5524F)";
     };
   
     directory = {
       style = "#4A3C2E";
       truncation_length = 1;
       truncate_to_repo = true;
       format = "[$path]($style) ";
     };

     fill = {
       symbol = "─";
       style = "#4A3C2E";
     };

     git_branch = {
       style = "#FFC799";
       format = "[($symbol$branch)]($style)";
     };

     git_metrics = {
       format = "([+$added]($added_style)([-$deleted]($deleted_style) ))";
       added_style = "#4EC9B0";
       deleted_style = "#FF8080"; 
       disabled = false;
     };

     git_status = {
       format = " [$all_status$ahead_behind]($style) ";
       style = "#E5524F";
       ahead = "⇡ $count";
       behind = "⇣ $count";
       diverged = "⇕$count";
       untracked = "?$count";
       stashed = "≡$count";
       modified = "!$count";
       staged = "+$count";
       renamed = "→$count";
       deleted = "×$count";
     };

     cmd_duration = {
       min_time = 0;
       format = " [󱫑 $duration]($style) ";
       style = "#D9956C";
       show_milliseconds = false;
     };

     rust = {
       format = "[$symbol($version )]($style)";
       symbol = "🦀";
       style = "#E5524F";
       disabled = false;
     };
    
     docker_context = {
       style = "#4EC9B0"; 
       format = " [($symbol$context)]($style)";
     };

     kubernetes = {
       style = "#7C89CD";
       format = " [($symbol$context )]($style)";
     };
   };
  };
}
