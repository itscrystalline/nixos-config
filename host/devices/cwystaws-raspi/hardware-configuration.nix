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

    "/mnt/main" = {
      device = "/dev/disk/by-uuid/a12bd288-6c9b-45f4-94ff-9cdbd1c474e6";
      fsType = "ext4";
      options = ["noatime" "nodiratime" "data=writeback" "commit=60" "barrier=1"];
    };
    # "/mnt/bkup" = {
    #   device = "/dev/disk/by-uuid/...";
    #   fsType = "ext4";
    # };
  };
}
