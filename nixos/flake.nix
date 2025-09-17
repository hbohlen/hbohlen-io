{
  description = "A personal NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, disko, ... }: {
    nixosConfigurations = {
      # Define your NixOS configurations here
      # Example:
      # laptop = nixpkgs.lib.nixosSystem {
      #   system = "x86_64-linux";
      #   modules = [
      #     ./hosts/laptop/configuration.nix
      #   ];
      # };
    };

    homeConfigurations = {
      # Define your home-manager configurations here
      # Example:
      # hbohlen = home-manager.lib.homeManagerConfiguration {
      #   pkgs = nixpkgs.legacyPackages.x86_64-linux;
      #   modules = [
      #     ./users/hbohlen/home.nix
      #   ];
      # };
    };
  };
}