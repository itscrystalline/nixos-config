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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAU/Pgn8WjdTrA5aW0GaPv/6aZmxLnmmOyldnbCZZCZR itscrystalline@raine"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB0+RVmo0ate9/OQoQTLlB2WxIf6u3x605g4a/GFYVfb itscrystalline@liriel"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILGXOcduQxgwKleQ8Nfe5JKjP/SuWGIOOLIbFdC4Vfwz itscrystalline@localhost"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILGgb+d/WJ4BqfwvitpVebIY31XyLIj2n6fL9+MOWVMo termius-mingzhu"
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
    tailscale = {
      enable = true;
      asExitNode = true;
      role = "server";
    };
    nix-binary-cache = {
      enable = true;
      nixCaches = "system";
      openTelemetryGrpcUrl = "http://100.125.37.13:4317";
    };
    nginx.enable = true;
    blocky = {
      enable = true;
      listenAddress = "100.95.62.30";
      denyList = ''
        ocsp.apple.com
        ocsp2.apple.com
        valid.apple.com
        crl.apple.com
        certs.apple.com
        appattest.apple.com
        vpp.itunes.apple.com
      '';
      allowList = ''
        t.co
        urbandictionary.com
        telegra.ph
        s.youtube.com
        pantip.com$important
        app.localhost.direct
        register.appattest.apple.com

        chatgpt.com
        claude.ai
        ai.google
        deepseek.com
        www.chatgpt.com
        www.claude.ai
        www.ai.google
        www.deepseek.com
      '';
      customDNS = {
        "dorm" = "100.122.114.13"; # liriel
        "cache" = "100.95.62.30"; # mingzhu
        "" = "100.125.37.13"; # raine
      };
    };
  };

  nix = {
    nh.enable = true;
    keepGenerations = 2;

    autoUpdate = {
      enable = true;
      type = "self";
    };

    asBuilderConfig = {
      user = "nixremote";
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKmCgHeKY5eCVXX1pSXWmc9x7i2Cfnt6qo+vpw4SsSmb nix-daemon@raine"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPNm1+bZZ29m4kzKL2goSmrb8ylsrC+FkwVvI4fS8U5M nix-daemon@liriel"
      ];
      systems = ["aarch64-linux"];
      maxJobs = 4;
      speedFactor = 2;
    };
  };

  kernel.package = pkgs.linuxKernel.packages.linux_6_12;
  boot = {
    bootloader = "grub";
    mountPoint = "/boot/efi";
    stage1AvailableModules = ["ata_piix" "uhci_hcd" "xen_blkfront"];
    stage1Modules = ["nvme"];
  };
}
