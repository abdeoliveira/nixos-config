# /etc/nixos/pkgs/vesta/default.nix
{ pkgs ? import <nixpkgs> {} }:
with pkgs;
stdenv.mkDerivation rec {
  pname = "vesta";
  version = "3.5.8";
  src = fetchurl {
    url = "https://jp-minerals.org/vesta/archives/${version}/VESTA-gtk3.tar.bz2";
    hash = "sha256-eL7wJcKzHx1kycfgatKxOdJSs6aGiT7nmsdLMCGGjfg=";
  };
  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];
  buildInputs = [
    gtk3
    gtk2
    libGLU
    xorg.libXtst
    xorg.libXxf86vm
    #jdk
    openjdk
  ];
  
  # Add runtime dependencies to help autoPatchelfHook
  runtimeDependencies = [
    jdk
  ];
  
  # Option 1: Try to fix the library path
  postFixup = ''
    # Help autoPatchelfHook find libjawt.so
    for f in $out/opt/VESTA/PowderPlot/*.so; do
      if [[ -f "$f" ]]; then
        # Add JDK lib directory to RPATH
        patchelf --add-rpath ${jdk}/lib $f 2>/dev/null || true
        patchelf --add-rpath ${jdk}/lib/server $f 2>/dev/null || true
      fi
    done
  '';

  # Option 2: Uncomment this if Option 1 doesn't work
  # autoPatchelfIgnoreMissingDeps = [ "libjawt.so" ];
  
  installPhase = ''
    runHook preInstall
    # The PKGBUILD installs to /opt/VESTA. We'll replicate this inside the Nix store path.
    mkdir -p $out/opt
    cp -a . $out/opt/VESTA
    # Make the main binary executable
    chmod +x $out/opt/VESTA/VESTA
    # Create a symlink in $out/bin so you can run `VESTA` from the command line.
    makeWrapper $out/opt/VESTA/VESTA $out/bin/VESTA
    # Install the license file
    install -Dm644 $out/opt/VESTA/LICENSE $out/share/licenses/${pname}/LICENSE
    runHook postInstall
  '';
  
  meta = with lib; {
    description = "Visualization for Electronic and STructural Analysis";
    homepage = "https://jp-minerals.org/vesta";
    license = licenses.unfree;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
