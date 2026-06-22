# pkgs/grace/default.nix
{ lib
, stdenv
, fetchurl
, motif
, netcdf
, fftw
, libpng
, zlib
, libX11
, libXt
, libXmu
, libXpm
, libXext
, libtirpc
, patchutils
}:

stdenv.mkDerivation rec {
  pname = "grace";
  version = "5.1.25";

  src = fetchurl {
    url = "https://plasma-gate.weizmann.ac.il/pub/grace/src/stable/grace-${version}.tar.gz";
    sha512 = "9ea68483af1dfc98d217ae730b7a51b66deae5aaa8dfda29d5a3337ed4b5728b45aa03f561bf7d4173e73d6af8dee03cbabd95c0c8dd36999303c89451a3728a";
  };

  # Debian patches (mirrored on GitHub or you can vendor them)
  patches = [
    ./gracerc.diff
    ./tmpnam_to_mkstemp.diff
    ./fftw3.diff
    ./netcdf-build-fix.diff
    ./netbook_small_screen_2.diff
    ./non-resizable-dialogs.diff
    ./nonlinear_extended.diff
    ./source-hardening.diff
    ./grconvert-tirpc.diff
    ./configure-implicit-declarations.diff
  ];

  postPatch = ''
    sed -i '1,1i#include <zlib.h>' src/rstdrv.c
    sed -i 's|png_ptr->jmpbuf|png_jmpbuf(png_ptr)|g' src/rstdrv.c
  '';

  nativeBuildInputs = [ ];

  buildInputs = [
    motif
    netcdf
    fftw
    libpng
    zlib
    libX11
    libXt
    libXmu
    libXpm
    libXext
    libtirpc
  ];

env.NIX_CFLAGS_COMPILE = lib.concatStringsSep " " [
  "-Wno-implicit-int"
  "-Wno-old-style-definition"
  "-Wno-implicit-function-declaration"
  "-Wno-int-conversion"
  "-Wno-format-security"
  "-Wno-array-bounds"
  "-D_XOPEN_SOURCE"
  "-std=c17"
  "-I${lib.getDev libtirpc}/include/tirpc"
];

configureFlags = [
  "--enable-grace-home=${placeholder "out"}/share/grace"
  "--with-helpviewer=xdg-open"
];

  # Grace installs bin/lib/include under $prefix/share/grace;
  # replicate the Arch PKGBUILD relocation

postInstall = ''
  mkdir -p $out/bin
  for exe in $out/share/grace/bin/*; do
    ln -s "$exe" $out/bin/
  done
'';

  meta = with lib; {
    description = "WYSIWYG 2D plotting tool (xmgrace / Grace)";
    homepage    = "http://plasma-gate.weizmann.ac.il/Grace/";
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux;
    mainProgram = "xmgrace";
  };
}
