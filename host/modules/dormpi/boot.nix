{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd = {
      availableKernelModules = ["xhci_pci"];
      # network = {
      #   enable = true;
      #   ssh = {
      #     enable = true;
      #     authorizedKeys = [
      #       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPS4b7HxJiG6gAOvqw/fD5CKWP3HqOFdfi2zpwmPi4wu itscrystalline@cwystaws-meowchine"
      #     ];
      #   };
      # };
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
