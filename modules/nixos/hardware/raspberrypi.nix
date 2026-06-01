{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  enabled = config.hardware.raspberrypi.enable;

  pkgs-25-11 = import inputs.nixpkgs-25-11 {
    inherit (pkgs.stdenv.hostPlatform) system;
  };
in {
  options.hardware.raspberrypi.enable = lib.mkEnableOption "Raspberry Pi 4 hardware support";
  config = lib.mkIf enabled {
    kernel.package = pkgs-25-11.linuxKernel.packages.linux_rpi4;
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
