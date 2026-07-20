# host-specific.nix
{ config, lib, pkgs, ... }:

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
  fileSystems."/".device =
    lib.mkForce "/dev/mapper/luks-c4ba288d-57fd-4617-a1b3-065056227cbc";

  # --- Fingerprint Sensor (Broadcom 0a5c:5843) ---
  #services.fprintd.enable = true;
  #services.fprintd.tod.enable = true;
  #services.fprintd.tod.driver = pkgs.libfprint-2-tod1-broadcom;
}
