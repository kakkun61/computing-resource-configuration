{ inputs, config, ... }:
let
  inherit (inputs)
    nixpkgs
    home-manager
    git
    my-pkgs
    ;
  inherit (config.flake) homeModules;
in
{
  imports = [ home-manager.flakeModules.home-manager ];
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
      coding-agent = ../coding-agent;
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
              homeModules.default
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
            homeModules.default
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
            homeModules.default
            ./home-manager/configuration/surface-wsl.nix
            { home.stateVersion = "24.05"; }
          ];
        };
        maihama-wsl = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          modules = [
            homeModules.default
            ./home-manager/configuration/maihama-wsl.nix
            { home.stateVersion = "24.05"; }
          ];
        };
        # ファイル生成用・テスト用の設定
        test-x86_64-linux = mkTestConfiguration "x86_64-linux";
        test-aarch64-darwin = mkTestConfiguration "aarch64-darwin";
      };
  };
}
