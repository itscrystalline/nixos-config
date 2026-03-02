_: {
  core = {
    name = "liriel";
    primaryUser = "itscrystalline";

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
        options = ["noatime"];
      };
    };

    arch = "aarch64-linux";
    localization.timezone = "Asia/Bangkok";
  };

  programs.enable = true;

  crystals-services = {
    ssh.enable = true;
    tailscale.enable = true;
    earlyoom.enable = true;
  };

  nix = {
    nh.enable = true;
    keepGenerations = 3;
  };
}
