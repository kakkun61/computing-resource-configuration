# My Nix OS Configurations

## 使い方 / Usage

セットアップ対象のマシンのマシン名がまだ設定されていなかったら設定する。/ If the machine name of the target machine is not set yet, set it.

```nix
# /etc/nixos/configuration.nix
…
  networking.hostName = "my-machine-name";
…
```

反映させる。/ Apply the changes.

```console
# nixos-rebuild switch
```

別マシンで、このリポジトリーに `my-machine-name` 用の設定を追加する。

- セットアップ対象のマシンの _/etc/nixos/configuration.nix_ を元に _configuration/my-machine-name.nix_ を作成する。/ Create _configuration/my-machine-name.nix_ based on _/etc/nixos/configuration.nix_ of the target machine.
- _flake-module.nix_ の `nixosConfigurations` に `my-machine-name` を追加する。/ Add `my-machine-name` to `nixosConfigurations` in _flake-module.nix_.

```nix
…
  nixosConfigurations = {
    …
    "my-machine-name" = nixpkgs.lib.nixosSystem {
      system = …;
      modules = [
        ./hardware-configuration.nix
        nixosModules.common
        ./configuration/my-machine-name.nix
        { system.stateVersion = …; }
      ];
      …
    };
  };
…
```

```console
$ nix fmt
$ git add .
$ git commit -m "Add configuration for my-machine-name"
$ git push
```

セットアップ対象のマシンで秘密情報を取得する。/ Get secret information on the target machine.

```console
# gh auth login
# cd /root
# gh repo clone kakkun61/secret
```

セットアップ対象のマシンで設定を適用する。/ Apply the configuration on the target machine.

```console
# nix-shell -p git gh
# mv /etc/nixos{,.back}
# cd /etc
# gh repo clone kakkun61/nixos-configuration nixos
# cp --force /etc/nixos{.back,}/hardware-configuration.nix
# cd /etc/nixos
# nix --extra-experimental-features 'nix-command flakes' flake update
# nixos-rebuild switch --flake .
```

[home-manager の設定はこっち](https://github.com/kakkun61/dot_files) / [Home-manager configuration is here](https://github.com/kakkun61/dot_files)
