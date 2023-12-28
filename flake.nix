{
  description = "My NixOs and Home Manager configuration flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        nixos-tutorial = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./system/nixos-tutorial/configuration.nix ];
        };
      };
      
      homeConfigurations = {
        pieter = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
        };
      };
    };
}
