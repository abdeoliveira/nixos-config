{ config, pkgs, agenix, ... }:


{
  # --- Nix Settings ---
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # --- Imports ---
  imports = [
    ./hardware-configuration.nix
    ./host-specific.nix
  ];

  # --- Nixpkgs Settings (overlays, unfree packages) ---
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (self: super: {
      qtgrace = super.callPackage ./pkgs/qtgrace { };
      vesta = super.callPackage ./pkgs/vesta { };
      gtk3-nocsd = super.callPackage ./pkgs/gtk3-nocsd { };
    })
  ];

  # --- Bootloader ---
#  boot.loader.systemd-boot.enable = true;
#  boot.loader.efi.canTouchEfiVariables = true;
#  boot.loader.systemd-boot.configurationLimit = 10;

  # --- Kernel ---
  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelModules = [ "i2c-dev" ];
  boot.kernelParams = ["mem_sleep_default=deep" "i915.enable_psr=0"];

  # --- Swap memory ---
  swapDevices = [
  {
    device = "/swapfile";
    size = 8192; 
    #randomizedEncryption.enable = true;
  }
];

# Mount /tmp as tmpfs (in memory, cleared on reboot)
  boot.tmp.useTmpfs = true;

  services.udev.extraRules = ''
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';

# --- Networking ---
# --- Networking ---
networking.wireless = {
  enable = true;
  secretsFile = config.age.secrets.wifi-psk.path;

  networks = {
    "DecoM5" = {
      # 'ext:' tells the system to look for the variable name in your secretsFile
      pskRaw = "ext:psk_home"; 
    };
    "NANO" = {
      pskRaw = "ext:psk_office";
    };
  };
};

# 2. Secret Configuration
age.secrets.wifi-psk = {
  file = ./wifi-psk.age;
  owner = "root";
  group = "root";
  mode = "0440";
};

# --- ufupd ---
services.fwupd.enable = true;

  # Pipewire for screen sharing audio and video on Wayland.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

programs.niri.enable = true;
services.getty.autologinUser = "oliveira";

# --- Printing and Scanning ---
services.printing = {
  enable = true;
  drivers = [ pkgs.gutenprint ]; # The swissknife printer driver
};

services.avahi = {
  enable = true;
  nssmdns4 = true;
  openFirewall = true;
};

hardware.sane = {
  enable = true;
  extraBackends = [ pkgs.sane-airscan ];
};


# --- Localization ---
time.timeZone = "America/Sao_Paulo";
i18n.defaultLocale = "en_US.UTF-8";

  # --- Console and X11 Keymaps ---
#  console.keyMap = "br-abnt2";
#  services.xserver.xkb = {
#    layout = "br";
#    variant = "";
#  };

  users.groups.i2c = {}; # ddcutil

  # --- User Accounts ---
  users.users.oliveira = {
    isNormalUser = true;
    description = "Alan Barros de Oliveira";
    extraGroups = [ "wheel" "i2c" ];
    packages = with pkgs; [];
  };
  

 home-manager.users.oliveira = { imports = [ ./home.nix ]; };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "bak";
  #home-manager.overwriteBackup = true;

  # ---- Nautilus ----
  programs.dconf.enable = true;

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "alacritty";
  };
  services.gvfs.enable = true;   # keep this, Nautilus needs it too
  services.udisks2.enable = true; # keep this too

  # Allow specific user to run openvpn without password
security.sudo.extraConfig = ''
  oliveira ALL=(ALL) NOPASSWD: /etc/profiles/per-user/oliveira/bin/manage-vpn start
  oliveira ALL=(ALL) NOPASSWD: /etc/profiles/per-user/oliveira/bin/manage-vpn stop
  oliveira ALL=(ALL) NOPASSWD: /etc/profiles/per-user/oliveira/bin/external-hd-mount mount
  oliveira ALL=(ALL) NOPASSWD: /etc/profiles/per-user/oliveira/bin/external-hd-mount umount
'';
 
# -- Fonts ---
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

 # --- System-Wide Packages ---
environment.systemPackages = (import ./pkgs/system-pkgs.nix) { inherit pkgs agenix; };

 # --- Environment Variables ---
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "alacritty";
  };

  # --- System Services ---
  services.openssh.enable = true;

  # --- System State ---
  system.stateVersion = "25.05";
}
