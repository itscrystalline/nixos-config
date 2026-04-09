{
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    ./jocelyn
  ];

  core = {
    name = "jocelyn";
    primaryUser = "itscrystalline";
    primaryUserSshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFsl6Q8ewf/4/GXNdOQTliXM8Njms8PwSQNjG0zgy/Cf itscrystalline@rhys"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB6BYLHO3EdqneIpmTsZxLE+EI1IAHOVlkPbdBRuci2J itscrystalline@mingzhu"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHr3s1d8yhjE+dcaqkXHJIXSAeMyEy72Bzc6eJmw9Eb itscrystalline@raine"
    ];

    # Managed by hosts/jocelyn/default.nix disko layout.
    fileSystems = {};
    stateVersion = "25.11";
    arch = "x86_64-linux";
    localization.timezone = "Asia/Bangkok";
  };

  programs.enable = true;

  crystals-services = {
    ssh.enable = true;
    tailscale = {
      enable = true;
      role = "server";
    };
    stalwart = {
      enable = true;
      host = "iw2tryhard.dev";
      webUIHost = "stalwart.crys";
    };
  };

  nix = {
    nh.enable = true;
    keepGenerations = 3;
  };

  # LTS
  kernel.package = pkgs.linuxPackages;
  boot = {
    bootloader = "grub";
    mountPoint = "/boot/efi";
    verbosity = "verbose";
  };
}
