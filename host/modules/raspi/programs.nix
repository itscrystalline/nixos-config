{
  config,
  pkgs,
  secrets,
  ...
}: {
  imports = [../common/programs.nix];

  environment.systemPackages = with pkgs; [
    libraspberrypi
    doas-sudo-shim

    (pkgs.writeShellScriptBin "backup-full" ''
      set -x
      if [ "$EUID" -ne 0 ]
        then echo "Please run as root"
        exit
      fi

      rm /mnt/backup/backups/snapshot.snar || true
      rm /mnt/backup/backups/incremental-*.tar || true
      ${pkgs.gnutar}/bin/tar --verbose --create --acls --xattrs --preserve-permissions --same-owner --file=/mnt/backup/backups/full-$(${pkgs.coreutils}/bin/date -I).tar --listed-incrementals=/mnt/backup/backups/snapshot.snar /mnt/main
    '')
    (pkgs.writeShellScriptBin "backup-incremental" ''
      set -x
      if [ "$EUID" -ne 0 ]
        then echo "Please run as root"
        exit
      fi

      ${pkgs.gnutar}/bin/tar --verbose --create --acls --xattrs --preserve-permissions --same-owner --file=/mnt/backup/backups/incremental-$(${pkgs.coreutils}/bin/date -I).tar --listed-incrementals=/mnt/backup/backups/snapshot.snar /mnt/main
    '')
  ];

  # SMTP for Nextcloud
  programs.msmtp = with secrets.mailjet; {
    enable = true;
    accounts = {
      default = {
        auth = true;
        tls = true;
        # try setting `tls_starttls` to `false` if sendmail hangs
        user = api_key;
        password = secret_key;
        host = "in-v3.mailjet.com";
        port = 587;
        from = "nc@iw2tryhard.dev";
      };
    };
  };
}
