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
          language-servers = { command = "gopls"; };
        }
        {
          name = "graphql";
          auto-format = true;
          language-servers = { command = "graphql-lsp"; args = ["server" "-m" "stream"]; };
        }
        {
          name = "haskell";
          auto-format = true;
          language-servers = { command = "haskell-language-server-wrapper"; args = ["--lsp"]; };
        }
        {
          name = "typescript";
          auto-format = true;
          language-servers = { command = "typescript-language-server"; args = ["--stdio"]; };
        }
        {
          name = "javascript";
          auto-format = true;
          language-servers = { command = "typescript-language-server"; args = ["--stdio"]; };
        }
        {
          name = "json";
          auto-format = true;
          language-servers = { command = "vscode-json-languageserver"; args = ["--stdio"]; };
        }
        {
          name = "latex";
          auto-format = true;
          language-servers = { command = "texlab"; };
        }
        {
          name = "lua";
          auto-format = true;
          language-servers = { command = "lua-language-server"; };
        }
        {
          name = "markdown";
          auto-format = true;
          language-servers = { command = "marksman"; args = ["server"]; };
        }
        {
          name = "nix";
          auto-format = true;
          language-servers = { command = "nil"; };
        }
        {
          name = "python";
          auto-format = true;
          language-servers = { command = "pylsp"; };
        }
        {
          name = "racket";
          auto-format = true;
          language-servers = { command = "racket"; args = ["-l" "racket-langserver"]; };
        }
        {
          name = "rust";
          auto-format = true;
          language-servers = { command = "rust-analyzer"; };
        }
        {
          name = "svelte";
          auto-format = true;
          language-servers = { command = "svelteserver"; args = ["--stdio"]; };
        }
        {
          name = "toml";
          auto-format = true;
          language-servers = { command = "taplo"; args = ["lsp" "stdio"]; };
        }
        {
          name = "vue";
          auto-format = true;
          language-servers = { command = "volar-server"; args = ["--stdio"]; };
        }
        {
          name = "yaml";
          auto-format = true;
          language-servers = { command = "yaml-language-server"; args = ["--stdio"]; };
        }
      ];
      language-servers = {
        gopls = {
          config.hints = { assignVariableTypes = true; compositeLiteralFields = true; constantValues = true; functionTypeParameters = true; parameterNames = true; rangeVariableTypes = true; };
        };
        rust-analyzer = {
          config = {
            checkOnSave = { command = "clippy"; };
            inlayHints = { enable = true; chainingHints = true; typeHints = true; parameterHints = true; };
          };
        };
        typescript-language-servers = {
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
