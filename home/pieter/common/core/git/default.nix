{pkgs, ...}: {

  home.packages = with pkgs; [
    git-crypt #TODO: Replace this with sops
    # gitui
    lazygit
  ];

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.git = {
    enable = true;
    settings.user = {
      email = "pietersp@gmail.com";
      name = "Pieter Prinsloo";
    };
    ignores = [".direnv" "result"];
  };
}
