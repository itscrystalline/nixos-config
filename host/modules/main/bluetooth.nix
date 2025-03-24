{ pkgs, ... }:

{
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.package = pkgs.bluez-5-75.bluez;
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  hardware.bluetooth.settings.General.Enable = "Source,Sink,Media,Socket";
  # services.blueman.enable = true; # broken
  environment.systemPackages = [ pkgs.blueberry ];
}
