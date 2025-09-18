{
  description = "Hayden's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    disko.url = "github:nix-community/disko";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, disko, home-manager, sops-nix, ... }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit home-manager sops-nix; };
        modules = [
          # Base hardware profile for ASUS Zephyrus M16
          nixos-hardware.nixosModules.asus-zephyrus-gu603h

          # Optional hardware module for battery control
          nixos-hardware.nixosModules.asus-battery

          # Disk configuration and main system config
          disko.nixosModules.disko
          ./hosts/laptop/disko.nix
          ./hosts/laptop/configuration.nix

          # Secrets management
          sops-nix.nixosModules.sops

          # Home manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hbohlen = import ./users/hbohlen/home.nix;
          }
        ];
      };

      desktop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit home-manager sops-nix; };
        modules = [
          # Disk configuration and main system config
          disko.nixosModules.disko
          ./hosts/desktop/disko.nix
          ./hosts/desktop/configuration.nix

          # Secrets management
          sops-nix.nixosModules.sops

          # Home manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hbohlen = import ./users/hbohlen/home.nix;
          }
        ];
      };

      server = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit home-manager sops-nix; };
        modules = [
          # Disk configuration and main system config
          disko.nixosModules.disko
          ./hosts/server/disko.nix
          ./hosts/server/configuration.nix

          # Secrets management
          sops-nix.nixosModules.sops

          # Home manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hbohlen = import ./users/hbohlen/home.nix;
          }
        ];
      };
    };

    homeConfigurations = {
      hbohlen = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          ./users/hbohlen/home.nix
        ];
      };
    };
  };
}