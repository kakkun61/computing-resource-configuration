{ root }:
{ pkgs, lib, ... }:
{
  home = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    packages = [ pkgs.macskk ];
    file."Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Settings/kana-rule.conf" = {
      enable = pkgs.stdenv.hostPlatform.isDarwin;
      source = root + /mac-skk/kana-rule.conf;
    };
  };
}
