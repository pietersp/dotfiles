{
  config,
  lib,
  pkgs,
  ...
}: {
  options.languages.scala.enable = lib.mkEnableOption "Scala development tooling";

  config = lib.mkIf config.languages.scala.enable {
    home.packages = with pkgs; [
      sbt
      scala-cli
      metals
      scala_3
    ];
  };
}
