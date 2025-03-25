{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };

    # "/mnt/main" = {
    #   device = "/dev/disk/by-uuid/...";
    #   fsType = "ext4";
    # };
    # "/mnt/bkup" = {
    #   device = "/dev/disk/by-uuid/...";
    #   fsType = "ext4";
    # };
  };
}
