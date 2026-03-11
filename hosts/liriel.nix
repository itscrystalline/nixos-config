{pkgs, ...}: {
  imports = [./liriel];

  core = {
    name = "liriel";
    primaryUser = "itscrystalline";
    primaryUserSshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCKOMNkZ20mVlrINueEM6KslqFD0v6O5XYJ/f4vXpiz itscrystalline@rhys"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBQLcwyfwq2dROIanu5aXfWT1x6RQS/ABlZ413zHkkdS itscrystalline@raine"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOhfMp9LootBT3sWMV6/LZLXt3UCJC8jC6POHo6Rpsqn itscrystalline@mingzhu"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICpy90J0VEWL/3J2jsnp8ovItviiRtoHVxUhSMM+f4xC termius-liriel"
    ];

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
  hardware.raspberrypi.enable = true;

  network = {
    dhcp = true;
    profiles = ["KMITL-HiSpeed"];
  };

  crystals-services = {
    ssh.enable = true;
    tailscale = {
      enable = true;
      role = "server";
    };
    earlyoom.enable = true;
    avahi.enable = true;
    argonone.enable = true;
    home-assistant.enable = true;
    create-ap = {
      enable = true;
      dhcpLocks = [
        {
          mac = "cc:40:85:b3:c9:a4";
          ip = "192.168.12.136";
          hostname = "desk-light";
        }
        {
          mac = "3c:6a:d2:be:4e:57";
          ip = "192.168.12.216";
          hostname = "kettle-switch";
        }
        {
          mac = "bc:07:1d:c4:0c:63";
          ip = "192.168.12.10";
          hostname = "fan-switch";
        }
      ];
    };
  };

  nix = {
    nh.enable = true;
    keepGenerations = 3;

    remoteBuilders = [
      {
        hostName = "mingzhu";
        user = "nixremote";
        sshKey = "/etc/nix/builder-key";
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
      remoteUpdaterHost = "mingzhu";
    };
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
    stage2ModulePackages = [package.rtw88];
    cmdline = [
      "psi=1"
      "brcmfmac.roamoff=1"
      "brcmfmac.feature_disable=0x282000"
    ];
  };
}
