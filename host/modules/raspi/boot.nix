{
  pkgs,
  lib,
  ...
}: {
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
}
