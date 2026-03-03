{pkgs, ...}: {
  core = {
    name = "raine";
    primaryUser = "itscrystalline";

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
        options = ["noatime"];
      };

      "/mnt/main" = {
        device = "/dev/disk/by-uuid/a12bd288-6c9b-45f4-94ff-9cdbd1c474e6";
        fsType = "ext4";
        options = ["noatime" "nodiratime" "data=writeback" "commit=60" "barrier=1" "x-systemd.automount"];
      };
      "/mnt/backup" = {
        device = "/dev/disk/by-uuid/5F4E-AE27";
        fsType = "exfat";
        neededForBoot = false;
        options = ["nofail"];
      };
    };

    arch = "aarch64-linux";
    localization.timezone = "Asia/Bangkok";
  };

  compat = {
    nix-ld.enable = false;
    steam-run.enable = false;
  };

  programs.enable = true;
  theming.enable = true;

  crystals-services = {
    ssh.enable = true;
    tailscale.enable = true;
    earlyoom.enable = true;
    avahi.enable = true;
    localsend.enable = true;
    docker.enable = true;
  };

  nix = {
    nh.enable = true;
    keepGenerations = 3;
  };

  boot = {
    bootloader = "generic";
    stage1AvailableModules = [
      "xhci_pci"
      "usb_storage"
      "usbhid"
    ];
    verbosity = "verbose";
    network = true;
  };

  kernel = {
    package = pkgs.linuxKernel.packages.linux_rpi4;
    cmdline = ["psi=1"];
  };
}
