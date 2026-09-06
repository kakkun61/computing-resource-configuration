{
  description = "This gives an environment to develop home.nix and provides it";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.11";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
      };
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      home-manager,
      git,
      my-pkgs,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ home-manager.flakeModules.home-manager ];
      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem =
        {
          pkgs,
          ...
        }:
        {
          packages.ssh-agent-wsl = import ./home-manager/ssh-agent-wsl.nix { inherit pkgs; };
        };
      flake = {
        homeModules.default = import ./home-manager/home.nix {
          inherit git;
          root = ./.;
        };
        templates.default = import ./home-manager/template.nix;
        homeConfigurations =
          let
            mkTestConfiguration =
              system:
              home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs {
                  inherit system;
                  config.allowUnfree = true;
                };
                modules = [
                  self.homeModules.default
                  { home.stateVersion = "25.11"; }
                ];
              };
          in
          {
            gmk = home-manager.lib.homeManagerConfiguration {
              pkgs = import nixpkgs {
                system = "x86_64-linux";
                config.allowUnfree = true;
                overlays = [ my-pkgs.overlays.default ];
              };
              modules = [
                self.homeModules.default
                ./home-manager/configuration/gmk.nix
                { home.stateVersion = "25.05"; }
              ];
            };
            surface-wsl = home-manager.lib.homeManagerConfiguration {
              pkgs = import nixpkgs {
                system = "x86_64-linux";
                config.allowUnfree = true;
              };
              modules = [
                self.homeModules.default
                ./home-manager/configuration/surface-wsl.nix
                { home.stateVersion = "24.05"; }
              ];
            };
            # ファイル生成用・テスト用の設定
            test-x86_64-linux = mkTestConfiguration "x86_64-linux";
            test-aarch64-darwin = mkTestConfiguration "aarch64-darwin";
          };
      };
    };
}
