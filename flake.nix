{
  description = "Hayden's NixOS configuration";

  inputs = {
    # Core Nixpkgs - pinned to stable for reproducibility
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Hardware support
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    disko.url = "github:nix-community/disko";
    
    # Impermanence for stateless system
    impermanence.url = "github:nix-community/impermanence";
    
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Optional: Hyprland for Wayland support
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, disko, impermanence, home-manager, hyprland, ... }: {
    
    # Development shells
    devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
      packages = with nixpkgs.legacyPackages.x86_64-linux; [
        git
        jq
        yq
        nixpkgs-fmt
        statix
        deadnix
      ];
    };
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # Base hardware profile for ASUS Zephyrus M16
          nixos-hardware.nixosModules.asus-zephyrus-gu603h
          nixos-hardware.nixosModules.asus-battery
          
          # Core modules
          impermanence.nixosModules.impermanence
          disko.nixosModules.disko
          
          # Host configuration
          ./nixos/hosts/laptop/default.nix
          ./nixos/hosts/laptop/hardware-configuration.nix
          ./nixos/hosts/laptop/disko.nix
          
          # Shared system modules
          ./nixos/modules/system/common.nix
          ./nixos/modules/system/packages.nix
          
          # Home manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hbohlen = ./nixos/users/hbohlen/home.nix;
          }
        ];
      };

      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # Core modules
          impermanence.nixosModules.impermanence
          disko.nixosModules.disko
          
          # Host configuration
          ./nixos/hosts/desktop/default.nix
          ./nixos/hosts/desktop/hardware-configuration.nix
          ./nixos/hosts/desktop/disko.nix
          
          # Shared system modules
          ./nixos/modules/system/common.nix
          ./nixos/modules/system/packages.nix
          
          # Home manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hbohlen = ./nixos/users/hbohlen/home.nix;
          }
        ];
      };

      server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # Core modules
          impermanence.nixosModules.impermanence
          disko.nixosModules.disko
          
          # Host configuration
          ./nixos/hosts/server/default.nix
          ./nixos/hosts/server/hardware-configuration.nix
          ./nixos/hosts/server/disko.nix
          
          # Shared system modules
          ./nixos/modules/system/common.nix
          ./nixos/modules/system/packages.nix
          
          # Home manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hbohlen = ./nixos/users/hbohlen/home.nix;
          }
        ];
      };
    };

    # Legacy home configuration (will be migrated to per-host)
    homeConfigurations = {
      hbohlen = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          {
            nixpkgs.config.allowUnfree = true;
          }
          ./nixos/users/hbohlen/home.nix
        ];
      };
    };
    
    # Formatter for the entire project
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
  };
}