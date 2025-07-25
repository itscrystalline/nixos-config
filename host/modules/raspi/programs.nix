{
  config,
  pkgs,
  secrets,
  ...
}: let
  backup-script = pkgs.writeShellScriptBin "backup" ''
    if [ "$EUID" -ne 0 ]
      then ${pkgs.coreutils}/bin/echo "Please run as root"
      exit 1
    fi

    MODE=$1
    COMPRESSION=${"\${2:-5}"}
    SOURCE=${"\${3:-/mnt/main}"}
    DEST=${"\${4:-/mnt/backup/backups}"}
    NAME=$MODE

    DATE=$(${pkgs.coreutils}/bin/date -I)

    case "$MODE" in
      full)
        ${pkgs.coreutils}/bin/rm "$DEST/snapshot.snar" || ${pkgs.coreutils}/bin/true
        ${pkgs.coreutils}/bin/rm "$DEST"/incremental-*.tar.zst || ${pkgs.coreutils}/bin/true
        ${pkgs.coreutils}/bin/echo 0 > "$DEST/size.prev"
        ;;

      incremental)
        ;;

      *)
        ${pkgs.coreutils}/bin/echo "Invalid mode specified. Choose from 'full' or 'incremental'."
        exit 1
        ;;
    esac

    FULL_NAME="$DEST/$NAME-$DATE"
    if ${pkgs.coreutils}/bin/ls "$FULL_NAME"*.tar.zst > /dev/null 2>$1; then
      latest_file=$(${pkgs.coreutils}/bin/ls -Art "$FULL_NAME"*.tar.zst | ${pkgs.coreutils}/bin/tail -n 1)
      current_number=$(${pkgs.coreutils}/bin/echo "$latest_file" | ${pkgs.gawk}/bin/awk '{ split($0,names,"."); split(names[1],name_split,"-"); print (name_split[5] == "" ? 0 : name_split[5])}')
      if [ "$current_number" = 0 ]; then
        ${pkgs.coreutils}/bin/mv "$FULL_NAME.tar.zst" "$FULL_NAME-1.tar.zst"
        ${pkgs.coreutils}/bin/echo "Moved $FULL_NAME.tar.zst to $FULL_NAME-1.tar.zst"
        new_number=2
      else
        new_number=$(($current_number + 1))
      fi
      FULL_NAME="$FULL_NAME-$new_number"
    fi
    FULL_NAME="$FULL_NAME.tar.zst"

    ${pkgs.coreutils}/bin/echo "Discovering size of $SOURCE... This may take some time."

    if [[ -s "$DEST/size.prev" ]]; then
      PREV_SIZE=$(<"$DEST/size.prev")
    else
      PREV_SIZE=0
    fi

    SIZE=$(${pkgs.coreutils}/bin/du -sb "$SOURCE" | ${pkgs.gawk}/bin/awk '{print $1}')
    ${pkgs.coreutils}/bin/echo "$SIZE" > "$DEST/size.prev"
    DELTA_SIZE=$(($SIZE - $PREV_SIZE))
    ${pkgs.coreutils}/bin/echo "Size of $SOURCE is $SIZE bytes."

    if [ "$PREV_SIZE" != 0 ] && [ "$DELTA_SIZE" -gt 0 ]; then
      ${pkgs.coreutils}/bin/echo "(only backing up an additional $DELTA_SIZE bytes.)"
    fi

    if [ "$DELTA_SIZE" -lt 0 ]; then
      PV_ARGS=""
    else
      PV_ARGS="-s $DELTA_SIZE"
    fi

    ${pkgs.coreutils}/bin/echo "Starting $MODE backup at $FULL_NAME"
    ${pkgs.coreutils}/bin/cp $DEST/snapshot.snar $DEST/snapshot.snar.bak

    ${pkgs.gnutar}/bin/tar --create --acls --xattrs --preserve-permissions --same-owner --listed-incremental="$DEST/snapshot.snar" -C "$SOURCE" . \
    | ${pkgs.pv}/bin/pv $PV_ARGS \
    | ${pkgs.zstd}/bin/zstd -T0 -"$COMPRESSION" \
    > "$FULL_NAME"
  '';
  restore-script = pkgs.writeShellScriptBin "restore" ''
    if [ "$EUID" -ne 0 ]
      then ${pkgs.coreutils}/bin/echo "Please run as root"
      exit
    fi

    DEST=${"\${1:-/mnt/main}"}
    shift
    SOURCES=(${"\${@}"})

    # timestamp sanity check
    LAST_TIMESTAMP=0
    LAST_FILE=""
    for FILE in "${"\${SOURCES[@]}"}"; do
      created=$(${pkgs.coreutils}/bin/stat -c%W "$FILE")
      if [ "$LAST_TIMESTAMP" -gt "$created" ]; then
        ${pkgs.coreutils}/bin/echo "WARNING: file $FILE is older than the previous file $LAST_FILE!"
        ${pkgs.coreutils}/bin/echo "WARNING:  This usually means the order of the arguments is off."
        read -r -p "WARNING:  Do you still want to continue in the original order? [y/N] " response
        response=${"\${response,,}"}
        if [[ ! "$response" =~ ^(yes|y)$ ]]; then
          exit 1
        fi
      fi
      LAST_TIMESTAMP="$created"
      LAST_FILE="$FILE"
    done

    for SRC in "${"\${SOURCES[@]}"}"; do
      ${pkgs.coreutils}/bin/echo "Restoring from $SRC into $DEST"
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
  '';
in {
  imports = [../common/programs.nix];

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    doas-sudo-shim

    backup-script
    restore-script
  ];

  # SMTP for Nextcloud
  programs.msmtp = with secrets.mail; {
    enable = true;
    accounts = {
      default = {
        auth = true;
        tls = true;
        # try setting `tls_starttls` to `false` if sendmail hangs
        user = username;
        password = password;
        host = "smtp.gmail.com";
        port = 587;
        from = "nc@iw2tryhard.dev";
      };
    };
  };
}
