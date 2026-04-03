{
  description = "My NixOs and Home Manager configuration flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:NixOS/nixpkgs/46db2e09e1d3f113a13c0d7b81e2f221c63b8ce9";

    catppuccin.url = "github:catppuccin/nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    my-nixvim = {
      url = "github:pietersp/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    podman-remote = {
      url = "github:pietersp/podman-remote-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      perSystem = {
        system,
        pkgs,
        ...
      }: {
        packages = import ./pkgs {inherit pkgs;};

        formatter = pkgs.alejandra;

        devShells = import ./shells {inherit pkgs;};
      };

      flake = let
        lib = inputs.nixpkgs.lib // inputs.home-manager.lib;
        # Reference the flake outputs so they can be passed to modules (e.g., for overlays)
        outputs = inputs.self;
        gcModule = {
          lib,
          pkgs,
          ...
        }: {
          system.activationScripts.postActivation.text = lib.mkAfter ''
            ${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 3d
          '';
        };
      in {
        inherit lib;

        overlays = import ./overlays {inherit inputs;};

        nixosConfigurations = {
          nixos-tutorial = lib.nixosSystem {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            specialArgs = {inherit inputs;};
            modules = [
              gcModule
              ./hosts/nixos-tutorial/configuration.nix
            ];
          };

          nixos = lib.nixosSystem {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            specialArgs = {inherit inputs;};
            modules = [
              inputs.nixos-wsl.nixosModules.wsl
              gcModule
              ./hosts/wsl/wsl.nix
            ];
          };

          helene = lib.nixosSystem {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            specialArgs = {inherit inputs;};
            modules = [
              inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t490
              gcModule
              ./hosts/helene/configuration.nix
            ];
          };
        };

        darwinConfigurations = {
          "tethys" = inputs.nix-darwin.lib.darwinSystem {
            pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
            specialArgs = {inherit inputs;};
            modules = [
              gcModule
              ./hosts/tethys/configuration.nix
            ];
          };
        };

        homeConfigurations = {
          "pieter@wsl" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              ./home/pieter/wsl.nix
              inputs.catppuccin.homeModules.catppuccin
            ];
            extraSpecialArgs = {inherit inputs outputs;};
          };
          "pieter@helene" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              ./home/pieter/helene.nix
              inputs.catppuccin.homeModules.catppuccin
            ];
            extraSpecialArgs = {inherit inputs outputs;};
          };
          "pieter@tethys" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
            modules = [
              ./home/pieter/tethys.nix
              inputs.catppuccin.homeModules.catppuccin
            ];
            extraSpecialArgs = {inherit inputs outputs;};
          };
        };
      };
    };
}
