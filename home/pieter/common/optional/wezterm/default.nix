{pkgs, ...}: {

  # TODO: Investigate using programs.wezterm rather
  home.packages = [ pkgs.wezterm ];
  
  xdg.configFile.wezterm = {
    source = ./config/wezterm;
    recursive = true;
  };
}
