{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crystal.dormpi.boot;
in {
  options.crystal.dormpi.boot.enable = lib.mkEnableOption "dormpi boot configuration" // {default = true;};

  config = lib.mkIf cfg.enable {
    boot = {
      kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
      initrd = {
        availableKernelModules = ["xhci_pci"];
      };
      extraModulePackages = with config.boot.kernelPackages; [
        rtw88
      ];
      kernelModules = ["rtw88"];
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
  };
}
