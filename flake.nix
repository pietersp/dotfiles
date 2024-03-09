{
  description = "My NixOs and Home Manager configuration flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv = {
      url = "github:cachix/devenv/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    nixos-wsl,
    devenv,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in {
    nixosConfigurations = {
      nixos-tutorial = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [./system/nixos-tutorial/configuration.nix];
      };
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          nixos-wsl.nixosModules.wsl
          ./system/wsl/wsl.nix
        ];
      };
    };

    homeConfigurations = {
      pieter = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./home.nix];
        extraSpecialArgs = {inherit inputs;};
      };
    };
  };
}
