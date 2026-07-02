{
  description = "My Nix OS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-wsl,
      nix-darwin,
      flake-parts,
      ...
    }:

    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      flake = {
        nixosModules = {
          cloudflare-tunnel-home = import ./module/cloudflare-tunnel-home.nix;
          common = import ./module/common.nix;
          docker = import ./module/docker.nix;
          kubernetes = import ./module/kubernetes.nix;
          mdns = import ./module/mdns.nix;
          podman = import ./module/podman.nix;
          secret = import ./module/secret.nix;
          sshd = import ./module/sshd.nix;
          tailscale = import ./module/tailscale.nix;
          wsl = import ./module/wsl.nix { inherit nixos-wsl; };
        };

        darwinModules = {
          common = import ./module/common.darwin.nix;
        };

        nixosConfigurations = {
          gmk = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./hardware-configuration/gmk.nix
              self.nixosModules.common
              self.nixosModules.mdns
              self.nixosModules.sshd
              self.nixosModules.kubernetes
              self.nixosModules.tailscale
              self.nixosModules.cloudflare-tunnel-home
              ./configuration/gmk.nix
              { system.stateVersion = "25.05"; }
            ];
          };
          surface-wsl = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              self.nixosModules.common
              self.nixosModules.wsl
              self.nixosModules.docker
              self.nixosModules.tailscale
              ./configuration/surface-wsl.nix
              { system.stateVersion = "25.05"; }
            ];
          };
          utm = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              ./hardware-configuration/utm.nix
              self.nixosModules.common
              self.nixosModules.sshd
              ./configuration/utm.nix
              { system.stateVersion = "25.11"; }
            ];
          };
        };
      };
    };
}
