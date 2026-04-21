{
  lib,
  config,
  ...
}: let
  inherit (config.crystals-services) nfs;
  enabled = nfs.enable;
in {
  options.crystals-services.nfs = {
    enable = lib.mkEnableOption "NFS server";
    folder = lib.mkOption {
      type = lib.types.str;
      description = "Local directory to export via NFS (bind-mounted to /export).";
      default = "/mnt/main/nfs";
    };
    exports = lib.mkOption {
      type = lib.types.lines;
      description = "Contents of /etc/exports.";
      default = "";
    };
  };
  config = lib.mkIf enabled {
    fileSystems."/export" = {
      device = nfs.folder;
      options = ["bind" "x-systemd.requires-mounts-for=/mnt/main"];
    };
    systemd.tmpfiles.rules = ["Z ${nfs.folder} 0777 root root - -"];
    services.nfs.server = {
      inherit (nfs) exports;
      enable = true;
    };
  };
}
