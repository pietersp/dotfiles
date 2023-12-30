# Installing on NixOS-wsl

1. Follow the [official](https://github.com/nix-community/NixOS-WSL) install guide for installing
  WSL version of NixOS.
2. Run the following to switch to unstable
  ```
  sudo nix-channel --add https://nixos.org/channels/nixos-unstable
  sudo nix-channel --add https://nixos.org/channels/nixpkgs-unstable
  sudo nix-channel --update
  ```
3. `nix-shell -p git neovim`
4. Get the dotfiles repo
  ```
  git clone https://github.com/pietersp/dotfiles.git /tmp/dotfiles
  ```
5. `cd /tmp/dotfiles`
6. `sudo nixos-rebuild switch --flake .`
7. User should now be created.
8. Log in as new user and install standalone home-manager
9. `mv /tmp/dotfiles ~/dotfiles`
10. `home-manager switch --flake .`
