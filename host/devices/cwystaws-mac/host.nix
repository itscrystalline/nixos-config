{lib, ...}: {
  imports = [
    ../../modules/mac/homebrew.nix
    ../../modules/main/users/itscrystalline.nix
  ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
