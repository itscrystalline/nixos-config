{
  lib,
  config,
  pkgs,
  spkgs,
  ...
}: let
  enabled = config.hardware.raspberrypi.enable;
in {
  options.hardware.raspberrypi.enable = lib.mkEnableOption "Raspberry Pi 4 hardware support";
  config = lib.mkIf enabled {
    kernel.package = pkgs.linuxPackagesFor spkgs.linux_rpi4;
    image.modules.sd-card = {
      sdImage.firmwareSize = 256; # 256MB /boot
    };
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
