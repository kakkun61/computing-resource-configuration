{
  services = {
    samba = {
      enable = true;
      openFirewall = true;

      settings = {
        global = {
          workgroup = "WORKGROUP";
        };

        photos = {
          path = "/mnt/usb-raid/photos";
          browseable = "yes";
          "valid users" = "kazuki";
          "write list" = "kazuki";
          "read only" = "no";
          "create mask" = "0600";
          "directory mask" = "0700";
        };
      };
    };

    nfs.server = {
      enable = true;
      # filestash の配置されるノードが増えたら追記する
      # gmk ノードからは rw
      exports = ''
        /mnt/usb-raid/photos \
          192.168.11.52(rw,sync,no_subtree_check,no_root_squash) \
          *(ro,sync,no_subtree_check,no_root_squash)
      '';
    };
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
