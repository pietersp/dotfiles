{pkgs, ...}: let
  lunarvim = pkgs.lunarvim.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "LunarVim";
      repo = "LunarVim";
      rev = "9ee3b7b8846d7ed2fa79f03d67083f8b95c897f2";
      sha256 = "sha256-grCEaLJrcPMdM9ODWSExcNsc+G+QmEmZ7EBfBeEVeGU=";
    };
    patches = [];
  });
in {
  home.packages = [
    lunarvim
  ];

  xdg.configFile.lvim = {
    source = ./config;
    recursive = true;
  };

  #  home.sessionVariables = {EDITOR = "lvim";};
}
