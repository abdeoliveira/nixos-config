{ pkgs, my-scripts, ... }:

with pkgs; [
  # Custom packages
  gtk3-nocsd
  #vesta
  qtgrace
  my-scripts

  # Standard packages
  vesta-viewer
  gcalcli
  transmission_4-gtk
  mplayer
  libreoffice
  unzip
  jmol
  inkscape
  xsane
  xournalpp
  yt-dlp
  bc
  speedtest-cli
  lyx
  gedit
  simple-scan
  brscan4
  wlr-randr
  lammps-mpi
  ovito
  gh
  libnotify
  #firefox # currently managed in home.nix
  alacritty
  waybar
  eog
  pavucontrol
  swww
  gammastep
  syncthing
  restic
  rclone
  pass-nodmenu
  bemenu
  fastfetch
  xwayland-satellite
  poppler-utils # pdf utilities
  pinentry-curses
]
