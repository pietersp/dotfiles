{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    git-crypt #TODO: Replace this with sops
    # gitui
    lazygit
  ];

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      # Catppuccin's delta theme uses true-color hex values; force 24-bit
      # output even when COLORTERM is not set (otherwise delta falls back to
      # muddy 256-color approximations).
      true-color = "always";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers_git";
      user = {
        email = "pietersp@gmail.com";
        name = "Pieter Prinsloo";
      };
    };
    ignores = [".direnv" "result"];
  };
}
