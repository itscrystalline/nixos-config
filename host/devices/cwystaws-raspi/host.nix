{
  config,
  pkgs,
  ...
} @ inputs: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/raspi/boot.nix
    ../../modules/raspi/network.nix
    ../../modules/raspi/services.nix
    ../../modules/raspi/printers.nix
    ../../modules/raspi/programs.nix
    ../../modules/raspi/hw-misc.nix
    ../../modules/raspi/security.nix
    ../../modules/common/localization.nix
    ../../modules/common/theming.nix
    ../../modules/raspi/users/itscrystalline.nix
  ];
}
