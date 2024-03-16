# When in this directory you can run the script with
# nix-shell example.nix --command example-script
with import <nixpkgs> {};

let 
  exampleScript = pkgs.writeShellScriptBin "example-script" ''
    echo "hello world" | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat
  '';
in 
stdenv.mkDerivation {
  name = "example-script";

  buildInputs = [ exampleScript ];
}
