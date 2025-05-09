{
  pkgs,
  config,
  ...
}: {
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd = {
      availableKernelModules = ["xhci_pci"];
    };
    extraModulePackages = with config.boot.kernelPackages; [
      rtw88
    ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    kernelParams = [
      "psi=1"
      "brcmfmac.roamoff=1"
      "brcmfmac.feature_disable=0x282000"
    ];
  };
}
