# Dotfiles

NixOS, WSL2, and Darwin configuration using Home Manager and flake-parts.

## Quick Bootstrap

### WSL2 (from bare Ubuntu/other distro)

```bash
# 1. Install Nix (enable flakes)
# 2. Activate home-manager directly from GitHub (no clone needed)
nix run home-manager -- switch --flake github:pietersp/dotfiles#pieter@wsl

# 3. Clone for future use
git clone https://github.com/pietersp/dotfiles.git ~/dotfiles
```

### macOS (Darwin)

```bash
# 1. Install Nix (with flakes enabled)
# 2. Activate home-manager directly from GitHub (no clone needed)
nix run home-manager -- switch --flake github:pietersp/dotfiles#pieter@tethys

# 3. Clone for future use
git clone https://github.com/pietersp/dotfiles.git ~/dotfiles
```

### NixOS (Physical/Virtual)

```bash
# Clone and rebuild
git clone https://github.com/pietersp/dotfiles.git ~/dotfiles
cd ~/dotfiles

# For helene (laptop)
sudo nixos-rebuild switch --flake .#helene

# Then home manager
home-manager switch --flake .#pieter@helene
```

Or from another machine without cloning:

```bash
# Activate home-manager directly from GitHub
nix run home-manager -- switch --flake github:pietersp/dotfiles#pieter@helene
```

## Development Shells

```bash
# Auto-detects your architecture
nix develop 
```

## Updating

```bash
# Update flake inputs
nix flake update

# Apply changes
home-manager switch --flake .#pieter@$(hostname)
```
