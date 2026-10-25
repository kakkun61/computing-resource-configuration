{ config, pkgs, ...}:
{
  boot.kernelModules = [  "vhci_hcd" ];
  environment.systemPackages = [ config.boot.kernelPackages.usbip ];
}
