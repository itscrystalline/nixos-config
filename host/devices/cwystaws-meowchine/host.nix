{ config, pkgs, ... }@inputs:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/main/boot.nix
    ../../modules/main/programs.nix
    ../../modules/main/services.nix
    ../../modules/main/bluetooth.nix
    ../../modules/main/graphics.nix
    ../../modules/main/network.nix
    ../../modules/main/asus.nix
    ../../modules/main/hyprland.nix
    ../../modules/main/pipewire/pipewire.nix
    ../../modules/main/games.nix
    ../../modules/main/flatpak.nix
    ../../modules/main/virtualisation.nix
    ../../modules/main/hw-misc.nix
    ../../modules/common/security.nix
    ../../modules/common/localization.nix
    ../../modules/common/theming.nix
    ../../modules/common/compat.nix
    ../../modules/main/users/itscrystalline.nix
  ];
}
