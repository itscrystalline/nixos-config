{config, lib, ...}: let
  cfg = config.crystal.raspi.hwMisc;
in {
  imports = [../common/hw-misc.nix];

  options.crystal.raspi.hwMisc.enable = lib.mkEnableOption "raspi hardware misc configuration" // {default = true;};

  config = lib.mkIf cfg.enable {
    hardware.raspberry-pi."4" = {
      apply-overlays-dtmerge.enable = true;
      bluetooth.enable = true;
    };
    hardware.enableAllHardware = lib.mkForce false;
  };
}
