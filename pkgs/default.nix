{pkgs}: {
  check-cli-versions = pkgs.writeScriptBin "check-cli-versions" ''
    #!/usr/bin/env bash

    tools=(
      "opencode-ai"
      "@openai/codex"
    )
    cmds=(
      "opencode"
      "codex"
    )

    for i in "''${!tools[@]}"; do
      pkg="''${tools[$i]}"
      cmd="''${cmds[$i]}"
      latest=$(npm view "$pkg" version 2>/dev/null)

      if raw=$("$cmd" --version 2>/dev/null); then
        installed=$(echo "''${raw}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | tail -1)
        if [[ "$installed" == "$latest" ]]; then
          echo "''${cmd}: ''${installed} (latest)"
        else
          echo "''${cmd}: ''${installed} -> ''${latest} [update available]"
        fi
      else
        echo "''${cmd}: n/a -> ''${latest} [not installed]"
      fi
    done
  '';
}
