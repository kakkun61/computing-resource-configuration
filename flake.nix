{
  description = "計算リソース設定集";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-26.05";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cspell-nix = {
      url = "github:kakkun61/cspell-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git = {
      url = "git+https://github.com/git/git";
      flake = false;
    };
    my-pkgs = {
      url = "github:kakkun61/nur-packages";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      flake-parts,
      treefmt-nix,
      cspell-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { config, ... }:
      {
        imports = [
          flake-parts.flakeModules.modules
          treefmt-nix.flakeModule
          cspell-nix.flakeModule
          ./home/flake-module.nix
          ./nixos/flake-module.nix
        ];
        systems = nixpkgs.lib.systems.flakeExposed;
        perSystem =
          {
            config,
            self',
            inputs',
            pkgs,
            system,
            ...
          }:
          {
            _module.args = {
              pkgs = import nixpkgs {
                inherit system;
                config = {
                  allowUnfree = true;
                };
              };
            };
            devShells.default = pkgs.mkShell {
              packages = with pkgs; [
                awscli2
                go
                nodejs
                terraform
              ];
            };
            treefmt.programs = {
              jsonfmt.enable = true;
              nixfmt.enable = true;
            };
            cspell.configFile = ./.cspell.yaml;
          };
        flake = {
          modules = {
            homeManager = config.flake.homeModules;
            nixos = config.flake.nixosModules;
          };
        };
      }
    );
}
