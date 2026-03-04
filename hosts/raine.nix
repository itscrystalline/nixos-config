{pkgs, config, ...}: {
  imports = [./raine];

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

  network = {
    trustedInterfaces = [];
    ports = {
      tcp = [80 443 2049 8080];
      udp = [];
      tcpRange = [];
      udpRange = [];
    };
  };

  crystals-services = {
    ssh.enable = true;
    tailscale.enable = true;
    earlyoom.enable = true;
    avahi.enable = true;
    docker.enable = true;
    printing = {
      enable = true;
      drivers = [pkgs.gutenprint];
      openFirewall = true;
      shared = true;
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
      nginxVhost = "scan.crys";
    };
    nginx.enable = true;
    blocky.enable = true;
    cloudflared.enable = true;
    nextcloud = {
      enable = true;
      domain = "nc.iw2tryhard.dev";
      folder = "/mnt/main/nextcloud";
      adminpassFile = config.secrets.nextcloud.admin.password;
      statsToken = config.secrets.nextcloud.admin.stats_token;
    };
    monitoring.enable = true;
    manga.enable = true;
    ncps.enable = true;
    iw2tryhard-dev.enable = true;
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
