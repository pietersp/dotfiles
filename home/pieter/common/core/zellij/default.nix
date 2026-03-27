{config, ...}: {
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;  # handled by zsh module
    settings = {
      default_mode = "locked";
      show_startup_tips = false;
    };
    extraConfig = builtins.readFile ./config.kdl;
  };
}
