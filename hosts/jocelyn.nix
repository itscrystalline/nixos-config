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
    nginx.enable = true;
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

  network.dhcp = false;

  nix = {
    nh = {
      enable = true;
      keepSince = "1d"; # more agressive gcing in think, 30gb is nowhere near enough for ts
      dates = "daily";
    };
    keepGenerations = 3;
    autoUpdate.enable = true;

    asBuilderConfig = {
      user = "nixremote";
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPMzemcNoFavKSsUfBkk1FzgQWlYN3lLFPZaHGByjc6L nix-daemon@mingzhu"
      ];
      systems = ["x86_64-linux"];
      maxJobs = 1;
      speedFactor = 1;
    };
  };

  # LTS
  kernel.package = pkgs.linuxPackages;
  boot = {
    bootloader = "grub";
    mountPoint = "/boot/efi";
    verbosity = "verbose";
  };
}
