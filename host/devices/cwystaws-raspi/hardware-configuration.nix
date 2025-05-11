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
    "/nix" = {
      device = "/dev/disk/by-label/NIX_STORE";
      fsType = "ext4";
      options = ["noatime"];
      neededForBoot = true;
    };
    "/mnt/backup" = {
      device = "/dev/disk/by-uuid/5F4E-AE27";
      fsType = "exfat";
      neededForBoot = false;
      options = ["nofail"];
    };

    "/export" = {
      device = "/mnt/main/nfs";
      options = ["bind"];
    };
    "/var/lib/prometheus2" = {
      device = "/mnt/main/services/prometheus2";
      options = ["bind"];
    };
  };

  systemd.tmpfiles.rules = [
    "Z /export 0777 - - - -"
  ];
}
