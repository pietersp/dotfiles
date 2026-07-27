{
  pkgs,
  outputs,
  ...
}: {
  imports = [
    common/core
  ];

  home.packages = with pkgs; [
    outputs.packages.${pkgs.stdenv.hostPlatform.system}.check-cli-versions
  ];
}
