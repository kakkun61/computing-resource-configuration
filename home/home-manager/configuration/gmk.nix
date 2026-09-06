{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [ ];

  config = {
    home = {
      packages = with pkgs; [
        btop
        kubernetes-helm
        vscode-cli
      ];
      sessionPath = [
        "$HOME/.local/bin"
      ];
    };
  };
}
