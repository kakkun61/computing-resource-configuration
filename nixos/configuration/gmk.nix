{
  imports = [ ./gmk/photo-file-server.nix ];

  config = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "gmk";
    networking.wireless.enable = true;
  };
}
