{
  description = "計算リソース設定集";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.11";
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
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    my-home = {
      url = "path:./home";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    my-os = {
      url = "path:./nixos";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      flake-parts,
      treefmt-nix,
      cspell-nix,
      home-manager,
      my-home,
      my-os,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.modules
        treefmt-nix.flakeModule
        cspell-nix.flakeModule
        home-manager.flakeModules.home-manager
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
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [ nodejs ];
          };
          treefmt.programs = {
            jsonfmt.enable = true;
            nixfmt.enable = true;
          };
          cspell.configFile = ./.cspell.yaml;
        };
      flake = {
        inherit (my-home) homeModules homeConfigurations;
        inherit (my-os) nixosModules darwinModules nixosConfigurations;
        modules = {
          homeManager = my-home.homeModules;
          nixos = my-os.nixosModules;
        };
      };
    };
}
