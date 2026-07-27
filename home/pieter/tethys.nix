{
  outputs,
  pkgs,
  ...
}: {
  imports = [
    ./common/core
    ./common/optional/wezterm
  ];

  home.packages = with pkgs; [
    # Avoid mpv-with-scripts here because yt-dlp now pulls in deno.
    mpv-unwrapped
    python3
    outputs.packages.${pkgs.stdenv.hostPlatform.system}.check-cli-versions
  ];

  languages.scala.enable = true;

  # The tldr cache updater is a background service and must also work when
  # Home Manager is activated without an active Aqua session (for example,
  # over SSH).
  launchd.agents.tldr-update.domain = "user";
  launchd.agents.home-manager-auto-expire.domain = "user";

  # Home Manager's generated option docs currently embed a Nixpkgs source path
  # without store context, which makes its options.json derivation unreliable.
  manual.manpages.enable = false;

  # The auto-expire LaunchAgent writes its logs below this directory.
  home.file."Library/Logs/home-manager-auto-expire/.keep".text = "";
}
