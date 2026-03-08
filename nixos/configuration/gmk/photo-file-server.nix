{
  fileSystems."/mnt/usb-raid" = {
    device = "/dev/disk/by-uuid/5444f6b1-a5f9-4fb8-b163-c333986603d4";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
      "x-systemd.automount"
      "x-systemd.device-timeout=10"
    ];
  };

  services.samba = {
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
}
