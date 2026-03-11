{pkgs, ...}: {
  default = pkgs.mkShell {
    packages = [
      pkgs.alejandra
    ];
  };
}
