{ pkgs, agenix, ... }:

with pkgs; [

  #passff-host # for firefox

  ruby
  rubyPackages.pry   
  #rubyPackages.parallel
  #rubyPackages.meni_magick
 
  ##sshfs
  chromium
  xauth
  impala
  #agenix.packages.${system}.default
  agenix.packages.${stdenv.hostPlatform.system}.default
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
  vpnc # for Santos Dumont
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
  #firefox 
  alacritty
  waybar
  eog
  pavucontrol
  awww
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

