{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
  metals,
}:
stdenv.mkDerivation rec {
  pname = "metals-mcp";
  version = "1.6.6";

  src = fetchurl {
    url = "https://repo1.maven.org/maven2/org/scalameta/metals-mcp_2.13/${version}/metals-mcp_2.13-${version}.jar";
    sha256 = "sha256-Pu78514iSJysTjKoEYwnEJcKTVcjSDikzRb8GfgAAy8=";
  };

  nativeBuildInputs = [makeWrapper];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    
    # Collect all jars from metals-deps
    CLASSPATH="${src}:$(find ${metals.deps}/share/java/ -name "*.jar" | tr '\n' ':')"

    makeWrapper ${jre}/bin/java $out/bin/metals-mcp \
      --add-flags "-XX:+UseG1GC" \
      --add-flags "-XX:+UseStringDeduplication" \
      --add-flags "-Xss4m" \
      --add-flags "-Xms100m" \
      --add-flags "-cp $CLASSPATH" \
      --add-flags "scala.meta.metals.McpMain"
  '';

  meta = with lib; {
    description = "Model Context Protocol (MCP) server for Scala via Metals";
    homepage = "https://scalameta.org/metals/docs/editors/mcp";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
