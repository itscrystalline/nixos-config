{ ... }:
# let
#   bluez_working = import (builtins.fetchTarball {
#     # bluez 5.70
#       url = "https://github.com/NixOS/nixpkgs/archive/2392daed231374d0d1c857cd7a75edd89e084513.tar.gz";
#       sha256 = "0qfqia0mcbaxa7zy9djnk5dzhs69pi0k6plgmf1innj8j38kkp0k";
#     }) { builtins.currentSystem; };
# in
{
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  # hardware.bluetooth.package = bluez_working.bluez;
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  hardware.bluetooth.settings.General.Enable = "Source,Sink,Media,Socket";
  services.blueman.enable = true;
}
