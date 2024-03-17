{pkgs, ...}: {
  xdg.configFile.yazi = {
    source = ./config/yazi;
    recursive = true;
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };
}
