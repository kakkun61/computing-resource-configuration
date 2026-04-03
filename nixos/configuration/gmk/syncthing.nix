{ config, ... }: {
  services.syncthing = {
    enable = true;
    guiAddress = "gmk.local.kakkun61.com:8384";
    openDefaultPorts = true;
    settings = {
      devices.surface.id = "6BLKZ4X-4MXV2IS-FOGMCRQ-AU7ALUP-IMAEGTP-65G6OB3-LJ46OVA-BT5JQQH";
      folders."/srv/syncthing".devices = [ "surface" ];
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      8384
    ];
  };
}
