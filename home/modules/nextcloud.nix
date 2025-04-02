{
  config,
  pkgs,
  ...
} @ inputs: let
  nc_user = builtins.readFile ../../secrets/nc_user;
  nc_pass_obscured = builtins.readFile ../../secrets/nc_user_password;
in {
  xdg.configFile = pkgs.lib.mkIf config.gui {
    "rclone/nextcloud.conf".text = ''
      [nextcloud]
      type = webdav
      url = https://nc.iw2tryhard.dev/remote.php/dav/files/${nc_user}
      vendor = nextcloud
      user = ${nc_user}
      pass = ${nc_pass_obscured}
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
}
