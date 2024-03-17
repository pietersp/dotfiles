{pkgs, ...}: {
  # Needed for fzf-pipe content rendering
  programs.lesspipe.enable = true;

  home.file = {
    ".lessfilter".source = ./config/.lessfilter;
  };
}
