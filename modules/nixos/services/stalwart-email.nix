{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.crystals-services) stalwart;
  enabled = stalwart.enable;

  mkMailBoxes = mailboxes:
    map (mailbox: {
      inherit (mailbox) name;
      class = "individual";
      secret = "%{file:${mailbox.value.passwordFile}}%";
      email = [mailbox.value.email] ++ mailbox.value.aliases;
    }) (lib.attrsToList mailboxes);
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
      default = null;
    };
    webUIHost = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "Nginx virtual host name to proxy stalwart web UI under. Null to disable.";
      default = "stalwart.${stalwart.host}";
    };

    mailboxes = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          email = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Email address for this user";
          };
          passwordFile = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Path to sops secret containing password";
          };
          postmaster = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Is this user the postmaster?";
          };
          aliases = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "List of email aliases for this user";
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
    services.stalwart-mail = {
      enable = true;
      dataDir = stalwart.directory;
      openFirewall = true;

      credentials = {
        admin_pass = config.sops.secrets.stalwart-admin-password.path;
        cloudflare_token = config.sops.secrets.stalwart-cloudflare-token.path;
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
          secret = "%{file:/run/credentials/stalwart.service/cloudflare_token}%";
        };
        session.auth = {
          mechanisms = "[plain]";
          directory = "'in-memory'";
        };
        storage.directory = "in-memory";
        session.rcpt.directory = "'in-memory'";
        directory."imap".lookup.domains = ["${stalwart.host}"];
        directory."in-memory" = {
          type = "memory";
          principals = mkMailBoxes stalwart.mailboxes;
        };
        authentication.fallback-admin = {
          user = "admin";
          secret = "%{file:/run/credentials/stalwart.service/admin_pass}%";
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
