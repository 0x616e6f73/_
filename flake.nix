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
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit unstable; };
            home-manager.users.ay = { pkgs, ... }: {
              imports = [
                ./config/home.nix
                sops-nix.homeManagerModules.sops
              ];
            };
          }
          ./config/system.nix
          ./config/brew.nix
        ];
      };
    };
}
