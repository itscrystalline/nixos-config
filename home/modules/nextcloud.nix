{
  config,
  pkgs,
  lib,
  secrets,
  ...
} @ inputs:
with secrets.nextcloud.rclone; let
  cfg = config.crystal.hm.nextcloud;
in {
  options.crystal.hm.nextcloud.enable = lib.mkEnableOption "Nextcloud integration" // {default = true;};
  config = lib.mkIf cfg.enable {
  xdg.configFile = pkgs.lib.mkIf config.gui {
    "rclone/nextcloud.conf".text = ''
      [nextcloud]
      type = webdav
      url = https://nc.iw2tryhard.dev/remote.php/dav/files/${user}
      vendor = nextcloud
      user = ${user}
      pass = ${password}
    '';
  };

  systemd.user.services.nextcloud-mount = pkgs.lib.mkIf config.gui {
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
