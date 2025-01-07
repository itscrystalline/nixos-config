{ config, pkgs, ... }@inputs:
let
  nc_pass = builtins.readFile ./nc_password.txt;
in {
  xdg.configFile."rclone/nextcloud.conf".text = ''
    [nextcloud]
    type = webdav
    url = https://nc.iw2tryhard.dev/remote.php/dav/files/crystal
    vendor = nextcloud
    user = crystal
    pass = ${nc_pass}
  '';

  systemd.user.services.nextcloud-mount = {
    Unit = {
      Description = "Mounts My Nextcloud as a local directory.";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "notify";
      ExecStart = "${pkgs.rclone}/bin/rclone --config=%h/.config/rclone/nextcloud.conf --vfs-cache-mode writes --ignore-checksum mount \"nextcloud:\" \"Nextcloud\"";
      ExecStop="/bin/fusermount -u %h/Nextcloud/%i";
      Restart = "always";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
