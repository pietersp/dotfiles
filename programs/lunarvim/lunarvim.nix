{pkgs, ...}: let
  lunarvim = pkgs.lunarvim.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "LunarVim";
      repo = "LunarVim";
      rev = "b124e8c3e3f8145029c0d9aeb3912e5ac314e0a2";
      sha256 = "J2E4BQfyrZ9HvuDDCLFm6wj8S9QQ2lEo9PwsJkjcbuY=";
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

  home.sessionVariables = {EDITOR = "lvim";};
}
