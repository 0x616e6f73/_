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
