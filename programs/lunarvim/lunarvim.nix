{ config, pkgs, ... }:
let
  lunarvim = pkgs.lunarvim.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "LunarVim";
      repo = "LunarVim";
      rev = "f74046d1911e430ca734d1ed1509d2ff3bdfe7e1";
      sha256 = "z1Cw3wGpFDmlrAIy7rrjlMtzcW7a6HWSjI+asEDcGPA=";
    };
  });
in {
  home.packages = [ pkgs.lunarvim ];

  xdg.configFile.lvim = {
    source = ./config;
    recursive = true;
  };

  home.sessionVariables = { EDITOR = "lvim"; };
}
