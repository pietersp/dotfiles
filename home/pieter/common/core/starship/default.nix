{pkgs, ...}: {
  # starship prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    settings = {
      scala.disabled = true;
      container.disabled = true;
      custom.devenv_profile = {
        when = ''test -n "$DEVENV_ACTIVE_PROFILES"'';
        command = ''printf "%s" "$DEVENV_ACTIVE_PROFILES"'';
        format = ''[devenv:$output]($style) '';
        style = "bold peach";
      };
    };
  };
}
