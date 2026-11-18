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
        wd
      ];
      sessionPath = [
        "$HOME/.local/bin"
      ];
      sessionVariables = {
        KUBECONFIG = "$HOME/.kube/config";
      };
    };
  };
}
