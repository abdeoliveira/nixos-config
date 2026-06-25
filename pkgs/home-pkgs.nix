{ pkgs, my-scripts, ... }:

with pkgs; [
  # Custom packages
  gtk3-nocsd
  vesta
  #qtgrace
  grace
  packmol
  my-scripts
  # lammps-interface
  # Other packages
  gh
]
