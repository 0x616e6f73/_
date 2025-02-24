{ config, pkgs, ... }: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "arabia";
      editor = {
        line-number = "absolute";
        mouse = false;
        auto-format = true;
        end-of-line-diagnostics = "hint";
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
        inline-diagnostics = {
          cursor-line = "error";
        };
        lsp = {
          display-inlay-hints = true;
          display-messages = true;
          snippets = false;
        };
        color-modes = true;
      };
    };
    languages = {
      language = [
        {
          name = "go";
          auto-format = true;
          language-servers = [ "gopls" ];
        }
        {
          name = "graphql";
          auto-format = true;
          language-servers = [ "graphql-lsp" ];
        }
        {
          name = "haskell";
          auto-format = true;
          language-servers = [ "haskell-language-server-wrapper" ];
        }
        {
          name = "typescript";
          auto-format = true;
          language-servers = [ "typescript-language-server" ];
        }
        {
          name = "javascript";
          auto-format = true;
          language-servers = [ "typescript-language-server" ];
        }
        {
          name = "json";
          auto-format = true;
          language-servers = [ "vscode-json-languageserver" ];
        }
        {
          name = "latex";
          auto-format = true;
          language-servers = [ "texlab" ];
        }
        {
          name = "lua";
          auto-format = true;
          language-servers = [ "lua-language-server" ];
        }
        {
          name = "markdown";
          auto-format = true;
          language-servers = [ "marksman" ];
        }
        {
          name = "nix";
          auto-format = true;
          language-servers = [ "nil" ];
        }
        {
          name = "python";
          auto-format = true;
          language-servers = [ "pylsp" ];
        }
        {
          name = "racket";
          auto-format = true;
          language-servers = [ "racket" ];
        }
        {
          name = "rust";
          auto-format = true;
          language-servers = [ "rust-analyzer" ];
        }
        {
          name = "svelte";
          auto-format = true;
          language-servers = [ "svelteserver" ];
        }
        {
          name = "toml";
          auto-format = true;
          language-servers = [ "taplo" ];
        }
        {
          name = "yaml";
          auto-format = true;
          language-servers = [ "yaml-language-server" ];
        }
      ];
      language-server = {
        gopls = {
          command = "gopls";
          config.hints = { assignVariableTypes = true; compositeLiteralFields = true; constantValues = true; functionTypeParameters = true; parameterNames = true; rangeVariableTypes = true; };
        };
        "graphql-lsp" = {
          command = "graphql-lsp";
          args = ["server" "-m" "stream"];
        };
        "haskell-language-server-wrapper" = {
          command = "haskell-language-server-wrapper";
          args = ["--lsp"];
        };
        "typescript-language-server" = {
          command = "typescript-language-server";
          args = ["--stdio"];
          config = {
            inlayHints = { includeInlayParameterNameHints = "all"; includeInlayParameterNameHintsWhenArgumentMatchesName = true; includeInlayFunctionParameterTypeHints = true; includeInlayVariableTypeHints = true; includeInlayPropertyDeclarationTypeHints = true; includeInlayFunctionLikeReturnTypeHints = true; includeInlayEnumMemberValueHints = true; };
          };
        };
        "vscode-json-languageserver" = {
          command = "vscode-json-languageserver";
          args = ["--stdio"];
        };
        texlab = {
          command = "texlab";
        };
        "lua-language-server" = {
          command = "lua-language-server";
        };
        marksman = {
          command = "marksman";
          args = ["server"];
        };
        nil = {
          command = "nil";
        };
        pylsp = {
          command = "pylsp";
        };
        racket = {
          command = "racket";
          args = ["-l" "racket-langserver"];
        };
        "rust-analyzer" = {
          command = "rust-analyzer";
          config = {
            checkOnSave = { command = "clippy"; };
            inlayHints = { enable = true; chainingHints = true; typeHints = true; parameterHints = true; };
          };
        };
        svelteserver = {
          command = "svelteserver";
          args = ["--stdio"];
        };
        taplo = {
          command = "taplo";
          args = ["lsp" "stdio"];
        };
        "yaml-language-server" = {
          command = "yaml-language-server";
          args = ["--stdio"];
        };
      };
    };
  };
  home.file.".config/helix/themes/arabia.toml".source = ./themes/helix.toml;
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
    # YAML
    nodePackages.yaml-language-server
  ];
  # Ensure the binaries are in PATH
  home.sessionPath = [
    "${config.home.homeDirectory}/.nix-profile/bin"
  ];
}
