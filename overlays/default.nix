# Nix Overlays
#
# Overlays allow you to modify packages from nixpkgs. They are composed in order:
#   additions -> modifications
#
# Structure:
#   - additions: Add your own packages (from ./pkgs directory)
#   - modifications: Override or patch existing packages
#
# Args:
#   inputs: The flake inputs (for accessing other flakes' overlays)
#   final: The final package set (after all overlays applied)
#   prev: The package set before this overlay
#
# Example modifications:
#
# Override a package version:
#   mypackage = prev.mypackage.override { version = "1.2.3"; };
#
# Use overrideAttrs to change build flags/patches:
#   hello = prev.hello.overrideAttrs (oldAttrs: {
#     patches = [ ./my-fix.patch ];
#     NIX_CFLAGS = "-O3";
#   });
#
# Completely replace a package:
#   firefox = prev.firefox.overrideAttrs (oldAttrs: {
#     pname = "firefox-custom";
#     version = "99.0";
#     src = fetchurl { ... };
#   });
#
# Add a package from another flake:
#   my-flake-package = inputs.my-flake.packages.${final.system}.default;
#
# Access the unstable nixpkgs:
#   unstable = import inputs.nixpkgs-unstable { system = final.system; };
{inputs}: {
  additions = final: _prev: import ../pkgs {pkgs = final;};

  modifications = final: prev: {
    direnv = prev.direnv.overrideAttrs (old: {
      buildPhase = ''
        sed -i 's/-linkmode=external/-linkmode=internal/g' GNUmakefile
        make BASH_PATH=${prev.bash}/bin/bash
      '';
      dontCheck = true;
    });
  };
}
