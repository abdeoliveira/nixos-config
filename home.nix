{ config, pkgs, ... }:

let
  my-scripts = import ./pkgs/my-scripts { inherit pkgs; };
in

{
  imports = [ ./timers/simplecron.nix ];

  _module.args.my-scripts = my-scripts;

  home.stateVersion = "25.05";

  home.packages = (import ./pkgs/home-pkgs.nix) { 
     inherit pkgs my-scripts; 
     };

   programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
   };

  gtk = {
    enable = true;
    theme = { name = "Dracula"; package = pkgs.dracula-theme; };
    iconTheme = { name = "Dracula"; package = pkgs.dracula-icon-theme; };
  };

  # --- Portals for niri ----
  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = ["gnome" "gtk"];
        "org.freedesktop.impl.portal.FileChooser" = "gtk";
        "org.freedesktop.impl.portal.ScreenCast" = "gnome";
        "org.freedesktop.impl.portal.Screenshot" = "gnome";
        "org.freedesktop.impl.portal.RemoteDesktop" = "gnome";
      };
    };
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

#----Firefox----------
programs.firefox = {
  enable = true;
  profiles.oliveira = {
    id = 0;
    name = "oliveira";
    #path = "n22j49de.default";
    extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      istilldontcareaboutcookies
      passff
    ];
    settings = {
      "browser.urlbar.placeholderName"         = "DuckDuckGo";
      "browser.urlbar.placeholderName.private" = "DuckDuckGo";
      "browser.engagement.home-button.has-used" = true;
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites"     = false;
      "privacy.donottrackheader.enabled" = true;
      "network.dns.disablePrefetch"      = true;
      "network.prefetch-next"            = false;
      "signon.rememberSignons"           = false;
      "sidebar.visibility"               = "hide-sidebar";
      "browser.toolbars.bookmarks.visibility" = "always";
      "browser.translations.automaticallyPopup" = false;
      "browser.uiCustomization.state" = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"ublock0_raymondhill_net-browser-action\",\"idcac-pub_guus_ninja-browser-action\",\"passff_invicem_pro-browser-action\",\"jid1-kkzogwgsw3ao4q_jetpack-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"home-button\",\"customizableui-special-spring1\",\"vertical-spacer\",\"urlbar-container\",\"customizableui-special-spring2\",\"downloads-button\",\"fxa-toolbar-menu-button\",\"unified-extensions-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"firefox-view-button\",\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\",\"screenshot-button\",\"idcac-pub_guus_ninja-browser-action\",\"passff_invicem_pro-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"jid1-kkzogwgsw3ao4q_jetpack-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"vertical-tabs\",\"PersonalToolbar\",\"unified-extensions-area\",\"TabsToolbar\",\"toolbar-menubar\"],\"currentVersion\":23,\"newElementCount\":3}";
    };
  };
};

#----mimeApps config----
xdg.mimeApps = {
  enable = true;
  defaultApplications = {
    # PDF
    "application/pdf" = "org.gnome.Evince.desktop";

    # Text Files (.txt) -> Gedit
    "text/plain" = "org.gnome.gedit.desktop";

    # Directories -> Nautilus
    "inode/directory" = "org.gnome.Nautilus.desktop";

    # Web Links -> Firefox
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";

    # Images -> GNOME Image Viewer (optional defaults)
    "image/jpeg" = "org.gnome.eog.desktop";
    "image/png"  = "org.gnome.eog.desktop";

    # Terminal -> Alacritty
    "x-scheme-handler/terminal" = "Alacritty.desktop";
  };
};

# Force overwrite of mimeapps.list (Must be outside the block above)
xdg.configFile."mimeapps.list".force = true;

#---- Dracula theme----
 dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Dracula";
      icon-theme = "Dracula";
    };
};

# ---- Neovim ----
programs.neovim = {
  enable = true;
  plugins = [
    pkgs.vimPlugins.dracula-vim 
  ];
  extraConfig = ''
    colorscheme dracula
  '';
};

  # --- Mouse cursor ---
  home.pointerCursor = {
    name = "Dracula-cursors"; # Cursor theme 
    package = pkgs.dracula-theme;
    size = 24; # A standard, normal cursor size
    gtk.enable = true; # Ensures GTK apps use this cursor
  };

  home.sessionVariables = {
   # XCURSOR_THEME = "Dracula-cursors";
   # XCURSOR_SIZE = "24";
    PASSWORD_STORE_X_SELECTION = "primary";
    PASSWORD_STORE_DIR = "/home/oliveira/Sync/password-store";
    #QT_QPA_PLATFORMTHEME = "qt6ct";
    OMP_NUM_THREADS = "1";
    GTK_CSD = "0";
    LD_PRELOAD = "${pkgs.gtk3-nocsd}/lib/libgtk3-nocsd.so.0";
    EXTERNAL_HD_UUID = "147466cd-2eea-4f9e-9221-b0dfaf9cbd1e";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "ls --color=auto";
      vi = "nvim";
      jmol = "jmol-wayland";
      bc = "bc -lq";
      pry = "pry 2>/dev/null";
      xmgrace = "qtgrace 2>/dev/null";
      nrs = "sudo nixos-rebuild switch --flake /home/oliveira/.nixos-config";
      hm-reload = "unset __HM_SESS_VARS_SOURCED && source /etc/profiles/per-user/oliveira/etc/profile.d/hm-session-vars.sh";
    };

  initExtra = ''
      export PS1='\[\e[1;32m\]\u@\h\[\e[1;97m\]:\[\e[1;34m\]\W\[\e[0m\]\$ '
      export TERM=xterm-256color
      export GPG_TTY=$(tty)
      export GPG_UNLOCK_KEY="alanbarros@protonmail.com"
      complete -W 'mount umount' external-hd-mount
      complete -W 'backup restore list prune delete help unlock mount check find check-download' restic-gdrive
      eval "$(direnv hook bash)"      

# Start Niri on tty1
  if [ "$(tty)" = "/dev/tty1" ]; then
     niri-auto-unlock.sh
  fi
'';
 
};

  services.mako = {
    enable = true;
    settings = {
      "default-timeout" = 5000;
      "font" = "monospace 16";
      "background-color" = "#2e3440";
      "border-color" = "#EE82EE";
    };
  };

  # --- GPG Configuration ---
  programs.gpg = {
    enable = true;
    settings = {
      # GPG settings here if needed
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;  # Enable SSH support if you use GPG for SSH keys
    defaultCacheTtl = 2592000;  # 30 days in seconds
    maxCacheTtl = 2592000;      # 30 days in seconds
    pinentry.package = pkgs.pinentry-curses;
    grabKeyboardAndMouse = true;
    
    # Any additional configuration options
    extraConfig = ''
      # Additional gpg-agent configuration can go here
    '';
  };

  home.file = {
    ".local/share/libgedit-gtksourceview-300/styles/dracula.xml".source = ./gedit/dracula.xml;
    ".config/niri/config.kdl".source = ./niri/config.kdl;
    ".config/gammastep/config.ini".source = ./gammastep/config.ini;
    ".config/alacritty/alacritty.toml".source = ./alacritty/alacritty.toml;
    ".config/swaylock/config".source = ./swaylock/config;
    ".config/simplecron/config".source = ./simplecron/config;
    ".config/openvpn/vpnufop.conf".source = ./openvpn/vpnufop.ovpn;
    ".config/waybar".source = ./waybar;
    ".config/wallpaper".source = ./wallpaper;
    ".ssh/id_rsa.pub".source  = ./ssh/id_rsa.pub;
    #".ssh/known_hosts".source = ./ssh/known_hosts;
    ".ssh/config".source      = ./ssh/config;
  };
}
