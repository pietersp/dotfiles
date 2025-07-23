{
  description = "My NixOs and Home Manager configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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

    # Secrets management
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Official NixOS hardware packages
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # vscode remote server required for WSL
    # see github for follow up steps required (eg, systemd setup)
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
     };
  };

  outputs = inputs @ {
    self,
    catppuccin,
    nixpkgs,
    home-manager,
    nix-darwin,
    nixos-wsl,
    nixos-hardware,
    vscode-server,
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
          vscode-server.nixosModules.default
          ({ config, pkgs, ... }: {
            services.vscode-server.enable = true;
            services.vscode-server.installPath = "$HOME/.vscode-server";
          })
          ./hosts/wsl/wsl.nix
        ];
      };
      # T490 NixOs Laptop
      helene = lib.nixosSystem {
        pkgs = pkgsFor.x86_64-linux;
        specialArgs = {inherit inputs outputs;};
        modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-t490
          ./hosts/helene/configuration.nix
        ];
      };
    };

    darwinConfigurations = {
      "tethys" = nix-darwin.lib.darwinSystem {
        system = pkgsFor.aarch64-darwin;
        specialArgs = {inherit inputs outputs;};
        modules = [ ./hosts/tethys/configuration.nix ];
      };
    };

    homeConfigurations = {
      "pieter@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        modules = [
	  ./home/pieter/nixos.nix
	  catppuccin.homeModules.catppuccin
	];
        extraSpecialArgs = {inherit inputs outputs;};
      };
      "pieter@helene" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        modules = [
	  ./home/pieter/helene.nix
	  catppuccin.homeModules.catppuccin
	];
        extraSpecialArgs = {inherit inputs outputs;};
      };
      "pieter@tethys" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor.aarch64-darwin;
        modules = [ 
	  ./home/pieter/tethys.nix 
	  catppuccin.homeModules.catppuccin
	];
        extraSpecialArgs = {inherit inputs outputs;};
      };
    };
  };
}
