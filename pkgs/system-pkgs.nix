{ pkgs, agenix, ... }:

with pkgs; [
  # --- System Packages ---

  # For firefox
    passff-host

  # Ruby
  ruby
  rubyPackages.pry   
  #rubyPackages.parallel
  #rubyPackages.mini_magick

  # Other apps
  agenix.packages.${system}.default
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
]

