
# pkgs/gtk3-nocsd/default.nix

{ stdenv, fetchFromGitHub, pkg-config, gtk3, gobject-introspection }:

stdenv.mkDerivation {
  pname = "gtk3-nocsd";
  version = "3.0.8";

  src = fetchFromGitHub {
    owner = "ZaWertun";
    repo = "gtk3-nocsd";
    rev = "v3.0.8";
    hash = "sha256-BOsQqxaVdC5O6EnB3KZinKSj0U5mCcX8HSjRmSBUFks=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gtk3
    gobject-introspection
  ];

  # This manual installPhase bypasses the system's broken "make install"
  installPhase = ''
    runHook preInstall

    # Manually create the directories
    mkdir -p $out/bin
    mkdir -p $out/lib

    # Manually install the files with correct permissions
    install -m 755 gtk3-nocsd $out/bin/
    install -m 644 libgtk3-nocsd.so.0 $out/lib/

    runHook postInstall
  '';
}
