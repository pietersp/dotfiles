{pkgs, ...}: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    changeDirWidgetCommand = "fd --type d . --color=never --hidden";
    changeDirWidgetOptions = ["--preview 'tree -C {} | head -50'"];
  };
}
