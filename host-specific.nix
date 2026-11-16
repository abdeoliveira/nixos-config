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

    # --- Battery (Dell Latitude 5400): Custom mode, charge 75→80% ---
  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="power_supply", KERNEL=="BAT0", ATTR{charge_control_end_threshold}="80", ATTR{charge_control_start_threshold}="75", ATTR{charge_types}="Custom"
  '';

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
