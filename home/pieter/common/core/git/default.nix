{pkgs, ...}: {

  xdg.configFile.delta = {
    source = ./config/delta;
    recursive = true;
  };

  xdg.configFile.gitui = {
    source = ./config/gitui;
    recursive = true;
  };

  home.packages = with pkgs; [ 
    git-crypt
    gitui
    lazygit
  ];
     
  programs.git = {
    enable = true;
    delta.enable = true;
    userEmail = "pietersp@gmail.com";
    userName = "Pieter Prinsloo";
    extraConfig = {
      include.path = "~/.config/delta/themes.gitconfig";
      delta.features = "catppuccin";
    };
    ignores = [ ".direnv" "result" ];
  };
}
