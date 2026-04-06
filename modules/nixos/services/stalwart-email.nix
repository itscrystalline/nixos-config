{
  lib,
  config,
  ...
}: let
  inherit (config.crystals-services) stalwart;
  enabled = stalwart.enable;
  #
  # mkMailBoxes = mailboxes:
  #   map (mailbox: {
  #     inherit (mailbox) name;
  #     class = "individual";
  #     description = mailbox.value.fullName;
  #     secret = "%{file:${mailbox.value.passwordFile}}%";
  #     email = [mailbox.value.email] ++ mailbox.value.aliases;
  #   }) (lib.attrsToList mailboxes);
in {
  options.crystals-services.stalwart = {
    enable = lib.mkEnableOption "stalwart mail server";

    directory = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/stalwart-mail";
      description = "Directory to store stalwart data";
    };

    host = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "Main stalwart hostname.";
      default = "iw2tryhard.dev";
    };

    webUIHost = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "Nginx virtual host name to proxy stalwart web UI under. Null to disable.";
      default = "stalwart.${stalwart.host}";
    };

    # mailboxes = lib.mkOption {
    #   type = lib.types.attrsOf (lib.types.submodule {
    #     options = {
    #       fullName = lib.mkOption {
    #         type = lib.types.str;
    #         default = "";
    #         description = "The full name of this user.";
    #       };
    #       email = lib.mkOption {
    #         type = lib.types.str;
    #         default = "";
    #         description = "Email address for this user.";
    #       };
    #       passwordFile = lib.mkOption {
    #         type = lib.types.str;
    #         default = "";
    #         description = "Path to sops secret containing password.";
    #       };
    #       postmaster = lib.mkOption {
    #         type = lib.types.bool;
    #         default = false;
    #         description = "Wether this user is the postmaster.";
    #       };
    #       aliases = lib.mkOption {
    #         type = lib.types.listOf lib.types.str;
    #         default = [];
    #         description = "List of email aliases for this user.";
    #       };
    #     };
    #   });
    #   default = {};
    #   description = "Mailbox configuration";
    #   example = lib.literalExpression ''
    #     {
    #       "user01@example.dev" = {
    #         password = config.sops.secrets.stalwart-user01-password.path;
    #         aliases = [];
    #       };
    #       "main@example.dev" = {
    #         password = config.sops.secrets.stalwart-main-password.path;
    #         aliases = [ "alias1@example.dev" "alias2@example.dev" ];
    #       };
    #     }
    #   '';
    # };
  };

  config = lib.mkIf enabled {
    sops.secrets = {
      stalwart-admin-password.owner = "stalwart-mail";
      stalwart-real-password.owner = "stalwart-mail";
      stalwart-itscrystalline-password.owner = "stalwart-mail";
      stalwart-nc-password.owner = "stalwart-mail";
      stalwart-git-password.owner = "stalwart-mail";
      stalwart-cloudflare-token.owner = "stalwart-mail";

      stalwart-smtp-username.owner = "stalwart-mail";
      stalwart-smtp-password.owner = "stalwart-mail";
    };
    services.stalwart-mail = {
      enable = true;
      dataDir = stalwart.directory;
      openFirewall = true;

      credentials = {
        admin_pass = config.sops.secrets.stalwart-admin-password.path;
        cloudflare_token = config.sops.secrets.stalwart-cloudflare-token.path;

        smtp_username = config.sops.secrets.stalwart-smtp-username.path;
        smtp_password = config.sops.secrets.stalwart-smtp-password.path;
      };

      settings = {
        server = {
          hostname = "mx1.${stalwart.host}";
          tls = {
            enable = true;
            implicit = true;
          };
          listener = {
            smtp = {
              protocol = "smtp";
              bind = "[::]:25";
            };
            submissions = {
              bind = "[::]:465";
              protocol = "smtp";
              tls.implicit = true;
            };
            imaps = {
              bind = "[::]:993";
              protocol = "imap";
              tls.implicit = true;
            };
            jmap = {
              bind = "[::]:8080";
              url = "https://mail.${stalwart.host}";
              protocol = "http";
            };
            management = {
              bind = ["127.0.0.1:8080"];
              protocol = "http";
            };
          };
        };

        lookup.default = {
          hostname = "mx1.${stalwart.host}";
          domain = stalwart.host;
        };

        acme."letsencrypt" = {
          directory = "https://acme-v02.api.letsencrypt.org/directory";
          challenge = "dns-01";
          contact = "real@${stalwart.host}";
          domains = ["${stalwart.host}" "mx1.${stalwart.host}"];
          provider = "cloudflare";
          secret = "%{file:/run/credentials/stalwart-mail.service/cloudflare_token}%";
        };

        session = {
          auth = {
            mechanisms = "[plain]";
            directory = "'in-memory'";
          };
          rcpt.directory = "'in-memory'";
        };

        storage = {
          data = "rocksdb";
          fts = "rocksdb";
          blob = "rocksdb";
          lookup = "rocksdb";
          directory = "internal";
        };

        directory = {
          imap.lookup.domains = ["${stalwart.host}"];
          internal = {
            type = "internal";
            store = "rocksdb";
          };
        };

        authentication.fallback-admin = {
          user = "admin";
          secret = "%{file:/run/credentials/stalwart-mail.service/admin_pass}%";
        };

        queue = {
          strategy.route = [
            {
              "if" = "is_local_domain('*', rcpt_domain)";
              "then" = "'local'";
            }
            {"else" = "'oracle_smtp'";}
          ];

          # oracle cloud relay
          route.oracle_smtp = {
            type = "relay";
            address = "smtp.email.ap-singapore-1.oci.oraclecloud.com";
            port = 587;
            protocol = "smtp";
            auth = {
              username = "%{file:/run/credentials/stalwart-mail.service/smtp_username}%";
              password = "%{file:/run/credentials/stalwart-mail.service/smtp_password}%";
            };
            tls = {
              implicit = false;
              allow-invalid-certs = false;
            };
          };
        };
      };
    };

    # nginx reverse proxy for web UI
    services.nginx.virtualHosts = lib.mkIf (stalwart.webUIHost != null) {
      "${stalwart.webUIHost}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          proxyWebsockets = true;
        };
        serverAliases = [
          "mta-sts.${stalwart.host}"
          "autoconfig.${stalwart.host}"
          "autodiscover.${stalwart.host}"
          "mail.${stalwart.host}"
        ];
      };
    };
  };
}
