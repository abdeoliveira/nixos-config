{
  description = "Oliveira's NixOS Configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    # Tracks nixos-unstable solely to pull a current claude-code; everything
    # else stays on the 26.05 pin above. See the overlay in configuration.nix.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, agenix, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit agenix nixpkgs-unstable; };
      modules = [
        ./configuration.nix
        agenix.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
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
