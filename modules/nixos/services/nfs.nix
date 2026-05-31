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
      type = lib.types.nullOr lib.types.str;
      description = "Local directory to export via NFS (bind-mounted to /export).";
      default = null;
    };
    exports = lib.mkOption {
      type = lib.types.lines;
      description = "Contents of /etc/exports.";
      default = "";
    };
  };
  config = lib.mkIf enabled {
    fileSystems = lib.mkIf (nfs.folder != null) {
      "/export" = {
        device = nfs.folder;
        options = ["bind"];
        fsType = "ext4";
      };
    };
    systemd.tmpfiles.rules = ["Z /export 0777 root root - -"];
    services.nfs.server = {
      inherit (nfs) exports;
      enable = true;
    };
  };
}
