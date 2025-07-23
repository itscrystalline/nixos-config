{
  lib,
  pkgs,
  ...
} @ inputs: {
  users.users.itscrystalline = {
    description = "itscrystalline";
    home = lib.mkDefault "/Users/itscrystalline";
    shell = pkgs.zsh;
  };
  system.primaryUser = "itscrystalline";
}
