{config, lib, ...}: let
  cfg = config.crystal.users.raspi.itscrystalline;
in {
  imports = [../../common/users/itscrystalline.nix];

  options.crystal.users.raspi.itscrystalline.enable = lib.mkEnableOption "raspi itscrystalline user configuration" // {default = true;};

  config = lib.mkIf cfg.enable {
    users.users.itscrystalline.extraGroups = ["docker" "scanner" "lp"];
  };
}
