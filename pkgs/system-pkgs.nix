{ pkgs, agenix, ... }:

with pkgs; [

  passff-host # for firefox

  ruby
  rubyPackages.pry   
  #rubyPackages.parallel
  #rubyPackages.mini_magick
 
  chromium
  xauth
  impala
  agenix.packages.${system}.default
  iw # to manage waybar/scripts/wifipower.rb only
  age
  python313
  fwupd
  imagemagick
  mpi
  evince
  texliveFull
  gfortran
  openvpn
  glib
  xdg-utils
  wget
  ddcutil
  git
  brightnessctl
  pamixer
  swaylock-effects
  swayidle
 #wl-clipboard-x11
  wl-clipboard
  openssl
  
  # --- Thunar ---
  #xfce.thunar
  #xfce.thunar-volman
  #xfce.thunar-archive-plugin
  #xfce.thunar-media-tags-plugin
  #xfce.tumbler
  #xfce.exo
  
  file-roller
  gvfs
  ffmpegthumbnailer
  trash-cli
  nautilus
  nautilus-python
  sushi
  #vesta-viewer # bugged
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
  libnotify
  #firefox # currently managed in home.nix
  alacritty
  waybar
  eog
  pavucontrol
  swww
  gammastep
  #syncthing
  restic
  rclone
  pass-nodmenu
  bemenu
  fastfetch
  xwayland-satellite
  poppler-utils # pdf utilities
  pinentry-curses
]

