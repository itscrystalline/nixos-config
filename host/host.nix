{ config, pkgs, ... }@inputs:
{
  imports = [
    ./hardware-configuration.nix
    ./modules/boot.nix
    ./modules/graphics.nix
    ./modules/network.nix
    ./modules/hw-misc.nix
    ./modules/security.nix
    ./modules/programs.nix
    ./modules/services.nix
    ./modules/localization.nix
    ./modules/theming.nix
    ./modules/hyprland.nix
    ./modules/pipewire/pipewire.nix
    ./modules/users/itscrystalline.nix
  ];
}
