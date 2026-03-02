{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/main/boot.nix
    ../../modules/main/programs.nix
    ../../modules/main/services.nix
    ../../modules/main/bluetooth.nix
    ../../modules/main/graphics.nix
    ../../modules/main/network.nix
    ../../modules/main/asus.nix
    ../../modules/main/niri.nix
    ../../modules/main/pipewire/pipewire.nix
    ../../modules/main/games.nix
    ../../modules/main/flatpak.nix
    ../../modules/main/virtualisation.nix
    ../../modules/main/hw-misc.nix
    ../../modules/main/localization.nix
    ../../modules/common/security.nix
    ../../modules/main/mounts.nix
    ../../modules/common/theming.nix
    ../../modules/common/compat.nix
    ../../modules/main/users/nixremote.nix
    ../../modules/main/users/itscrystalline.nix
  ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
