{
  networking.hostName = "surface-wsl";

  # > systemd-resolved is enabled, but resolv.conf is managed by WSL (wsl.wslConf.network.generateResolvConf)
  services.resolved.enable = false;
}
