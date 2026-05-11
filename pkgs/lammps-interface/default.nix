# ~/.nixos-config/pkgs/lammps-interface/default.nix
{ pkgs ? import <nixpkgs> {} }:
with pkgs;
python3Packages.buildPythonPackage rec {
  pname = "lammps-interface";
  version = "0.2.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "peteboyd";
    repo = "lammps_interface";
    rev = "0d7b397b2460ffd35718141f3089411e8fec6cae";
    hash = "sha256-fy3At4fyr9ozsdjh0zTWE5FL1qSOFuzIfPLAPAqMlQQ=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    numpy
    scipy
    networkx
    ase
    versioneer
  ];

  doCheck = false;

  meta = with lib; {
    description = "Automatic generation of LAMMPS input files for MD simulations of MOFs";
    homepage = "https://github.com/peteboyd/lammps_interface";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
