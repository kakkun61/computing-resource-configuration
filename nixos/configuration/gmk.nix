{ config, ... }:
{
  imports = [
    ./gmk/kubernetes-volume-nfs.nix
    ./gmk/photo-file-server.nix
    ./gmk/syncthing.nix
  ];

  config = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking = {
      hostName = "gmk";
      wireless.enable = true;
      firewall = {
        allowedTCPPorts = [
          # 開発時に使うポートを開けておく
          3000
          3001
          3002
          3003
          3004
        ];
      };
    };

    fileSystems."/mnt/usb-raid" = {
      device = "/dev/disk/by-uuid/5444f6b1-a5f9-4fb8-b163-c333986603d4";
      fsType = "ext4";
      options = [
        "defaults"
        # デバイスが見つからなくても起動失敗にしない。
        "nofail"
        # 起動直後ではなく初回アクセス時に自動マウントする。
        "x-systemd.automount"
        # ブロックデバイスの出現待ち時間を制限する。
        "x-systemd.device-timeout=10"
      ];
    };

    systemd.slices = {
      # kazuki のログインセッション・systemd --user サービス全体のメモリー使用量に上限を設ける。
      "user-${toString config.users.users.kazuki.uid}".sliceConfig = {
        # 超えると最もメモリを食っているプロセスが OOM-Killer で強制終了
        MemoryMax = "8G";
        # 超えると OS が積極的にスワップさせたり低速化させて抑制
        MemoryHigh = "6G";
      };
      "user-${toString config.users.users.rescue.uid}".sliceConfig = {
        # これだけは確保するよう他のプロセスから回収するよう依頼
        MemoryMin = "256M";
      };
    };
  };
}
