{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.hm.services) nextcloud;
  enabled = nextcloud.enable;
in {
  options.hm.services.nextcloud.enable = lib.mkEnableOption "Nextcloud integration";

  config = lib.mkIf enabled {
    sops = {
      secrets."nextcloud-rclone-password".restartUnits = ["nextcloud-mount.service"];
      templates."nextcloud-mount.conf".content = ''
        [nextcloud]
        type = webdav
        url = https://nc.iw2tryhard.dev/remote.php/dav/files/itscrystalline
        vendor = nextcloud
        user = itscrystalline
        pass = ${config.sops.placeholder."nextcloud-rclone-password"}
      '';
    };

    systemd.user.services.nextcloud-mount = {
      Unit = {
        Description = "Mounts My Nextcloud as a local directory.";
        After = ["network-online.target" "sops-nix.service"];
      };
      Service = {
        Type = "notify";
        ExecStart = "${pkgs.rclone}/bin/rclone --config=${config.sops.templates."nextcloud-mount.conf".path} --vfs-cache-mode writes --ignore-checksum mount \"nextcloud:\" \"Nextcloud\"";
        ExecStop = "/bin/fusermount -u %h/Nextcloud/%i";
        Restart = "always";
      };
      Install.WantedBy = ["default.target"];
    };
  };
}
