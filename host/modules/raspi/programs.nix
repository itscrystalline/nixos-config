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
      if [ "$EUID" -ne 0 ]
        then echo "Please run as root"
        exit 1
      fi

      MODE=$1
      SOURCE=${"\${2:-/mnt/main}"}
      DEST=${"\${3:-/mnt/backup/backups}"}
      NAME=$MODE

      DATE=$(${pkgs.coreutils}/bin/date -I)

      case "$MODE" in
        full)
          echo "Starting full backup at $DEST/$NAME-$DATE.tar"
          rm "$DEST/snapshot.snar" || true
          rm "$DEST"/incremental-*.tar || true
          ;;

        incremental)
          echo "Starting incremental backup at $DEST/$NAME-$DATE.tar"
          ;;

        *)
          echo "Invalid mode specified. Choose from `full` or `incremental`."
          exit 1
          ;;
      esac

      if [ -f $DEST ]; then
        read -r -p "Backup at $DEST aleady exists! overwrite? [y/N] " response
        response=${"\${response,,}"}
        if [[ ! "$response" =~ ^(yes|y)$ ]]
          exit
        fi
      fi


      echo "Discovering size of $SOURCE... This may take some time."
      SIZE=$(${pkgs.coreutils}/bin/du -sb "$SOURCE" | ${pkgs.coreutils}/bin/awk '{print $1}')
      echo "Size of $SOURCE is $SIZE bytes."

      ${pkgs.gnutar}/bin/tar --create --acls --xattrs --preserve-permissions --same-owner --listed-incremental="$DEST/snapshot.snar" -C "$SOURCE" . \
      | ${pkgs.pv}/bin/pv -s "$SIZE" \
      | ${pkgs.zstd}/bin/zstd -T0 -19 \
      > "$DEST/$NAME-$DATE.tar.zst"
    '')
    (pkgs.writeShellScriptBin "restore" ''
      if [ "$EUID" -ne 0 ]
        then echo "Please run as root"
        exit
      fi

      DEST=${"\${1:-/mnt/main}"}
      shift
      SOURCES=(${"\${@}"})

      for SRC in "''${SOURCES[@]}"}"; do
        echo "Restoring from $SRC into $DEST"
        SIZE=$(${pkgs.coreutils}/bin/stat -c%s "$SRC")

        if [[ "$SRC" == *.tar.zst ]]; then
          ${pkgs.pv}/bin/pv -s "$SIZE" "$SRC" \
          | ${pkgs.zstd}/bin/zstd -d --stdout \
          | ${pkgs.gnutar}/bin/tar \
              --directory="$DEST" \
              --extract \
              --verbose \
              --acls \
              --xattrs \
              --preserve-permissions \
              --same-owner \
              --listed-incremental=/dev/null
        else
          ${pkgs.pv}/bin/pv -s "$SIZE" "$SRC" \
          | ${pkgs.gnutar}/bin/tar \
              --directory="$DEST" \
              --extract \
              --verbose \
              --acls \
              --xattrs \
              --preserve-permissions \
              --same-owner \
              --listed-incremental=/dev/null
        fi
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
