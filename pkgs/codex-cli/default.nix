{ pkgs, lib }:

let
  version = "0.118.0";
  
  # Platform-specific package mapping
  platformPkg = {
    "aarch64-darwin" = {
      name = "darwin-arm64";
      hash = "sha256-e8KYC7yqJ45NMv5yROMrMEgnw4UsUezaDgzY9ALzkUE=";
    };
    "x86_64-darwin" = {
      name = "darwin-x64";
      hash = lib.fakeHash;
    };
    "aarch64-linux" = {
      name = "linux-arm64";
      hash = lib.fakeHash;
    };
    "x86_64-linux" = {
      name = "linux-x64";
      hash = lib.fakeHash;
    };
  }.${pkgs.stdenv.hostPlatform.system} or (throw "Unsupported system: ${pkgs.stdenv.hostPlatform.system}");

  # Fetch the platform-specific binary package
  platformPackage = pkgs.fetchurl {
    url = "https://registry.npmjs.org/@openai/codex/-/codex-${version}-${platformPkg.name}.tgz";
    hash = platformPkg.hash;
  };
in

pkgs.stdenvNoCC.mkDerivation rec {
  pname = "codex-cli";
  inherit version;

  # Fetch the base package
  src = pkgs.fetchurl {
    url = "https://registry.npmjs.org/@openai/codex/-/codex-${version}.tgz";
    hash = "sha256-PTtFyMtcEml053ziQbXuPKrExgVv0HZMXzqif1i6y2g=";
  };

  nativeBuildInputs = with pkgs; [
    makeWrapper
  ];

  unpackPhase = ''
    # Extract base package
    tar xf $src
    
    # Extract platform-specific package
    mkdir -p platform_pkg
    tar xf ${platformPackage} -C platform_pkg
  '';

  installPhase = ''
    runHook preInstall
    
    # Install base package to unique subdirectory
    mkdir -p $out/lib/codex-cli
    cp -r package/* $out/lib/codex-cli/
    
    # Install platform-specific binary - it goes in node_modules/@openai/codex-
    mkdir -p $out/lib/codex-cli/node_modules/@openai
    cp -r platform_pkg/package $out/lib/codex-cli/node_modules/@openai/codex-${platformPkg.name}
    
    # Create the binary wrapper pointing to the bundled cli
    mkdir -p $out/bin
    makeWrapper ${pkgs.nodejs}/bin/node $out/bin/codex \
      --add-flags "$out/lib/codex-cli/bin/codex.js"
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "Codex CLI - OpenAI's coding assistant";
    homepage = "https://github.com/openai/codex";
    license = licenses.asl20;
    maintainers = [];
    platforms = [ "aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux" ];
  };
}
