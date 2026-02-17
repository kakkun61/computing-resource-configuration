# Tailscale を有効にしてそのホストで Kubernetes（K3s）ホストを立てると
# Kubernetes クラスターの中の Core DNS がホストの systemd-resolved を見に行くようになり
# Tailnet の 100.100.100.100 を DNS サーバーとして使用してしまうため
# 名前解決ができなくなるという問題がある
# 解決策として K3s で --resolv-conf オプションを指定して LAN のネームサーバーを指定する
# ./kubernetes.nix を参照
{ lib, ... }:
{
  services = {
    tailscale = {
      enable = true;
      authKeyFile = "/home/kazuki/.config/tailscale/auth.key";
    };
    # > Linuxディストリビューションのメンテナーの皆様は、ユーザーにどのような設定を強制すべきかお悩みかもしれません。
    # > 当社の見解では、systemd-resolvedを使用し、ユーザーフレンドリーなネットワーク設定が必要な場合は、
    # > 最新バージョンのNetworkManager（1.26.6以降）を採用することをお勧めします。
    # https://tailscale.com/blog/sisyphean-dns-client-linux
    resolved.enable = lib.mkDefault true;
  };
}
