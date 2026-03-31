# host-specific.nix
{ config, pkgs, ... }:

{
  # Hostname (system-level)
  networking.hostName = "nixos";

  # Keyboard layout
  console.keyMap = "br-abnt2";
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # --- Bootloader ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  # --- Fingerprint Sensor (Broadcom 0a5c:5843) ---
  #services.fprintd.enable = true;
  #services.fprintd.tod.enable = true;
  #services.fprintd.tod.driver = pkgs.libfprint-2-tod1-broadcom;
}
