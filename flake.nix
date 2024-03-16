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
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    systems = [
      # "aarch64-linux"  # Raspberry Pi systems
      "x86_64-linux" # General linux systems
      # "aarch64-darwin" # MacOS systems
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
      nixos-tutorial = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/nixos-tutorial/configuration.nix];
      };
      nixos = lib.nixosSystem {
        pkgs = pkgsFor.x86_64-linux;
        specialArgs = {inherit inputs outputs;};
        modules = [
          nixos-wsl.nixosModules.wsl
          ./hosts/wsl/wsl.nix
        ];
      };
    };

    homeConfigurations = {
      pieter = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        modules = [./home.nix];
        extraSpecialArgs = {
          inherit inputs;
          inherit devenv;
        };
      };
    };
  };
}
