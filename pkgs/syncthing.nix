{ config, pkgs, ... }:

{
  # Networking: Open ports for local discovery and sync traffic
  networking.firewall.allowedTCPPorts = [ 22000 8384 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];

  services.syncthing = {
    enable = true;
    user = "oliveira";
    dataDir = "/home/oliveira";    # Default for the 'Sync' folder path
    configDir = "/home/oliveira/.local/state/syncthing";
    
    # Ensures NixOS is the 'Source of Truth'
    overrideDevices = true; 
    overrideFolders = true;

    settings = {
      devices = {
        "SM-A155M" = { 
          id = "X4CQ5M2-F7CVAB3-WRUBDEX-HAC4LWV-Q2QYH2U-4UFGJQL-AXZ7CLV-ABYW2AP"; 
        };
      };

      folders = {
        "Sync" = {
          id = "jkvqq-rj63h";    # From your <folder id="..."> tag
          path = "/home/oliveira/Sync";
          devices = [ "SM-A155M" ];
          # Explicitly preserving your existing folder logic
          versioning = {
            type = "simple";
            params.keep = "5"; 
          };
        };
      };

      options = {
        globalAnnounceEnabled = true;
        localAnnounceEnabled = true;
        relaysEnabled = true;
	urAccepted = -1;
      };

      gui = {
        # Matches your current local-only access
        address = "127.0.0.1:8384";
      };
    };
  };
}
