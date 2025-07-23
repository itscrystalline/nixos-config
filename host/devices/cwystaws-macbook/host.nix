{lib, ...}: {
  imports = [
    ../../modules/mac/homebrew.nix
    ../../modules/mac/users/itscrystalline.nix
  ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-darwin";
}
