# shell.nix

```nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    age
    sops
  ];
}

```

# result

This is a binary file of the type: Binary

# flake.nix

```nix
{
  inputs = {
    pkgs.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    u_pkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    hm = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "pkgs";
    };
    os = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "pkgs";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "pkgs";
    };
    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";
    };
  };

  outputs = { self, pkgs, u_pkgs, hm, os, sops-nix }:
    let
      system = "aarch64-darwin"; # M1 Max
      unstable = u_pkgs.legacyPackages.${system};
    in {
      darwinConfigurations."net" = os.lib.darwinSystem {
        inherit system;
        modules = [
          hm.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit unstable; };
              users.ay = { pkgs, ... }: {
                imports = [
                  ./config/home.nix
                  sops-nix.homeManagerModules.sops
                ];
              };
            };
          }
          ./config/system.nix
          ./config/brew.nix
        ];
      };

      # Development shell definition (if you want to keep it)
      devShells.${system}.default = pkgs.legacyPackages.${system}.mkShell {
        buildInputs = with pkgs.legacyPackages.${system}; [
          age
          sops
        ];
      };
    };
}

```

# flake.lock

```lock
{
  "nodes": {
    "hm": {
      "inputs": {
        "nixpkgs": [
          "pkgs"
        ]
      },
      "locked": {
        "lastModified": 1719827415,
        "narHash": "sha256-pvh+1hStXXAZf0sZ1xIJbWGx4u+OGBC1rVx6Wsw0fBw=",
        "owner": "nix-community",
        "repo": "home-manager",
        "rev": "f2e3c19867262dbe84fdfab42467fc8dd83a2005",
        "type": "github"
      },
      "original": {
        "owner": "nix-community",
        "ref": "release-23.11",
        "repo": "home-manager",
        "type": "github"
      }
    },
    "nixpkgs-stable": {
      "locked": {
        "lastModified": 1719663039,
        "narHash": "sha256-tXlrgAQygNIy49LDVFuPXlWD2zTQV9/F8pfoqwwPJyo=",
        "owner": "NixOS",
        "repo": "nixpkgs",
        "rev": "4a1e673523344f6ccc84b37f4413ad74ea19a119",
        "type": "github"
      },
      "original": {
        "owner": "NixOS",
        "ref": "release-23.11",
        "repo": "nixpkgs",
        "type": "github"
      }
    },
    "os": {
      "inputs": {
        "nixpkgs": [
          "pkgs"
        ]
      },
      "locked": {
        "lastModified": 1719845423,
        "narHash": "sha256-ZLHDmWAsHQQKnmfyhYSHJDlt8Wfjv6SQhl2qek42O7A=",
        "owner": "lnl7",
        "repo": "nix-darwin",
        "rev": "ec12b88104d6c117871fad55e931addac4626756",
        "type": "github"
      },
      "original": {
        "owner": "lnl7",
        "repo": "nix-darwin",
        "type": "github"
      }
    },
    "pkgs": {
      "locked": {
        "lastModified": 1719957072,
        "narHash": "sha256-gvFhEf5nszouwLAkT9nWsDzocUTqLWHuL++dvNjMp9I=",
        "owner": "nixos",
        "repo": "nixpkgs",
        "rev": "7144d6241f02d171d25fba3edeaf15e0f2592105",
        "type": "github"
      },
      "original": {
        "owner": "nixos",
        "ref": "nixpkgs-23.11-darwin",
        "repo": "nixpkgs",
        "type": "github"
      }
    },
    "root": {
      "inputs": {
        "hm": "hm",
        "os": "os",
        "pkgs": "pkgs",
        "sops-nix": "sops-nix",
        "u_pkgs": "u_pkgs"
      }
    },
    "sops-nix": {
      "inputs": {
        "nixpkgs": [
          "pkgs"
        ],
        "nixpkgs-stable": "nixpkgs-stable"
      },
      "locked": {
        "lastModified": 1719873517,
        "narHash": "sha256-D1dxZmXf6M2h5lNE1m6orojuUawVPjogbGRsqSBX+1g=",
        "owner": "mic92",
        "repo": "sops-nix",
        "rev": "a11224af8d824935f363928074b4717ca2e280db",
        "type": "github"
      },
      "original": {
        "owner": "mic92",
        "repo": "sops-nix",
        "type": "github"
      }
    },
    "u_pkgs": {
      "locked": {
        "lastModified": 1720058333,
        "narHash": "sha256-gM2RCi5XkxmcsZ44pUkKIYBiBMfZ6u7MdcZcykmccrs=",
        "owner": "nixos",
        "repo": "nixpkgs",
        "rev": "6842b061970bf96965d66fcc86a28e1f719aae95",
        "type": "github"
      },
      "original": {
        "owner": "nixos",
        "ref": "nixpkgs-unstable",
        "repo": "nixpkgs",
        "type": "github"
      }
    }
  },
  "root": "root",
  "version": 7
}

```

# bootstrap.sh

```sh
#!/usr/bin/env bash

notify() {
	echo -e "\033[0;34m[i]\033[0m $1" >&2
}

error() {
	echo -e "\033[0;31m[x]\033[0m $1" >&2
	exit 1
}

acquire_sudo() {
	if [[ $UID == 0 ]]; then
		notify "Running as root"
		SUDO=""
	elif $(sudo -v); then
		notify "Got sudo permissions"
		SUDO="sudo"
	else
		error "Failed to get sudo permissions"
	fi
}

prompt() {
	echo -en "\033[0;33m[?]\033[0m $1 \033[0;33m(y/N)\033[0m "
	read -r INPUT

	[[ "$INPUT" =~ ^[Yy]$ ]] && return 0 || return 1
}

# Variables
OS=$(uname -s)
DOTDIR="$HOME/Developer/personal/dotfiles"
DOTDIR_REPO="https://github.com/tale/dotfiles"

NIX_SCRIPT="https://nixos.org/nix/install"
BREW_SCRIPT="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

# Requirements
command -v git &>/dev/null || error "'git' is not installed"
command -v curl &>/dev/null || error "'curl' is not installed"
acquire_sudo

# Install Homebrew if not already installed
if ! command -v /opt/homebrew/bin/brew &>/dev/null; then
	notify "Installing Homebrew"

	curl -fsSL "$BREW_SCRIPT" | NONINTERACTIVE=1 bash
	eval $(/opt/homebrew/bin/brew shellenv)
else
	notify "Homebrew is already installed"
fi

# Install Rosetta if not already installed
if ! command -v pkgutil --pkg-info com.apple.pkg.RosettaUpdateAuto &>/dev/null; then
	notify "Installing Rosetta"
	softwareupdate --install-rosetta --agree-to-license
else
	notify "Rosetta is already installed"
fi

# Install Nix if not already installed
if ! launchctl print system/org.nixos.nix-daemon &>/dev/null; then
	notify "Installing Nix"
	curl -L "$NIX_SCRIPT" | sh -s -- --daemon
	source /etc/bashrc
else
	notify "Nix is already installed"
	source /etc/static/bashrc
fi

if [[ ! -d "$DOTDIR" ]]; then
	notify "Cloning dotfiles from $DOTDIR_REPO"
	git clone "$DOTDIR_REPO" "$DOTDIR"
else
	notify "Dotfiles are already cloned"
fi

# Build and configure nix-darwin
if ! command -v darwin-rebuild &>/dev/null; then
	notify "Installing nix-darwin"

	# flake.nix expects "Aarnavs-MBP" as the hostname
	$SUDO scutil --set LocalHostName Aarnavs-MBP
	dscacheutil -flushcache

	# After nix-darwin is installed and configured it's in the PATH
	command nix build .#darwinConfigurations.$(hostname -s).system \
		--extra-experimental-features "nix-command flakes"

	# We need to link run to private/var/run for nix-darwin
	if ! grep -q "private/var/run" /etc/synthetic.conf; then
		notify "Appending nix-darwin path to /etc/synthetic.conf"

		printf "run\tprivate/var/run\n" | $SUDO tee -a /etc/synthetic.conf
		/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t
	else
		notify "nix-darwin path already exists in /etc/synthetic.conf"
	fi

	# Run nix-darwin's rebuild command
	$DOTDIR/result/sw/bin/darwin-rebuild switch --flake $DOTDIR
else
	notify "nix-darwin is already installed"
fi

# Setup the dotfiles to be managed by remote via SSH
git -C $DOTDIR remote set-url origin git@github.com:tale/dotfiles.git

```

# README.md

```md
hello, world.
---

## things to improve

**git-sops**
- [ ] reinit all ssh keys for accounts
- [ ] update `tools/ssh.nix` with new paths to keys
- [ ] add url rewrite rules in the `extraConfig` section in `tools/git.nix` to map HTTPS URLs to the appropriate ssh configs
- [ ] add sops secret declarations for each ssh key in `tools/git.nix`
- [ ] modify the activation script to ensure the correct permissions are set on the SSH keys.

**helix**
- [X] todo/fixme-esque annotation highlights
- [X] inline error lens
- [X] enable soft wrap
- [ ] swap normal/insert color modes (red / yellow)
- [ ] create space between mode and git branch name

**zellij**
- [X] create `zj das` alias (i'm an idiot, `zj da` exists -- going to undo the alias)
- [ ] implement plugins (at least the reddit one) in zj tab group
- [ ] create layout file templates
- [ ] figure out how to reattach prev zj session on start (maybe give user a choice between new or reattach on open?)
- [ ] implement rust plugin for interface 
- [ ] change theme to gruvbox dark

**yazi**
- [X] add yazi
- [-] configure yazi color theme (pushed some changes but they dont work atm and i'm too lazy to figure out rn)
- [ ] look into terminal-apps.dev on brave and see if yazi is actually the best option

**ghostty**
- [ ] switch to gruvbox dark
- [ ] fix border spacing for helix window (keep transparent bg)

```

# .sops.yaml

```yaml
keys:
  - &ay age16e0mm7dknmkqzl469jdrcz3cdr4fx2ej5zndlenmk3g3lfescacsfr3s28
creation_rules:
  - path_regex: secrets/git_config.yaml$
    key_groups:
    - age:
      - *ay

```

# .gitignore

```
.luarc.json
result
secret-git-config.nix
```

# secrets/git_config.yaml

```yaml
git_config: ENC[AES256_GCM,data:3v3O9QYAM1G9hqXISy1/sysekbxH5RHGMMuSdDJPnUaIyilmpg+VEmFrbP/xZIfFZEj1RQ5mzeU3jAc/oISR66SzNdFky1yUX5g5UFZcmnm9U7qxK581MvFJtPEVsNu0xmIkCoevcXloiXxnFb42dkf1vMj9kzVriL3ruweWbhMLCOYjcUG/KLING73VoFVoCVXNiq54ZT4mphde3zLJK3QsprsRdL7qiU+zolSjaGI+t/RHbmJxMet9oTzkvDRo2+XzGAFSqcQcvPUjgyUZf5he01OUPk9nZcIPHyANBJsF11M+GydbNBacFX2RrIDmu8lHHtMoqNXyJ7XdJeN0oKfFyWJqTjLItyzpu92eundFbRMICkEmiOnH7Pw5d6OupZV0R7JtA4q5gMSd6ns9/dVWFLBxzcCuVKEE3LFCa2u8AjyYssUCZ/3khNRnKTDwV2qWePGvMisWNT3NgehtfwLMa6Oj3Cc6oknGX/5MXgVJ+2XQIfxULA4NrZ1YtyC1/DK0ZhwiXn0XG9UsXR1fwoggx3AXecD3HWQ8rlNHRIWJZIeTH/1dTl/86y9vSYgbCBPQuWMB+hhP8mPMELW1bc0NkP4hIbIX76nOl1edIiiZETbXwwc4K2iWp/4gHwikEltWsMV8QK8t86zAae0DtZDeyYFk8UEWwluI4SOnrnJux+qOz2mhElHp8YDPDN99Q8E0gO3XJp0uoQuH6G8o/AUzxYL+e0ghHd8YIwdtne/WqE3LbPoLRzj3Qjz3VVZpMNS/5WHV1NlXDM5qGroqiWFtXyEfch0NStz7mBWqUOBtcO2m1wzO1e0vZQiikqspKTdf3Wj/jhycjjYDPaoNmekgOrWkTYY71I6a7QIpNaKva2QghWlfNmAFvlW/sB8A3oD6lmWukXYZiYQKE0chKgSY,iv:VA88MpMuTUq7jBzxKP+nmBZAD+Onb/sgBoct9FbKxYU=,tag:zCtyeFMVn5/vqJFDNfuzxQ==,type:str]
sops:
    kms: []
    gcp_kms: []
    azure_kv: []
    hc_vault: []
    age:
        - recipient: age16e0mm7dknmkqzl469jdrcz3cdr4fx2ej5zndlenmk3g3lfescacsfr3s28
          enc: |
            -----BEGIN AGE ENCRYPTED FILE-----
            YWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBFbDR1cnpCQUo1SG5WYVMz
            eUNNZE9yR3dUTlZsby9FVDJLNUo3QjBFOW5vCm5NWTExQmNLeThwQXpFeXRkb21J
            dWdXOStiUjAzN2JpWWl1NDJyUHpIdzgKLS0tIGZqSkN4SitGS3J6b3ZHVzZHaUd3
            YnBvaFlFVnZodzVvQXRhdzFiam9zcFUKrO6+pWy3IWwd2fJ5tvq1XdGo7mfTCHg3
            hxAA48pVTBONKhO6nN+hCe6YLQRe0DW2qBBtYWws4ju6nG/Y11QLxg==
            -----END AGE ENCRYPTED FILE-----
    lastmodified: "2024-07-05T20:27:34Z"
    mac: ENC[AES256_GCM,data:w5yVBuuTRDIcWMi/EtSIckVZnIyKR5ni/DD+p9KQdMXW7BWEzPuEczZD5mS62RSkHiPFqdN5A0VKarmi7JA0ZtNTeMvCZfxzQWOvqCvvWVcfZt5rNNbr8DxyGftVwoPKPk1SiXjyyTjdzVc38Rg3M3lBI6WcLhXcMpltG9fIVl0=,iv:7dXeKGFpBa9E7Mlyv3wRx/JlGu8SNKBPunQZbY9IXcQ=,tag:h/iCF3ngmps42p323NZOaw==,type:str]
    pgp: []
    unencrypted_suffix: _unencrypted
    version: 3.8.1

```

# config/zsh.nix

```nix
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

```

# config/zellij.nix

```nix
{
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "custom";
      pane_frames = false;
      ui = {
        pane_frames = {
          rounded_corners = false;
          hide_session_name = true;  # This will hide the session name
        };
      };
      simplified_ui = true;
      default_mode = "normal";
      mouse_mode = true;
      scroll_buffer_size = 10000;
      copy_command = "pbcopy";
      copy_clipboard = "system";
      copy_on_select = true;
      scrollback_editor = "hx";
      default_layout = "compact";
    };
  };
}

```

# config/system.nix

```nix
{ pkgs, ... }: {
  nix.package = pkgs.nixFlakes;
  services.nix-daemon.enable = true;
  time.timeZone = "America/New_York";

  system.patches = [
    (pkgs.writeText "pam_tid.patch" ''
      --- /etc/pam.d/sudo	2023-09-28 09:27:50
      +++ /etc/pam.d/sudo	2023-09-28 09:27:54
      @@ -1,4 +1,6 @@
       # sudo: auth account password session
      +auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so
      +auth       sufficient     pam_tid.so
       auth       include        sudo_local
       auth       sufficient     pam_smartcard.so
       auth       required       pam_opendirectory.so
    '')
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.shells = [ pkgs.zsh ];
  programs.zsh = {
    enable = true;
  };

  system.defaults = {
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
    screencapture.type = "png";

    finder = {
      ShowPathbar = true;
      ShowStatusBar = true;
    };
  };
}

```

# config/packages.nix

```nix
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
      cachix
      docker
      ffmpeg_5
      fzf
      go
      htop
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

```

# config/home.nix

```nix
{ config, pkgs, lib, ... }:
{
  home.username = "ay";
  home.homeDirectory = lib.mkForce "/Users/ay";
  home.stateVersion = "23.11";
  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;

  imports = [
    ./packages.nix
    ./zsh.nix
    ./zellij.nix
    ./helix.nix
    ./tools/git.nix
    ./tools/gpg.nix
    ./tools/ssh.nix
    ./ghostty.nix
  ];
  # Yazi configuration
  home.file.".config/yazi/themes/yazi.toml".source = ./themes/yazi.toml;
  
  # Zellij Theme
  home.file.".config/zellij/themes/custom.kdl".source = ./themes/zellij.kdl;

  programs.bat = {
      enable = true;
      config = {
        theme = "Ashys";
      };
      themes = {
        Ashys = {
          src = ./themes/bat.tmTheme;
        };
      };
    };

  sops = {
    defaultSopsFile = ../secrets/git_config.yaml;
    age.keyFile = "/Users/ay/.config/sops/age/keys.txt";
  };

  sops.secrets.git_config = {
    path = "${config.home.homeDirectory}/.gitconfig-secret";
    mode = "0600";
  };

  programs.git = {
    enable = true;
    includes = [{ path = config.sops.secrets.git_config.path; }];
  };

  # applying secret after creation
  home.activation.setupGitConfig = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ -f "${config.sops.secrets.git_config.path}" ]; then
      ${pkgs.git}/bin/git config --global --remove-section include || true
      ${pkgs.git}/bin/git config --global include.path "${config.sops.secrets.git_config.path}"
    fi
  '';
}

```

# config/helix.nix

```nix
{ config, pkgs, ... }: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "ashys";
      editor = {
        line-number = "absolute";
        mouse = false;
        auto-format = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        statusline = {
          left = [ "mode" "version-control" "spinner" "file-modification-indicator" ];
          center = [ "file-name" ];
          right = [ "diagnostics" "position-percentage" "file-encoding" "file-type" ];
          mode = {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
        };
        soft-wrap = {
          enable = true;
        };
        lsp = {
          display-inlay-hints = true;
          display-messages = true;
        };
        color-modes = true;
      };
    };
    languages = {
      language = [
        {
          name = "go";
          auto-format = true;
          language-server = { command = "gopls"; };
        }
        {
          name = "graphql";
          auto-format = true;
          language-server = { command = "graphql-lsp"; args = ["server" "-m" "stream"]; };
        }
        {
          name = "haskell";
          auto-format = true;
          language-server = { command = "haskell-language-server-wrapper"; args = ["--lsp"]; };
        }
        {
          name = "typescript";
          auto-format = true;
          language-server = { command = "typescript-language-server"; args = ["--stdio"]; };
        }
        {
          name = "javascript";
          auto-format = true;
          language-server = { command = "typescript-language-server"; args = ["--stdio"]; };
        }
        {
          name = "json";
          auto-format = true;
          language-server = { command = "vscode-json-languageserver"; args = ["--stdio"]; };
        }
        {
          name = "latex";
          auto-format = true;
          language-server = { command = "texlab"; };
        }
        {
          name = "lua";
          auto-format = true;
          language-server = { command = "lua-language-server"; };
        }
        {
          name = "markdown";
          auto-format = true;
          language-server = { command = "marksman"; args = ["server"]; };
        }
        {
          name = "nix";
          auto-format = true;
          language-server = { command = "nil"; };
        }
        {
          name = "python";
          auto-format = true;
          language-server = { command = "pylsp"; };
        }
        {
          name = "racket";
          auto-format = true;
          language-server = { command = "racket"; args = ["-l" "racket-langserver"]; };
        }
        {
          name = "rust";
          auto-format = true;
          language-server = { command = "rust-analyzer"; };
        }
        {
          name = "svelte";
          auto-format = true;
          language-server = { command = "svelteserver"; args = ["--stdio"]; };
        }
        {
          name = "toml";
          auto-format = true;
          language-server = { command = "taplo"; args = ["lsp" "stdio"]; };
        }
        {
          name = "vue";
          auto-format = true;
          language-server = { command = "volar-server"; args = ["--stdio"]; };
        }
        {
          name = "yaml";
          auto-format = true;
          language-server = { command = "yaml-language-server"; args = ["--stdio"]; };
        }
      ];
      language-server = {
        gopls = {
          config.hints = { assignVariableTypes = true; compositeLiteralFields = true; constantValues = true; functionTypeParameters = true; parameterNames = true; rangeVariableTypes = true; };
        };
        rust-analyzer = {
          config = {
            checkOnSave = { command = "clippy"; };
            inlayHints = { enable = true; chainingHints = true; typeHints = true; parameterHints = true; };
          };
        };
        typescript-language-server = {
          config = {
            inlayHints = { includeInlayParameterNameHints = "all"; includeInlayParameterNameHintsWhenArgumentMatchesName = true; includeInlayFunctionParameterTypeHints = true; includeInlayVariableTypeHints = true; includeInlayPropertyDeclarationTypeHints = true; includeInlayFunctionLikeReturnTypeHints = true; includeInlayEnumMemberValueHints = true; };
          };
        };
      };
    };
  };
  home.file.".config/helix/themes/ashys.toml".source = ./themes/helix.toml;
  home.packages = with pkgs; [
    # Go
    gopls
    delve  # for godlv DAP
    # GraphQL
    nodePackages.graphql-language-service-cli
    # Haskell
    haskell-language-server
    # TypeScript/JavaScript
    nodePackages.typescript-language-server
    # JSON
    nodePackages.vscode-json-languageserver
    # LaTeX
    texlab
    # Lua
    lua-language-server
    # Markdown
    marksman
    # Nix
    nil
    # Python
    python3Packages.python-lsp-server
    # Racket
    racket
    # Rust (LLDB for DAP)
    lldb
    # Svelte
    nodePackages.svelte-language-server
    # TOML
    taplo
    # Vue
    nodePackages.volar
    # YAML
    nodePackages.yaml-language-server
  ];
  # Ensure the binaries are in PATH
  home.sessionPath = [
    "${config.home.homeDirectory}/.nix-profile/bin"
  ];
}

```

# config/ghostty.nix

```nix
{ config, pkgs, ... }: {
  home.file.".config/ghostty/config".text = ''
    background = #0a0a0a
    foreground = #E6D7C3
    font-family = MesloLGS NF
    font-size = 13
    window-padding = 10
    opacity = 0.8
    macos-option-as-alt = true
    
    keybind = ctrl+shift+t=new_tab
    keybind = ctrl+shift+w=close_surface
    keybind = ctrl+shift+l=next_tab
    keybind = ctrl+shift+h=previous_tab
  '';
}

```

# config/brew.nix

```nix
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

```

# config/.zshrc

```
# check if wezterm is available before trying to use cli
function hx() {
    if command -v wezterm &> /dev/null; then
        wezterm cli set-user-var IS_HELIX true
        command hx "$@"
        wezterm cli set-user-var IS_HELIX false
    else
        command hx "$@"
    fi
}

# Function to start Zellij with current date as session name
zj() {
  ZELLIJ_SESSION_NAME=$(date '+%Y-%m-%d') zellij "$@"
}

# Alias for quick access
alias zellij='zj'

```

# config/.zsh.nix.swp

This is a binary file of the type: Binary

# config/tools/ssh.nix

```nix
{ config, ... }: {
  programs.ssh = {
    enable = true;
    compression = true;
    controlMaster = "auto";
    controlPath = "/tmp/ssh-%C";
    forwardAgent = true;
    serverAliveInterval = 0;
    serverAliveCountMax = 3;
    hashKnownHosts = false;
    userKnownHostsFile = "~/.ssh/known_hosts";
    extraConfig = ''
      ControlPersist no
    '';
    includes = [
      "${config.home.homeDirectory}/.ssh/private.config"
      "${config.home.homeDirectory}/.orbstack/ssh/config"
    ];
    matchBlocks = {
      "*" = {
        compression = true;
        forwardAgent = true;
      };
      "github.com-ay" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_ay_github";
      };
      "github.com-a0" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_a0_github";
      };
      "github.com-db" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_db_github";
      };
    };
  };
}

```

# config/tools/secret-git-config.nix

```nix
{
  # User configurations
  users = {
    "ay" = {
      name = "ay-mxn";
      email = "171892944+ay-mxn@users.noreply.github.com";
    };
    "a0" = {
      name = "0x616e6f73";
      email = "170067277+0x616e6f73@users.noreply.github.com";
    };
    "db" = {
      name = "deyba";
      email = "162001893+deyba@users.noreply.github.com";
    };
  };

  # Conditional includes based on directory
  includeIf = {
    "gitdir:~/Developer/ay/" = { path = "~/.gitconfig-ay"; };
    "gitdir:~/Developer/a0/" = { path = "~/.gitconfig-a0"; };
    "gitdir:~/Developer/db/" = { path = "~/.gitconfig-db"; };
  };

  # URL configurations for each account
  url = {
    "git@github.com:0x616e6f73/".pushInsteadOf = "https://github.com/0x616e6f73/";
    "git@github.com:deyba/".pushInsteadOf = "https://github.com/deyba/";
    "git@github.com:ay-mxn/".pushInsteadOf = "https://github.com/ay-mxn/";
  };
}

```

# config/tools/gpg.nix

```nix
{ pkgs, config, ... }:
let
  pinentry-mac = "${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac";
in
{
  home.packages = with pkgs; [ pinentry_mac ];
  programs.gpg = {
    enable = true;
    settings = {
      keyserver = "hkps://keys.openpgp.org";
      default-key = "DAC000FB21724987B6E4285B61E3471801612925";
    };
  };

  home.file."gnupg/gpg-agent.conf".text =
    ''
      	enable-ssh-support
      	default-cache-ttl 600
      	default-cache-ttl-ssh 600
      	max-cache-ttl 7200
      	max-cache-ttl-ssh 7200
      	use-standard-socket
      	pinentry-program ${pinentry-mac}
    '';
}

```

# config/tools/git.nix

```nix
{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    aliases = {
      redo = "commit --amend -S";
      switch-account = "!f() { git config user.name \"$(git config user.$1.name)\" && git config user.email \"$(git config user.$1.email)\" && echo \"Switched to $1: $(git config user.name) <$(git config user.email)>\"; }; f";
      check-account = "!git config user.name && git config user.email";
    };
    extraConfig = {
      core.editor = "${pkgs.helix}/bin/helix";
      pull.rebase = true;
      init.defaultBranch = "main";
      protocol.version = 2;
      submodule.fetchJobs = 4;
      merge.conflictstyle = "diff3";
      push.autoSetupRemote = true;
    };
  };

  sops.secrets.git_config = {
    path = "${config.home.homeDirectory}/.gitconfig-secret";
    mode = "0600";
  };

  home.activation.setupGitConfig = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ -f "${config.sops.secrets.git_config.path}" ]; then
      ${pkgs.git}/bin/git config --global --remove-section include || true
      ${pkgs.git}/bin/git config --global include.path "${config.sops.secrets.git_config.path}"
    fi
  '';
}

```

# config/themes/zellij.kdl

```kdl
themes {
    custom {
        fg "#E6D7C3"
        bg "#0a0a0a"
        black "#0a0a0a"
        red "#EA4727"
        green "#48E998"
        yellow "#FDDF6E"
        blue "#5EC4FF"
        magenta "#BD2423"
        cyan "#2F6883"
        white "#E6D7C3"
        orange "#FBA445"
    }
}

ui {
    pane_frames {
        rounded_corners true
        hide_session_name false
    }
}

themes {
    custom {
        tab_bar {
            background "#0a0a0a"
            active_tab {
                bg_color "#5EC4FF"
                fg_color "#0a0a0a"
            }
            inactive_tab {
                bg_color "#0a0a0a"
                fg_color "#E6D7C3"
            }
        }
        pane_frames {
            active {
                bg_color "#5EC4FF"
                fg_color "#0a0a0a"
            }
            inactive {
                bg_color "#0a0a0a"
                fg_color "#E6D7C3"
            }
        }
        status_bar {
            background "#0a0a0a"
            text "#E6D7C3"
        }
    }
}

```

# config/themes/yazi.toml

```toml
# color scheme for yazi
[manager]
cwd = { fg = "#E6D7C3" }

[status]
separator_open  = ""
separator_close = ""

[status.normal]
fg   = "#151515"
bg   = "#5EC4FF"

[status.select]
fg   = "#151515"
bg   = "#48E998"

[status.insert]
fg   = "#151515"
bg   = "#FDDF6E"

[status.visual]
fg   = "#151515"
bg   = "#FBA445"

[status.rename]
fg   = "#151515"
bg   = "#BD2423"

[status.delete]
fg   = "#151515"
bg   = "#EA4727"

[log]
debug = { fg = "#5EC4FF" }
info  = { fg = "#48E998" }
warn  = { fg = "#FDDF6E" }
error = { fg = "#EA4727" }

[filetype]
rules = [
	# Images
	{ mime = "image/*", fg = "#48E998" },

	# Videos
	{ mime = "video/*", fg = "#5EC4FF" },

	# Audio
	{ mime = "audio/*", fg = "#FDDF6E" },

	# Archives
	{ mime = "application/zip", fg = "#FBA445" },
	{ mime = "application/gzip", fg = "#FBA445" },
	{ mime = "application/x-tar", fg = "#FBA445" },

	# Fallback
	{ name = "*", fg = "#E6D7C3" },
]

[icon]
rules = [
	# Default fallback
	{ name = "*", text = "" },
	# Directory
	{ type = "directory", text = "" },
	# Executable
	{ type = "executable", text = "" },
	# Regular file
	{ type = "file", text = "" },
]

[input]
border   = { fg = "#5EC4FF" }
title    = { fg = "#E6D7C3" }
value    = { fg = "#E6D7C3" }
selected = { fg = "#151515", bg = "#5EC4FF" }

[completion]
border   = { fg = "#5EC4FF" }
active   = { fg = "#151515", bg = "#5EC4FF" }
inactive = { fg = "#E6D7C3" }

[select]
border   = { fg = "#48E998" }
active   = { fg = "#151515", bg = "#48E998" }
inactive = { fg = "#E6D7C3" }

[tasks]
border  = { fg = "#FDDF6E" }
title   = { fg = "#E6D7C3" }
hovered = { underline = true }

[which]
mask            = { bg = "#151515CC" }
cand            = { fg = "#E6D7C3" }
rest            = { fg = "#5EC4FF" }
desc            = { fg = "#48E998" }
separator       = "  "
separator_style = { fg = "#FDDF6E" }

```

# config/themes/wezterm.lua

```lua
local wezterm = require("wezterm")

local config = {}

if wezterm.gui then
    local gpus = wezterm.gui.enumerate_gpus()
    config.webgpu_preferred_adapter = gpus[1]
    config.front_end = 'WebGpu'
end

config.font = wezterm.font("MesloLGS NF", { weight = "Regular" })
config.font_size = 13.0
config.bold_brightens_ansi_colors = true
config.color_scheme = 'Glacier'
config.colors = {
    -- Normally #0a0a0a when going transparent
    background = "#0a0a0a" -- Default background color
}
config.window_background_opacity = 0.8
config.macos_window_background_blur = 25
config.window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
}

local function update_appearance(window, pane)
    local overrides = window:get_config_overrides() or {}
    local foreground_process = pane:get_foreground_process_name()
    if foreground_process:find("hx") then
        overrides.window_background_opacity = 1.0
        overrides.colors = { background = "#0a0a0a" }
        overrides.window_padding = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0,
        }
    else
        -- Normally this would be #0a0a0a @ 0.8, but I'm switching off of transparency while I rebuild the full dev suite
        overrides.window_background_opacity = 0.8
        overrides.colors = { background = "#0a0a0a" }
        overrides.window_padding = {
            left = 10,
            right = 10,
            top = 10,
            bottom = 10,
        }
    end
    window:set_config_overrides(overrides)
end

wezterm.on("update-right-status", function(window, pane)
    update_appearance(window, pane)
end)

config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.cursor_blink_rate = 500
config.default_cursor_style = "SteadyBar"
config.scrollback_lines = 1000
config.use_dead_keys = false
config.window_decorations = "RESIZE"
config.default_prog = { "zsh", "-l" }
config.term = "xterm-256color"

return config

```

# config/themes/helix.toml

```toml
"ui.background" = {}  # Removed bg property
"ui.text" = { fg = "#E6D7C3" }
"ui.text.focus" = { fg = "#0a0a0a", bg = "#48E998" }  # This controls the branch name styling
"ui.virtual.ruler" = { bg = "#48E99820" }  # This adds a subtle background to separate it
"comment" = { fg = "#34A76F" }
"constant" = { fg = "#FDDF6E" }
"constant.numeric" = { fg = "#FDDF6E" }
"string" = { fg = "#FBA445" }
"variable" = { fg = "#5EC4FF" }
"keyword" = { fg = "#EA4727" }
"operator" = { fg = "#BD2423" }
"function" = { fg = "#48E998" }
"type" = { fg = "#2F6883" }
"namespace" = { fg = "#5EC4FF" }
"punctuation" = { fg = "#E6D7C3" }
"punctuation.delimiter" = { fg = "#E6D7C3" }
"punctuation.bracket" = { fg = "#E6D7C3" }
"variable.other.member" = { fg = "#5EC4FF" }
"variable.parameter" = { fg = "#E6D7C3" }
"variable.builtin" = { fg = "#EA4727" }
"constructor" = { fg = "#2F6883" }
"special" = { fg = "#EA4727" }
"markup.heading" = { fg = "#FDDF6E", modifiers = ["bold"] }
"markup.list" = { fg = "#FBA445" }
"markup.bold" = { fg = "#FDDF6E", modifiers = ["bold"] }
"markup.italic" = { fg = "#5EC4FF", modifiers = ["italic"] }
"markup.link.url" = { fg = "#5EC4FF", modifiers = ["underlined"] }
"markup.link.text" = { fg = "#FDDF6E" }
"markup.quote" = { fg = "#34A76F" }
"markup.raw" = { fg = "#FDDF6E" }
"diff.plus" = { fg = "#48E998" }
"diff.minus" = { fg = "#FBA445" }
"diff.delta" = { fg = "#FDDF6E" }
"ui.cursor" = { fg = "#E6D7C3", modifiers = ["reversed"] }
"ui.cursor.primary" = { fg = "#E6D7C3", modifiers = ["reversed"] }
"ui.cursor.match" = { fg = "#FDDF6E", modifiers = ["underlined"] }
"ui.selection" = { bg = "#2A2A2A80" }  # Added some transparency
"ui.selection.primary" = { bg = "#2A2A2A80" }  # Added some transparency
"ui.linenr" = { fg = "#4A3C2E" }
"ui.linenr.selected" = { fg = "#E6D7C3" }
"ui.statusline" = { fg = "#E6D7C3" }  # Removed bg property
"ui.statusline.inactive" = { fg = "#34A76F" }  # Removed bg property
"ui.popup" = { bg = "#1C1C1C80" }  # Added some transparency
"ui.window" = {}  # Removed bg property
"ui.help" = { fg = "#E6D7C3" }  # Removed bg property
"error" = { fg = "#FBA445" }
"warning" = { fg = "#FDDF6E" }
"info" = { fg = "#5EC4FF" }
"hint" = { fg = "#34A76F" }
"diagnostic.error" = { underline = { style = "curl", color = "#FBA445" } }
"diagnostic.warning" = { underline = { style = "curl", color = "#FDDF6E" } }
"diagnostic.info" = { underline = { style = "curl", color = "#5EC4FF" } }
"diagnostic.hint" = { underline = { style = "curl", color = "#34A76F" } }
"ui.statusline.normal" = { fg = "#0a0a0a", bg = "#48E99880" }  # Added some transparency
"ui.statusline.insert" = { fg = "#0a0a0a", bg = "#FDDF6E80" }  # Added some transparency
"ui.statusline.select" = { fg = "#0a0a0a", bg = "#AD2421" }  # Added some transparency

[palette]
# Removed background property
foreground = "#E6D7C3"

```

# config/themes/bat.tmTheme

```tmTheme
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>name</key>
    <string>ArkDark</string>
    <key>settings</key>
    <array>
        <dict>
            <key>settings</key>
            <dict>
                <key>background</key>
                <string>#151515</string>
                <key>foreground</key>
                <string>#E6D7C3</string>
                <key>caret</key>
                <string>#E6D7C3</string>
                <key>invisibles</key>
                <string>#4A3C2E</string>
                <key>lineHighlight</key>
                <string>#2A2A2A</string>
                <key>selection</key>
                <string>#2A2A2A</string>
            </dict>
        </dict>
        <dict>
            <key>name</key>
            <string>Comment</string>
            <key>scope</key>
            <string>comment</string>
            <key>settings</key>
            <dict>
                <key>foreground</key>
                <string>#34A76F</string>
            </dict>
        </dict>
        <dict>
            <key>name</key>
            <string>String</string>
            <key>scope</key>
            <string>string</string>
            <key>settings</key>
            <dict>
                <key>foreground</key>
                <string>#FBA445</string>
            </dict>
        </dict>
        <dict>
            <key>name</key>
            <string>Number</string>
            <key>scope</key>
            <string>constant.numeric</string>
            <key>settings</key>
            <dict>
                <key>foreground</key>
                <string>#FDDF6E</string>
            </dict>
        </dict>
        <dict>
            <key>name</key>
            <string>Built-in constant</string>
            <key>scope</key>
            <string>constant.language</string>
            <key>settings</key>
            <dict>
                <key>foreground</key>
                <string>#EA4727</string>
            </dict>
        </dict>
        <dict>
            <key>name</key>
            <string>Variable</string>
            <key>scope</key>
            <string>variable</string>
            <key>settings</key>
            <dict>
                <key>foreground</key>
                <string>#5EC4FF</string>
            </dict>
        </dict>
        <dict>
            <key>name</key>
            <string>Keyword</string>
            <key>scope</key>
            <string>keyword</string>
            <key>settings</key>
            <dict>
                <key>foreground</key>
                <string>#EA4727</string>
            </dict>
        </dict>
        <dict>
            <key>name</key>
            <string>Storage</string>
            <key>scope</key>
            <string>storage</string>
            <key>settings</key>
            <dict>
                <key>foreground</key>
                <string>#BD2423</string>
            </dict>
        </dict>
        <dict>
            <key>name</key>
            <string>Class name</string>
            <key>scope</key>
            <string>entity.name.class</string>
            <key>settings</key>
            <dict>
                <key>foreground</key>
                <string>#48E998</string>
            </dict>
        </dict>
        <dict>
            <key>name</key>
            <string>Function name</string>
            <key>scope</key>
            <string>entity.name.function</string>
            <key>settings</key>
            <dict>
                <key>foreground</key>
                <string>#48E998</string>
            </dict>
        </dict>
        <dict>
            <key>name</key>
            <string>Operator</string>
            <key>scope</key>
            <string>keyword.operator</string>
            <key>settings</key>
            <dict>
                <key>foreground</key>
                <string>#BD2423</string>
            </dict>
        </dict>
    </array>
</dict>
</plist>

```

