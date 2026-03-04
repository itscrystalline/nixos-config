{
  lib,
  config,
  ...
}: let
  enabled = config.hardware.crystals-rpi4.enable;
in {
  options.hardware.crystals-rpi4.enable = lib.mkEnableOption "Raspberry Pi 4 hardware support";
  config = lib.mkIf enabled {
    hardware.raspberry-pi."4" = {
      apply-overlays-dtmerge.enable = true;
      bluetooth.enable = true;
    };
    hardware.enableAllHardware = false;
  };
}
