{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}: {
  imports = [
    # Required configs
    common/core #required
    "${fetchTarball {
      url = "https://github.com/msteen/nixos-vscode-server/tarball/master";
      sha256="1mrc6a1qjixaqkv1zqphgnjjcz9jpsdfs1vq45l1pszs9lbiqfvd";
      }
    }/modules/vscode-server/home.nix"
    # Host specific optional configs
    # common/optional/wezterm
  ];
  services.vscode-server.enable = true;
}
