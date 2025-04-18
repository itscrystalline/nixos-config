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

    (pkgs.writeShellScriptBin "backup" ''
      set -x
      if [ "$EUID" -ne 0 ]
        then echo "Please run as root"
        exit
      fi

      MODE=$1
      SOURCE=${"\${2:-/mnt/main}"}
      DEST=${"\${3:-/mnt/backup/backups}"}
      NAME=$MODE

      case $MODE in
        full)
          echo "Starting full backup at $DEST/$NAME-$(${pkgs.coreutils}/bin/date -I).tar"
          rm $DEST/snapshot.snar || true
          rm $DEST/incremental-*.tar || true
          ;;

        incremental)
          echo "Starting incremental backup at $DEST/$NAME-$(${pkgs.coreutils}/bin/date -I).tar"
          ;;

        *)
          echo "Invalid mode specified. Choose from `full` or `incremental`."
          exit
          ;;
      esac

      ${pkgs.gnutar}/bin/tar --create --acls --xattrs --preserve-permissions --same-owner --listed-incremental=$DEST/snapshot.snar -C $SOURCE . | ${pkgs.pv}/bin/pv > $DEST/$NAME-$(${pkgs.coreutils}/bin/date -I).tar
    '')
    (pkgs.writeShellScriptBin "restore" ''
      set -x
      if [ "$EUID" -ne 0 ]
        then echo "Please run as root"
        exit
      fi

      DEST=${"\${1:-/mnt/main}"}
      SOURCES=(${"\${@:2}"})

      for SRC in $SOURCES; do
        ${pkgs.pv}/bin/pv $SRC | ${pkgs.gnutar}/bin/tar --directory=$DEST --extract --verbose --acls --xattrs --preserve-permissions --same-owner --listed-incremental=/dev/null
      done
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
