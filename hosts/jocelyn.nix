{pkgs, ...}: {
  imports = [./jocelyn];

  core = {
    name = "jocelyn";
    primaryUser = "itscrystalline";
    primaryUserSshKeys = [
      ""
      ""
      ""
    ];

    # Managed by hosts/jocelyn/default.nix disko layout.
    fileSystems = {};

    arch = "x86_64-linux";
    localization = {
      timezone = "Asia/Bangkok";
      locale = "en_US.UTF-8";
    };
  };

  programs.enable = true;

  crystals-services = {
    ssh.enable = true;
    tailscale = {
      enable = true;
      role = "server";
    };
    stalwart.enable = true;
  };

  nix = {
    nh.enable = true;
    keepGenerations = 3;
  };

  boot = {
    bootloader = "systemd-boot";
    mountPoint = "/boot";
    stage1AvailableModules = ["ahci" "nvme" "xhci_pci" "usbhid" "sd_mod"];
    verbosity = "verbose";
  };

  kernel.package = pkgs.linuxPackages;
}
