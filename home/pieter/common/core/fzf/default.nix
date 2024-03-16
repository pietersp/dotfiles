{pkgs, ...}: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    colors = {
      hl = "#c678dd";
      "fg+" = "#ffffff";
      "bg+" = "#4b5263";
      "hl+" = "#d858fe";
      info = "#98c379";
      prompt = "#61afef";
      pointer = "#be5046";
      marker = "#e5c07b";
      spinner = "#61afef";
      header = "#61afef";
    };
    changeDirWidgetCommand = "fd --type d . --color=never --hidden";
    changeDirWidgetOptions = ["--preview 'tree -C {} | head -50'"];
  };
}
