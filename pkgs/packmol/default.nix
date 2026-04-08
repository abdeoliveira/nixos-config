# /etc/nixos/pkgs/packmol/default.nix
{ pkgs ? import <nixpkgs> {} }:

with pkgs;

stdenv.mkDerivation rec {
  pname = "packmol";
  version = "20.15.0";

  src = fetchFromGitHub {
    owner = "m3g";
    repo = "packmol";
    rev = "v${version}";
    sha256 = "0hk8x171bscj3f34fg4lll8in306d4abqzj0nsxs6d3fxmam1mab";
  };

  # Added 'which' here so the script can use it
  nativeBuildInputs = [ 
    gfortran 
    which 
  ];

  configurePhase = ''
    runHook preConfigure
    patchShebangs configure
    
    # We tell configure exactly where gfortran is located in the Nix store.
    # $(type -p gfortran) resolves to the full /nix/store/... path.
    ./configure $(type -p gfortran)
    
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    make
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp packmol $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Initial configurations for Molecular Dynamics";
    homepage = "https://github.com/m3g/packmol";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
