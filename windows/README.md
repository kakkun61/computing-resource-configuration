# Windows 向けの設定

## Winget

各ディレクトリーの _winget_ ファイルにパッケージ ID が記載されている。

```console
$ winget-install.ps1
```

## Syncthing

ローカルでのファイル同期。

`git submodule update --init` しておく。

_Syncthing.xml_ を `taskschd.msc` にインポートする。_D:\computing-resource-configuration_ にこのリポジトリーがクローンされている前提になっている。
