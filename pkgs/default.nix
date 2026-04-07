# Custom Packages
#
# Define your own packages here. These will be available in all systems
# through the flake's packages output (e.g., .#packages.x86_64-linux.my-package)
#
# Args:
#   pkgs: The nixpkgs package set for the current system
#
# Package vs Derivation:
#   - pkgs.stdenv.mkDerivation: Simple builds (single source, make/cmake)
#   - pkgs.buildGoModule: Go applications
#   - pkgs.buildPythonApplication: Python apps (use pyproject.toml/setup.py)
#   - pkgs.callPackage: For packages with dependencies
#
# Simple derivation example:
#   my-hello = pkgs.stdenv.mkDerivation {
#     pname = "my-hello";
#     version = "1.0";
#     src = pkgs.fetchFromGitHub {
#       owner = "hello";
#       repo = "hello";
#       rev = "v2.12";
#       sha256 = "sha256-...";
#     };
#     meta = with pkgs.lib; {
#       description = "My custom hello";
#       homepage = "https://example.com";
#     };
#   };
#
# Using callPackage (for packages with dependencies):
#   # Create a default.nix in this directory:
#   # { lib, fetchFromGitHub }:
#   # pkgs.stdenv.mkDerivation { ... }
#   #
#   # Then reference it here:
#   cd-gitroot = pkgs.callPackage ./cd-gitroot { };
#
# Using fetchurl (for downloading single files):
#   my-script = pkgs.stdenv.mkDerivation {
#     pname = "my-script";
#     version = "0.1";
#     src = pkgs.fetchurl {
#       url = "https://example.com/script.sh";
#       sha256 = "sha256-...";
#     };
#     unpackPhase = "true";
#     installPhase = ''
#       mkdir -p $out/bin
#       cp script.sh $out/bin/my-script
#       chmod +x $out/bin/my-script
#     '';
#   };
{pkgs}: rec {
  # Define custom packages here
  # Example:
  # my-package = pkgs.stdenv.mkDerivation { ... };
  # cd-gitroot = pkgs.callPackage ./cd-gitroot { };

  metals-mcp = pkgs.callPackage ./metals-mcp {
    jre = pkgs.jre;
    metals = pkgs.metals;
  };

  gemini-cli = pkgs.callPackage ./gemini-cli { };

  codex-cli = pkgs.callPackage ./codex-cli { };

  check-cli-versions = pkgs.writeScriptBin "check-cli-versions" ''
    #!/usr/bin/env bash

    tools=(
      "opencode-ai"
      "@google/gemini-cli"
      "@openai/codex"
    )
    cmds=(
      "opencode"
      "gemini"
      "codex"
    )

    for i in "''${!tools[@]}"; do
      pkg="''${tools[$i]}"
      cmd="''${cmds[$i]}"
      latest=$(npm view "$pkg" version 2>/dev/null)

      if raw=$("$cmd" --version 2>/dev/null); then
        installed=$(echo "''${raw}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | tail -1)
        if [[ "$installed" == "$latest" ]]; then
          echo "''${cmd}: ''${installed} (latest)"
        else
          echo "''${cmd}: ''${installed} -> ''${latest} [update available]"
        fi
      else
        echo "''${cmd}: n/a -> ''${latest} [not installed]"
      fi
    done
  '';
}
