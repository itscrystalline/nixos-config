{
  config,
  pkgs,
  lib,
  ...
}: let
  enabled = config.bluetooth.enable;
in {
  options.bluetooth.enable = lib.mkEnableOption "bluetooth";
  config = lib.mkIf enabled {
    hardware.bluetooth = {
      enable = true; # enables support for Bluetooth
      package = pkgs.bluez;
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
      settings.General.Enable = "Source,Sink,Media,Socket";
    };
  };
}
