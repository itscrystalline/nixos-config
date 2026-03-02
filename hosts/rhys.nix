_: {
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
  gui.enable = true;
  theming.enable = true;

  crystals-services = {
    ssh.enable = true;
    tailscale.enable = true;
    earlyoom.enable = true;
    avahi.enable = true;
  };

  nix = {
    nh.enable = true;
    keepGenerations = 10;
  };
}
