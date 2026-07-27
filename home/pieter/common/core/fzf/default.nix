{pkgs, ...}: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    changeDirWidget = {
      command = "fd --type d . --color=never --hidden";
      options = ["--preview 'tree -C {} | head -50'"];
    };
  };
}
