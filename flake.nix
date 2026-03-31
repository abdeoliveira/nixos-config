{
  description = "Oliveira's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 1. Add the agenix input
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, agenix, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      # 2. Pass agenix as a specialArg so it's available in configuration.nix
      specialArgs = { inherit agenix; };

      modules = [
        ./configuration.nix
        
        # 3. Add the agenix NixOS module
        agenix.nixosModules.default

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          
          # 4. If you want to use agenix inside home.nix too:
          home-manager.extraSpecialArgs = { inherit agenix; };
          home-manager.users.oliveira = {
            imports = [ 
              ./home.nix 
              agenix.homeManagerModules.default 
            ];
          };
        }
      ];
    };
  };
}
