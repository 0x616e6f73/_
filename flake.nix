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
  };

  outputs = { self, pkgs, u_pkgs, hm, os }:
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
              users.ay = import ./config/home.nix;
            };
          }
          ./config/system.nix
          ./config/brew.nix
        ];
      };
    };
}
