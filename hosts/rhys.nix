{pkgs, ...}: let
  nixos_logo = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/logo/nixos-white.svg";
    sha256 = "sha256-Ly4jHvtxlnOe1CsZ5+f+K7pclUF4S0HS4Vgs5U8Ofl4=";
  };
in {
  imports = [./rhys];

  core = {
    name = "rhys";
    primaryUser = "itscrystalline";

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/ff2bb3c4-78d4-4d76-a510-9346bf4f70e1";
        fsType = "ext4";
      };
      "/boot" = {
        device = "/dev/disk/by-uuid/6893-3C2F";
        fsType = "vfat";
        options = ["fmask=0077" "dmask=0077"];
      };
      "/home" = {
        device = "/dev/disk/by-uuid/59218eea-5fa5-4783-ac86-6f02bcab06e8";
        fsType = "ext4";
      };
    };

    arch = "x86_64-linux";
    localization.timezone = "Asia/Bangkok";
  };

  compat = {
    nix-ld.enable = true;
    steam-run.enable = true;
  };

  programs.enable = true;
  gui = {
    enable = true;
    steam.enable = true;
    flatpak.enable = true;
    obs.enable = true;
    niri.enable = true;
    graphics.prime = {
      enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  theming.enable = true;
  bluetooth.enable = true;

  network = {
    mounts = [
      {
        type = "nfs";
        remote = "100.125.37.13:/export";
        mountPoint = "/mnt/nfs";
        automount = true;
      }
    ];
    trustedInterfaces = ["p2p-wl+"];
    dhcp = true;
    # KDE connect
    ports = rec {
      tcp = [7236 7250 8475 3000];
      udp = tcp;
      tcpRange = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      udpRange = tcpRange;
    };
    profiles = ["KMITL-HiSpeed" "cwystaw the neko :3 ^w^" "dormpi" "santhad" "santhad_5G"];
  };

  crystals-services = {
    ssh.enable = true;
    tailscale.enable = true;
    avahi.enable = true;
    localsend.enable = true;
    docker.enable = true;
    pipewire.enable = true;
    printing.enable = true;
    pm.enable = true;
  };

  nix = {
    nh.enable = true;
    keepGenerations = 5;
  };

  boot = {
    bootloader = "systemd-boot";
    stage1AvailableModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usb_storage"
      "sd_mod"
    ];
    verbosity.plymouth = {
      theme = "blahaj";
      package = pkgs.plymouth-blahaj-theme.overrideAttrs {
        patchPhase = ''
          runHook prePatch

          shopt -s extglob

          # deal with all the non ascii stuff
          mv !(*([[:graph:]])) blahaj.plymouth
          sed -i 's/\xc3\xa5/a/g' blahaj.plymouth
          sed -i 's/\xc3\x85/A/g' blahaj.plymouth

          # colors!
          sed -i 's/0x000000/0x11111b/g' blahaj.plymouth

          # watermark
          ${pkgs.inkscape}/bin/inkscape --export-height=48 --export-type=png --export-filename="watermark.png" ${nixos_logo}

          runHook postPatch
        '';
      };
    };
  };

  kernel = {
    package = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v4;
    stage2Modules = ["kvm-intel"];
    emulatedArchitectures = ["aarch64-linux"];
    supportedFilesystems = ["ntfs" "nfs"];
    sysctl."kernel.sysrq" = 1;
    hibernate = {
      enable = true;
      device = "/dev/nvme1n1p1";
    };
  };
}
