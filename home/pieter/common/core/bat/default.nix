{pkgs, ...}: let
  theme = pkgs.catppuccin.override {
    variant = "mocha";
    themeList = ["bat"];
  };
in {
  programs.bat = {
    enable = true;
    themes = {
      catppuccin = {
        src = "${theme}/bat/";
        file = "Catppuccin Mocha.tmTheme";
      };
    };
    config.theme = "catppuccin";
  };
}
