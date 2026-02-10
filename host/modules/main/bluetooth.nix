{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crystal.bluetooth;
in {
  options.crystal.bluetooth.enable = lib.mkEnableOption "bluetooth" // {default = true;};
  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true; # enables support for Bluetooth
      package = pkgs.bluez;
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
      settings.General.Enable = "Source,Sink,Media,Socket";
    };
    environment.systemPackages = [pkgs.blueberry];
  };
}
