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
networking.wireless.iwd = {
  enable = true;
  settings = {
    General = {
      EnableNetworkConfiguration = true;
    };
    Network = {
      EnableIPv6 = false;
      NameResolvingService = "resolvconf";
    };
  };
};

# 2. Secret Configuration

#--- WIFI ----
  age.secrets.wifi-home = {
    file = ./secrets/wifi-home.age;
    owner = "root";
    mode  = "0600";
  };

  age.secrets.wifi-eduroam = {
   file = ./secrets/wifi-eduroam.age;
   owner = "root";
   mode = "0600";
  };

#  age.secrets.wifi-office = {
#    file = ./secrets/wifi-office.age;
#    owner = "root";
#    mode  = "0600";
#  };

#  age.secrets.wifi-phone = {
#    file = ./secrets/wifi-phone.age;
#    owner = "root";
#    mode  = "0600";
#  };

  #---------------------

age.secrets.external-hd-key = {
  file = ./secrets/external-hd-key.age;
  owner = "oliveira";
  mode  = "0400";
};

age.secrets.restic-pw = {
  file = ./secrets/restic-pw.age;
  owner = "oliveira"; # So your user script can read it
  mode = "0400";      # Strictly read-only for you
};

age.secrets.vpn-key = {
  file = ./secrets/vpn-key.age;
  owner = "root"; 
  mode = "0400";
};

age.secrets.rclone-config = {
  file = ./secrets/rclone-config.age;
  owner = "oliveira";
  mode = "0600"; # Strictly for you
};

age.secrets.gcalcli-oauth = {
  file = ./secrets/gcalcli-oauth.age;
  owner = "oliveira";
  mode  = "0600";
};

age.secrets.gh-hosts = {
  file = ./secrets/gh-hosts.age;
  owner = "oliveira";
  mode  = "0600";
};

age.secrets.ssh-config = {
  file = ./secrets/ssh-config.age;
  path = "/home/oliveira/.ssh/config";
  owner = "oliveira";
  mode  = "0600";
};

 # --- Deploy .psk files into iwd's config directory ---
  system.activationScripts.iwd-networks = {
    deps = [ "agenix" ];
    text = ''
      mkdir -p /var/lib/iwd
      chmod 0700 /var/lib/iwd

      cp /run/agenix/wifi-home    /var/lib/iwd/DecoM5.psk
      #cp /run/agenix/wifi-office  /var/lib/iwd/NANO.psk
      #cp /run/agenix/wifi-phone   /var/lib/iwd/Galaxy-A15.psk
      cp /run/agenix/wifi-eduroam /var/lib/iwd/eduroam.8021x

      chmod 0600 /var/lib/iwd/*.psk /var/lib/iwd/*.8021x
      chown root:root /var/lib/iwd/*.psk /var/lib/iwd/*.8021x
    '';
  };

#---- Rclone special copy to a writable location
system.activationScripts.rclone-config = {
  deps = [ "agenix" ];
  text = ''
    mkdir -p /home/oliveira/.config/rclone
    chown oliveira:users /home/oliveira/.config/rclone
    chmod 0755 /home/oliveira/.config/rclone
    cp /run/agenix/rclone-config /home/oliveira/.config/rclone/rclone.conf
    chown oliveira:users /home/oliveira/.config/rclone/rclone.conf
    chmod 0600 /home/oliveira/.config/rclone/rclone.conf
  '';
};

#---gcalcli special copy to a writable location
system.activationScripts.gcalcli-oauth = {
  deps = [ "agenix" ];
  text = ''
    mkdir -p /home/oliveira/.local/share/gcalcli
    chown oliveira:users /home/oliveira/.local/share/gcalcli
    chmod 0755 /home/oliveira/.local/share/gcalcli
    cp /run/agenix/gcalcli-oauth /home/oliveira/.local/share/gcalcli/oauth
    chown oliveira:users /home/oliveira/.local/share/gcalcli/oauth
    chmod 0600 /home/oliveira/.local/share/gcalcli/oauth
  '';
};

# --- Github special copy to a writable location
system.activationScripts.gh-hosts = {
  deps = [ "agenix" ];
  text = ''
    mkdir -p /home/oliveira/.config/gh
    chown oliveira:users /home/oliveira/.config/gh
    chmod 0755 /home/oliveira/.config/gh
    cp /run/agenix/gh-hosts /home/oliveira/.config/gh/hosts.yml
    chown oliveira:users /home/oliveira/.config/gh/hosts.yml
    chmod 0600 /home/oliveira/.config/gh/hosts.yml
  '';
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
  services.gvfs.enable = true;   
  services.udisks2.enable = true;

  # Allow specific user to run openvpn without password
security.sudo.extraConfig = ''
  oliveira ALL=(ALL) NOPASSWD: /etc/profiles/per-user/oliveira/bin/manage-vpn
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
    #RCLONE_CONFIG = "/run/agenix/rclone-config";
  };

  # --- System Services ---
  services.openssh.enable = true;

  # --- System State ---
  system.stateVersion = "25.05";
}
