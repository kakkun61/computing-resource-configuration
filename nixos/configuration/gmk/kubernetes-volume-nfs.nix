{
  services.nfs.server = {
    enable = true;
    exports = ''
      /mnt/usb-raid/kubernetes *(rw,sync,no_subtree_check,no_root_squash)
    '';
  };

  networking.firewall = {
    allowedTCPPorts = [
      111
      2049
      20048
    ];
    allowedUDPPorts = [
      111
      2049
      20048
    ];
  };
}
