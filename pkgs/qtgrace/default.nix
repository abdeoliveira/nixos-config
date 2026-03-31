# /etc/nixos/pkgs/qtgrace/default.nix
{ lib, stdenv, fetchFromGitHub, cmake, qt6, fftw, libharu }:

stdenv.mkDerivation rec {
  pname = "qtgrace";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "yesint";
    repo = "QtGrace6";
    rev = "v0.27";
    hash = "sha256-sf3NFRUmgS4nn3Ht0Axvq0q5j0sNwha/nt/mBUgXD68=";
  };

  nativeBuildInputs = [ cmake qt6.wrapQtAppsHook ];

  buildInputs = [ qt6.qtbase qt6.qtsvg qt6.qt5compat fftw libharu ];


  installPhase = ''
  runHook preInstall
  install -D -m755 qtgrace $out/share/qtgrace/bin/qtgrace
  mkdir -p $out/bin
  ln -s $out/share/qtgrace/bin/qtgrace $out/bin/qtgrace
  install -d -m755 $out/share/qtgrace
  cp ../gracerc $out/share/qtgrace/gracerc
  cp ../gracerc.user $out/share/qtgrace/gracerc.user
  cp -r ../fonts $out/share/qtgrace
  cp -r ../examples $out/share/qtgrace
  cp -r ../templates $out/share/qtgrace
  cp -r ../doc $out/share/qtgrace
  runHook postInstall
'';

  meta = with lib; {
    description = "A Qt version of the Grace 2D plotting tool";
    homepage = "https://github.com/yesint/QtGrace6";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
