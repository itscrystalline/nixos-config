{
  lib,
  config,
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
  };

  config = lib.mkIf enabled {
    sops.secrets = {
      stalwart-admin-password.owner = "stalwart-mail";
      stalwart-cloudflare-token.owner = "stalwart-mail";
    };
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
          domains = ["${stalwart.host}" "mx1.${stalwart.host}" "mail.${stalwart.host}"];
          provider = "cloudflare";
          secret = "%{file:/run/credentials/stalwart-mail.service/cloudflare_token}%";
        };

        session = {
          auth = {
            mechanisms = "[plain]";
            directory = "'internal'";
          };
          rcpt = {
            directory = "'internal'";
            relay = [
              {
                "if" = "!is_local_domain('*', rcpt_domain) && authenticated_as != ''";
                "then" = "true";
              }
              {"else" = "false";}
            ];
          };
        };

        imap = {
          auth = {
            directory = "'internal'";
            mechanisms = "[plain]";
          };
        };

        storage = {
          data = "db";
          fts = "db";
          blob = "db";
          lookup = "db";
          directory = "internal";
        };

        directory.internal = {
          type = "internal";
          store = "db";
          lookup.domains = ["${stalwart.host}"];
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
            {"else" = "'mx'";}
          ];
        };

        tracer.stdout = {
          type = "stdout";
          level = "trace";
          ansi = false;
          enable = true;
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
