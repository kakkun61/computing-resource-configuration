{ inputs, config, ... }:
let
  inherit (inputs) nixpkgs nixos-wsl;
  inherit (config.flake) nixosModules;
in
{
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
          nixosModules.common
          nixosModules.mdns
          nixosModules.sshd
          nixosModules.kubernetes
          nixosModules.tailscale
          nixosModules.cloudflare-tunnel-home
          ./configuration/gmk.nix
          { system.stateVersion = "25.05"; }
        ];
      };
      surface-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixosModules.common
          nixosModules.wsl
          nixosModules.docker
          nixosModules.tailscale
          ./configuration/surface-wsl.nix
          { system.stateVersion = "25.05"; }
        ];
      };
      maihama-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixosModules.common
          nixosModules.wsl
          nixosModules.docker
          ./configuration/maihama-wsl.nix
          { system.stateVersion = "25.05"; }
        ];
      };
      utm = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./hardware-configuration/utm.nix
          nixosModules.common
          nixosModules.sshd
          ./configuration/utm.nix
          { system.stateVersion = "25.11"; }
        ];
      };
    };
  };
}
