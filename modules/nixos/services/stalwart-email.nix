{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.crystals-services) stalwart;
  enabled = stalwart.enable;
in {
  options.crystals-services.stalwart = {
    enable = lib.mkEnableOption "stalwart mail server";

    directory = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/stalwart-mail";
      description = "Directory to store stalwart data";
    };

    webUIHost = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "Nginx virtual host name to proxy stalwart web UI under. Null to disable.";
      default = null;
    };

    mailboxes = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          password = lib.mkOption {
            type = lib.types.str;
            description = "Path to sops secret containing password";
          };
          aliases = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "List of email aliases for this mailbox";
          };
        };
      });
      default = {};
      description = "Mailbox configuration";
      example = lib.literalExpression ''
        {
          "user01@example.dev" = {
            password = config.sops.secrets.stalwart-user01-password.path;
            aliases = [];
          };
          "main@example.dev" = {
            password = config.sops.secrets.stalwart-main-password.path;
            aliases = [ "alias1@example.dev" "alias2@example.dev" ];
          };
        }
      '';
    };
  };

  config = lib.mkIf enabled {
    services.stalwart = {
      enable = true;
      dataDir = stalwart.directory;
      openFirewall = true;

      credentials = {
        admin_pass = config.sops.secrets.stalwart-admin-password.path;
        cloudflare_token = config.sops.secrets.stalwart-cloudflare-token.path;
      };

      settings = {
        server = {
          hostname = "iw2tryhard.dev";

          listener = {
            smtp = {
              # 25 public (receive) - STARTTLS
              bind = ["0.0.0.0:25"];
              protocol = "smtp";
            };
            submission = {
              # 587 - STARTTLS (raine uses this via tailscale)
              bind = ["0.0.0.0:587"];
              protocol = "smtp";
            };
            submissions = {
              # 465 - implicit TLS (preferred, raine should migrate to this)
              bind = ["0.0.0.0:465"];
              protocol = "smtp";
              tls.implicit = true;
            };
            imap = {
              # 143 - STARTTLS (local access)
              bind = ["127.0.0.1:143"];
              protocol = "imap";
            };
            imaps = {
              # 993 - implicit TLS
              bind = ["0.0.0.0:993"];
              protocol = "imap";
              tls.implicit = true;
            };
            http = {
              bind = ["127.0.0.1:8080"];
              protocol = "http";
            };
          };

          tls.enable = true;
        };

        # ACME config for let's encrypt with cloudflare dns-01
        acme."letsencrypt" = {
          directory = "https://acme-v02.api.letsencrypt.org/directory";
          challenge = "dns-01";
          contact = "real@iw2tryhard.dev";
          domains = ["iw2tryhard.dev"];
          provider = "cloudflare";
          secret = "%{file:/run/credentials/stalwart-mail.service/cloudflare_token}%";
        };

        # local user directory
        directory.local = {
          type = "internal";
          store = "data";
        };

        # admin fallback auth
        authentication.fallback-admin = {
          user = "admin";
          secret = "%{file:/run/credentials/stalwart-mail.service/admin_pass}%";
        };

        # storage - rocksdb ftw
        storage = {
          data = {
            type = "rocksdb";
            path = "${stalwart.directory}/data";
          };
          blob = {
            type = "rocksdb";
            path = "${stalwart.directory}/blob";
          };
        };

        # auth: smtp (25) no auth for receiving, submission (587) requires auth
        session = {
          rcpt.relay = false;
          ehlo.require = true;
        };

        session.smtp.auth.require = false;
        session.submission.auth.require = true;

        # basic dkim - stalwart auto-generates keys
        signature.default = {
          domain = "iw2tryhard.dev";
          selector = "default";
          algorithm = "rsa-sha256";
        };

        # queue
        queue.path = "${stalwart.directory}/queue";
      };
    };

    # ensure storage mount is ready if directory is under /mnt/main
    systemd.services.stalwart = lib.mkIf (lib.hasPrefix "/mnt/main" stalwart.directory) {
      requires = ["mnt-main.mount"];
    };

    # create mailboxes and aliases after service starts
    systemd.services.stalwart-setup-user = lib.mkIf (stalwart.mailboxes != {}) {
      wantedBy = ["multi-user.target"];
      after = ["stalwart-mail.service" "sops-install-secrets.service"];
      requires = ["stalwart-mail.service" "sops-install-secrets.service"];

      script = let
        # generate bash associative arrays for mailboxes and aliases
        mailboxEntries = lib.concatStringsSep "\n  " (
          lib.mapAttrsToList (email: box: "[\"${email}\"]=\"${box.password}\"") stalwart.mailboxes
        );

        # generate per-mailbox alias setup commands
        aliasSetup = lib.concatStringsSep "\n\n" (
          lib.mapAttrsToList (email: box: ''
            ${lib.optionalString (box.aliases != []) ''
              # add aliases for ${email}
              EMAILS="[\"${email}\""
              ${lib.concatMapStringsSep "\n" (alias: "EMAILS=\"$EMAILS,\\\"${alias}\\\"\"") box.aliases}
              EMAILS="$EMAILS]"

              ${lib.getExe pkgs.curl} -X PUT \
                -u "admin:$ADMIN_PASS" \
                -H "Content-Type: application/json" \
                http://127.0.0.1:8080/api/principal/${email} \
                -d "{
                  \"type\": \"individual\",
                  \"emails\": $EMAILS
                }" \
                || echo "Failed to add aliases for ${email} (might already exist)"
            ''}
          '')
          stalwart.mailboxes
        );
      in ''
        # wait for stalwart http to be actually ready (not just systemd "started")
        for i in {1..30}; do
          if ${config.services.stalwart.package}/bin/stalwart-cli \
             -u http://127.0.0.1:8080 \
             --credentials admin:$(cat ${config.sops.secrets.stalwart-admin-password.path}) \
             server status &>/dev/null; then
            break
          fi
          echo "Waiting for stalwart http... ($i/30)"
          sleep 1
        done

        ADMIN_PASS=$(cat ${config.sops.secrets.stalwart-admin-password.path})

        # declare associative array for mailbox -> password mapping
        declare -A MAILBOX_PASSWORDS
        ${mailboxEntries}

        # create all mailboxes (idempotent)
        for mailbox in "''${!MAILBOX_PASSWORDS[@]}"; do
          PASSWORD_FILE="''${MAILBOX_PASSWORDS[$mailbox]}"
          PASSWORD=$(cat "$PASSWORD_FILE")

          echo "Creating mailbox: $mailbox"
          ${config.services.stalwart.package}/bin/stalwart-cli \
            -u http://127.0.0.1:8080 \
            --credentials admin:$ADMIN_PASS \
            account create "$mailbox" \
            -p "$PASSWORD" \
            || true
        done

        ${aliasSetup}
      '';

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };

    # nginx reverse proxy for web UI
    services.nginx.virtualHosts = lib.mkIf (stalwart.webUIHost != null) {
      "${stalwart.webUIHost}".locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
        proxyWebsockets = true;
      };
    };
  };
}
