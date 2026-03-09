{
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    ./mingzhu
  ];

  core = {
    name = "mingzhu";
    primaryUser = "itscrystalline";
    primaryUserSshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIKZWDmuQuPaShyj0ZxEhIAyrw8KOgFq7rqYHVgyV6yQ itscrystalline@rhys"
    ];

    fileSystems = {
      "/" = {
        device = "/dev/sda1";
        fsType = "ext4";
        options = ["noatime"];
      };
      "/boot/efi" = {
        device = "/dev/disk/by-uuid/F8E6-38E1";
        fsType = "vfat";
      };
      "/boot" = {
        device = "/dev/disk/by-uuid/71551c63-1196-417c-b4ce-2898a9c58004";
        fsType = "ext4";
      };
    };

    stateVersion = "25.11";
    arch = "aarch64-linux";
    localization.timezone = "Asia/Bangkok";
  };

  programs.enable = true;
  gui.enable = false;
  theming.enable = true;

  crystals-services = {
    docker.enable = true;
    ssh.enable = true;
    tailscale.enable = true;
  };

  nix = {
    nh.enable = true;
    keepGenerations = 5;
  };

  kernel.package = pkgs.linuxKernel.packages.linux_6_12;
  boot = {
    bootloader = "grub";
    mountPoint = "/boot/efi";
    stage1AvailableModules = ["ata_piix" "uhci_hcd" "xen_blkfront"];
    stage1Modules = ["nvme"];
  };
}
