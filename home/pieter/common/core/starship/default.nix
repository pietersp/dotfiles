{pkgs, ...}: {
  # starship prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    settings = {
      scala.disabled = true;
      container.disabled = true;
    };
  };
}
