{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crystal.raspi.boot;
in {
  options.crystal.raspi.boot.enable = lib.mkEnableOption "raspi boot configuration" // {default = true;};

  config = lib.mkIf cfg.enable {
    boot = {
      kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi4;
      initrd = {
        availableKernelModules = ["xhci_pci" "usbhid" "usb_storage"];
        network.enable = true;
      };
      loader = {
        grub.enable = false;
        generic-extlinux-compatible.enable = true;
      };
      kernelParams = [
        "psi=1"
      ];
    };
  };
}
