{
  lib,
  config,
  pkgs,
  ...
}: let
  enabled = config.hardware.raspberrypi.enable;
in {
  options.hardware.raspberrypi.enable = lib.mkEnableOption "Raspberry Pi 4 hardware support";
  config = lib.mkIf enabled {
    hardware.raspberry-pi."4" = {
      apply-overlays-dtmerge.enable = true;
      bluetooth.enable = true;
    };
    hardware.enableAllHardware = lib.mkForce false;
    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
    ];
  };
}
