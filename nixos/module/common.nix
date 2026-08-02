{ pkgs, ... }:
{
  config = {
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };

    nixpkgs.config.allowUnfree = true;

    time.timeZone = "Asia/Tokyo";
    i18n.defaultLocale = "ja_JP.UTF-8";

    programs.nix-ld.enable = true;

    users = {
      defaultUserShell = pkgs.bashInteractive;

      users =
        let
          authorizedKeys = [
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDKFQWOqFI7MX3rdZ6hNibGYDnZvBveyVEpeyiVNbWHfn+EWlDHSgOYNc8MCRaxYU+c89v6usZAGe7XDDj4QSEKwaNhFiCf30Jq5iihc9urc0K+fmwOSwDPgI5Hbr6BLqc3xdxhYzj2unzzcna9+1G32GX9SHz9nkSAgUV63wjSOx5hiQ2pDhk9xI/L63OjC0PVNw95wl1AA/+DZdmTpjcM+2V2Wx5ZL9LIM5lU5rXqHZ7RmOdSrjvB3aU+ju0XqfqR6Ixt10D+/8y5bn4/Pyz44PhPHC/dsI/y6Q7IEX8H0eCchmXtM2pH1LRNW1W52NkucmyJGwBrqHJLvdgMpPCU/32IR1OLNnoFodLkATgbSSONOQiGO8i07mwuSd2zQ7PUM1Qg98J3VR8YW8IJVQF4QJoBD0qREyIi4STe3r/Z8HJFBJsF+lSGgwBCUTUKEptMYQLAerk9uUbcmGM6ERhzAFZuPhTl/xEq4yK4+wTsf++87QkgWgaPHF16OUw2+Vjc45OzzfdjOuE09N38zk8GJCjV6NBpHgK9srvepccurC5jlcmUwGmdIq21OItHK6JCw18LG6T0pB5n/yiA+aV8ZJCoJkdS/p5+QMLmKiX15sAmyuSlLPgDAG6flhT2ppamZSbQDsC22fVaBH12dRIR+coaD1BbCKTlJYzyIz/8yw== kazuki@Maihama"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIBpABK89ipLIn55ewoUsfufAwagz5k3C+WSdpQvgfMG JuiceSSH"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKnIZjps96Vpmy8+pTrVd66RQ42j8824yn46VNDi8Z0T kazuki@surface"
          ];
        in {
          kazuki = {
            group = "wheel";
            # This automatically sets group to users, createHome to true, home to /home/«username», useDefaultShell to true, and isSystemUser to false.
            isNormalUser = true;
            openssh.authorizedKeys.keys = authorizedKeys;
            packages = with pkgs; [ home-manager ];
            uid = 1000; # デフォルトは null で 1000 から順番に採番されるらしい
            useDefaultShell = true;
          };
          rescue = {
            # kazuki でメモリーリークしたときなどに処理をするため
            # systemd の設定はそれぞれのマシンごとでやる
            group = "wheel";
            isNormalUser = true;
            openssh.authorizedKeys.keys = authorizedKeys;
            uid = 1001;
            useDefaultShell = true;
          };
        };
    };

    security.sudo.extraRules = [
      {
        users = [ "kazuki" ];
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}
