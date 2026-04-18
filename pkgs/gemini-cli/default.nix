{ pkgs, lib }:

pkgs.stdenvNoCC.mkDerivation rec {
  pname = "gemini-cli";
  version = "0.38.2";

  src = pkgs.fetchurl {
    url = "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-${version}.tgz";
    hash = "sha256-mwx1LP6TdTcOGBLzev/9lzh7md9x5kzqU+WIol9NaIw=";
  };

  nativeBuildInputs = with pkgs; [
    makeWrapper
  ];

  unpackPhase = ''
    tar xf $src
  '';

  installPhase = ''
    runHook preInstall
    
    # Install to unique subdirectory to avoid conflicts
    mkdir -p $out/lib/gemini-cli
    cp -r package/* $out/lib/gemini-cli/
    
    # Create the binary wrapper pointing to the bundled gemini.js
    mkdir -p $out/bin
    makeWrapper ${pkgs.nodejs}/bin/node $out/bin/gemini \
      --add-flags "$out/lib/gemini-cli/bundle/gemini.js"
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "Gemini CLI - AI-powered coding assistant from Google";
    homepage = "https://github.com/google-gemini/gemini-cli";
    license = licenses.asl20;
    maintainers = [];
  };
}
