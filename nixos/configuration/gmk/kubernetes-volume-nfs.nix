{
  services.nfs.server = {
    enable = true;
    exports = ''
      /mnt/usb-raid/kubernetes *(rw,sync,no_subtree_check,no_root_squash)
    '';
  };
}
