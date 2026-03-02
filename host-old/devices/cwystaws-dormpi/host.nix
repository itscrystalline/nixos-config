{lib, ...} @ inputs: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/dormpi/boot.nix
    ../../modules/dormpi/network.nix
    ../../modules/dormpi/services.nix
    ../../modules/dormpi/programs.nix
    ../../modules/dormpi/localization.nix
    ../../modules/raspi/hw-misc.nix
    ../../modules/common/security.nix
    ../../modules/common/theming.nix
    ../../modules/common/users/itscrystalline.nix
  ];
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
