{pkgs, ...}: {
  imports = [./liriel];

  core = {
    name = "liriel";
    primaryUser = "itscrystalline";

    fileSystems."/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };

    arch = "aarch64-linux";
    localization = {
      timezone = "Asia/Bangkok";
      keymap = "colemak";
      locale = "en_US.UTF-8";
    };
  };

  programs.enable = true;

  crystals-services = {
    ssh.enable = true;
    tailscale.enable = true;
    earlyoom.enable = true;
    avahi.enable = true;
    argonone.enable = true;
    home-assistant.enable = true;
    create-ap.enable = true;
  };

  nix = {
    nh.enable = true;
    keepGenerations = 3;
  };

  boot = {
    bootloader = "generic";
    stage1AvailableModules = ["xhci_pci"];
    verbosity = "verbose";
    network = true;
  };

  kernel = rec {
    package = pkgs.linuxKernel.packages.linux_rpi4;
    stage2Modules = ["rtw88"];
    stage2ModulePackages = package.rtw88;
    cmdline = [
      "psi=1"
      "brcmfmac.roamoff=1"
      "brcmfmac.feature_disable=0x282000"
    ];
  };
}
