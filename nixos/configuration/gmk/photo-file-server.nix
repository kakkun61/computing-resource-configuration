{
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
