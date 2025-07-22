{pkgs, ...}: {

  home.packages = with pkgs; [
    git-crypt #TODO: Replace this with sops
    gitui
    lazygit
  ];

  programs.git = {
    enable = true;
    delta.enable = true;
    userEmail = "pietersp@gmail.com";
    userName = "Pieter Prinsloo";
    ignores = [".direnv" "result"];
  };
}
