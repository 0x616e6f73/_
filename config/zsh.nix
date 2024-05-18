{ pkgs, lib, ... }: {
  programs.zsh = {
    enable = true;

    initExtra = builtins.readFile ./.zshrc;
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
