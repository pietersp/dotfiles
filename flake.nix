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
    ...
  }: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    systems = [
      # "aarch64-linux"  # Raspberry Pi systems
      "x86_64-linux" # General linux systems
      "aarch64-darwin" # MacOS systems
    ];
    forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs systems (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
  in {
    inherit lib;

    # Custom modifications/overrides to upstream packages
    overlays = import ./overlays {inherit inputs outputs;};

    # Your custom packages meant to be shared or upstreamed.
    # Accessible through 'nix build', 'nix shell', etc
    packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});

    # Nix formatter available through `nix fmt` https://nix-community.github.io/nixpkgs-fmt
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    nixosConfigurations = {
      # VM to test full NixOS setup on enceladus
      nixos-tutorial = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/nixos-tutorial/configuration.nix
        ];
      };
      # WSL2 installation on enceladus
      # TODO: See if you can rename
      nixos = lib.nixosSystem {
        pkgs = pkgsFor.x86_64-linux;
        specialArgs = {inherit inputs outputs;};
        modules = [
          nixos-wsl.nixosModules.wsl
          ./hosts/wsl/wsl.nix
        ];
      };
      # T490 NixOs Laptop
      helene = lib.nixosSystem {
        pkgs = pkgsFor.x86_64-linux;
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/helene/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      "pieter@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        modules = [./home/pieter/nixos.nix];
        extraSpecialArgs = {inherit inputs outputs;};
      };
      "pieter@helene" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        modules = [./home/pieter/helene.nix];
        extraSpecialArgs = {inherit inputs outputs;};
      };
    };
  };
}
