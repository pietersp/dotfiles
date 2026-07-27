{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.lazygit];

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
      commit.gpgSign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers_git";
      init.defaultBranch = "master";
      user = {
        email = "pietersp@gmail.com";
        name = "Pieter Prinsloo";
        signingKey = "${config.home.homeDirectory}/.ssh/github.pub";
      };
    };
    ignores = [".direnv" "result"];
  };
}
