{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.hm) nextcloud;
  enabled = nextcloud.enable;
in {
  options.hm.nextcloud.enable = lib.mkEnableOption "Nextcloud integration";

  config = lib.mkIf enabled {
    xdg.configFile = lib.mkIf config.hm.gui.enable {
      "rclone/nextcloud.conf".text = with config.secrets.nextcloud.rclone; ''
        [nextcloud]
        type = webdav
        url = https://nc.iw2tryhard.dev/remote.php/dav/files/${user}
        vendor = nextcloud
        user = ${user}
        pass = ${password}
      '';
    };

    systemd.user.services.nextcloud-mount = lib.mkIf config.hm.gui.enable {
      Unit = {
        Description = "Mounts My Nextcloud as a local directory.";
        After = ["network-online.target"];
      };
      Service = {
        Type = "notify";
        ExecStart = "${pkgs.rclone}/bin/rclone --config=%h/.config/rclone/nextcloud.conf --vfs-cache-mode writes --ignore-checksum mount \"nextcloud:\" \"Nextcloud\"";
        ExecStop = "/bin/fusermount -u %h/Nextcloud/%i";
        Restart = "always";
      };
      Install.WantedBy = ["default.target"];
    };
  };
}
