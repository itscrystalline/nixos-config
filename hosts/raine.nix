{
  pkgs,
  lib,
  config,
  ...
}: let
  sopsPath = name: config.sops.secrets.${name}.path;
in {
  imports = [./raine];

  core = {
    name = "raine";
    primaryUser = "itscrystalline";
    primaryUserSshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPS4b7HxJiG6gAOvqw/fD5CKWP3HqOFdfi2zpwmPi4wu itscrystalline@rhys"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFgYlL76SlT57GHQ+LzpPzQWDZALVi8SnqsWH8qNGFTW itscrystalline@liriel"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRUiQaNLor3ymnrHft6Yk8PZT3df0Cdb5J5h3QLtnTl itscrystalline@mingzhu"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINJmlnY6dBpJHo+tRXSfQ+xrOZCRC91h4OVj/vUDCExu termius-raine"
    ];

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
      "/var/lib/prometheus2" = {
        device = "/mnt/main/services/prometheus2";
        options = ["bind" "x-systemd.requires-mounts-for=/mnt/main"];
      };
    };

    arch = "aarch64-linux";
    localization.timezone = "Asia/Bangkok";
  };

  programs.enable = true;
  theming.enable = true;
  hardware.raspberrypi.enable = true;

  network = {
    trustedInterfaces = [];
    ports.tcp = [2049 8080];
    profiles = ["santhad" "santhad_5G"];
  };

  crystals-services = {
    ssh.enable = true;
    tailscale = {
      enable = true;
      asExitNode = true;
      role = "server";
    };
    earlyoom.enable = true;
    avahi.enable = true;
    docker.enable = true;
    printing = {
      enable = true;
      drivers = [pkgs.gutenprint];
      openFirewall = true;
      shared = true;
      printers = [
        {
          name = "Canon_G2010_Series";
          location = "Home";
          deviceUri = "usb://Canon/G2010%20series?serial=0FEC28&interface=1";
          model = "gutenprint.${lib.versions.majorMinor (lib.getVersion pkgs.gutenprint)}://bjc-G2000-series/expert";
          ppdOptions.PageSize = "A4";
        }
      ];
      defaultPrinter = "Canon_G2010_Series";
    };
    argonone.enable = true;
    nfs = {
      enable = true;
      exports = ''
        /export 192.168.1.0/24(rw,sync,no_subtree_check) 100.0.0.0/8(rw,sync,no_subtree_check)
      '';
    };
    scanservjs = {
      enable = true;
      nginxVhost = "scan";
    };
    nginx.enable = true;
    blocky.enable = false;

    cloudflared.enable = true;
    nextcloud = {
      enable = true;
      domain = "nc";
      folder = "/mnt/main/nextcloud";
      adminpassFile = sopsPath "nextcloud-admin-password";
      statsTokenFile = sopsPath "nextcloud-admin-stats-token";
    };
    monitoring = {
      enable = true;
      enableOpenTelemetryCollector = true;
    };
    manga.enable = true;
    iw2tryhard-dev.enable = true;

    forgejo = {
      enable = true;
      sync.enable = true;
      directory = "/mnt/main/services/forgejo";
    };

    copyparty = {
      enable = true;
      volumes = {
        "/" = {
          path = "/mnt/main/nfs";
          read = "itscrystalline";
          read-write = "itscrystalline";
        };
        "/public" = {
          path = "/mnt/main/nfs/public";
          read-write = "itscrystalline";
        };
      };
    };
  };

  nix = {
    nh.enable = true;
    keepGenerations = 3;

    remoteBuilders = [
      {
        hostName = "mingzhu";
        user = "nixremote";
        hostPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOdZ5SCnebaW69b4xDaeGnyaV0as6UF+0C881rIYCFGU root@main";
        systems = ["aarch64-linux"];
        maxJobs = 4;
        speedFactor = 2;
        supportedFeatures = ["nixos-test" "big-parallel" "kvm"];
      }
    ];

    autoUpdate = {
      enable = true;
      type = "remote";
      dates = "*-*-1..31/3 18:00:00"; # every 3rd day instead
      remoteUpdaterHost = "mingzhu";
    };
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
