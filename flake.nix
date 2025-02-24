{
  inputs = {
    pkgs.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    u_pkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    hm = {
      url = "github:nix-community/home-manager/release-24.11";
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
      system = "aarch64-darwin";
      unstable = u_pkgs.legacyPackages.${system};
    in {
      darwinConfigurations."net-2" = os.lib.darwinSystem {
        inherit system;
        modules = [
          ./config/system.nix
          hm.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit unstable; };
              users.ay = { pkgs, ... }: {
                imports = [
                  ./config/home.nix
                  sops-nix.homeManagerModules.sops
                ];
              };
            };
          }
          ({ pkgs, ... }: {
            nix.package = pkgs.nix;
            programs.nix-index.enable = true; 
            environment.systemPackages = [
              pkgs.nix
            ];
          })
        ];
      };
      
      devShells.${system}.default = pkgs.legacyPackages.${system}.mkShell {
        buildInputs = with pkgs.legacyPackages.${system}; [
          age
          sops
        ];
      };
    };
}
