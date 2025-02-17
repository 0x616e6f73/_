{
  inputs = {
    pkgs.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    u_pkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    hm = {
      url = "github:nix-community/home-manager/release-24.05";
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
      darwinConfigurations."net-2" = os.lib.darwinSystem {
        inherit system;
        modules = [
          ./config/system.nix
          hm.darwinModules.home-manager
          ({ pkgs, ... }: {
            nixpkgs.overlays = [
              (self: super: {
                spicetify-cli = super.spicetify-cli.overrideAttrs (old: {
                  version = "2.39.3";
                  src = pkgs.fetchzip {
                    url = "https://github.com/spicetify/spicetify-cli/archive/refs/tags/v2.39.3.zip";
                    sha256 = "sha256-gYqvBWZMXH4CvnT5sPcKKptQpHrKpgzL8SSJdxvUcZw=";
                  };
                  postPatch = ''
                    export HOME=$TMPDIR
                    go mod download
                  '';
                });
              })
            ];
          })
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
          ({ pkgs, ... }: {
            # Use nix-darwin's tools
            nix.package = pkgs.nix;
            programs.nix-index.enable = true;
            environment.systemPackages = [
              pkgs.nix
            ];
          })
        ];
      };

      # Development shell definition
      devShells.${system}.default = pkgs.legacyPackages.${system}.mkShell {
        buildInputs = with pkgs.legacyPackages.${system}; [
          age
          sops
        ];
      };
    };
}
