{
  lib,
  pkgs,
  ...
} @ inputs: {
  users.users.itscrystalline = {
    isNormalUser = true;
    home = lib.mkDefault "/home/itscrystalline";
    description = "itscrystalline";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };
}
