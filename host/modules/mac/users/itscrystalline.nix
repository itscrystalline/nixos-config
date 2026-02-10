{
  config,
  lib,
  pkgs,
  ...
} @ inputs: let
  cfg = config.crystal.users.mac.itscrystalline;
in {
  options.crystal.users.mac.itscrystalline.enable = lib.mkEnableOption "mac itscrystalline user configuration";

  config = lib.mkIf cfg.enable {
    users.users.itscrystalline = {
      description = "itscrystalline";
      home = lib.mkDefault "/Users/itscrystalline";
      shell = pkgs.zsh;
    };
    system.primaryUser = "itscrystalline";
  };
}
