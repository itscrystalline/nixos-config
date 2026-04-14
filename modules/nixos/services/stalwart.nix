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
      description = "Nginx local host name to proxy stalwart web UI under. Null to disable.";
      default = "stalwart.crys";
    };
  };

  config = lib.mkIf enabled {
    sops.secrets = {
      "stalwart-admin-password".owner = "stalwart-mail";
      "stalwart-cloudflare-token".owner = "stalwart-mail";
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
          max-connections = 8192;
          socket = {
            backlog = 1024;
            nodelay = true;
            reuse-addr = true;
            reuse-port = true;
          };
          listener = {
            smtp = {
              bind = "[::]:25";
              protocol = "smtp";
            };
            submissions = {
              bind = "[::]:465";
              protocol = "smtp";
              tls.implicit = true;
            };
            imaptls = {
              bind = "[::]:993";
              protocol = "imap";
              tls.implicit = true;
            };
            sieve = {
              bind = "[::]:4190";
              protocol = "managesieve";
            };
            https = {
              bind = "[::]:443";
              protocol = "http";
              tls.implicit = true;
            };
            http = {
              bind = "[::]:8080";
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
          domains = [
            # "${stalwart.host}"
            "mx1.${stalwart.host}"
            "mail.${stalwart.host}"
            "autoconfig.${stalwart.host}"
            "autodiscover.${stalwart.host}"
            "mta-sts.${stalwart.host}"
          ];
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

        queue.strategy.route = [
          {
            "if" = "is_local_domain('*', rcpt_domain)";
            "then" = "'local'";
          }
          {"else" = "'mx'";}
        ];

        report = {
          domain = stalwart.host;
          submitter = "'mx1.${stalwart.host}'";

          dsn = {
            from-name = "'Mail Delivery Subsystem'";
            from-address = "'mailer-daemon@${stalwart.host}'";
            sign = "['rsa-${stalwart.host}', 'ed25519-${stalwart.host}']";
          };
          dkim = {
            from-name = "'Report Subsystem'";
            from-address = "'noreply-dkim@${stalwart.host}'";
            subject = "'DKIM Authentication Failure Report'";
            sign = "['rsa-${stalwart.host}', 'ed25519-${stalwart.host}']";
            send = "1/1d";
          };
          spf = {
            from-name = "'Report Subsystem'";
            from-address = "'noreply-spf@${stalwart.host}'";
            subject = "'SPF Authentication Failure Report'";
            sign = "['rsa-${stalwart.host}', 'ed25519-${stalwart.host}']";
            send = "1/1d";
          };
          dmarc = {
            from-name = "'Report Subsystem'";
            from-address = "'noreply-dmarc@${stalwart.host}'";
            subject = "'DMARC Authentication Failure Report'";
            sign = "['rsa-${stalwart.host}', 'ed25519-${stalwart.host}']";
            send = "1/1d";

            aggregate = {
              from-name = "'DMARC Aggregate Report'";
              from-address = "'noreply-dmarc@${stalwart.host}'";
              org-name = "'Jocelyn the Mailgirl'";
              contact-info = "'postmaster@${stalwart.host}'";
              send = "weekly";
              max-size = 26214400; # 25mb
              sign = "['rsa-${stalwart.host}', 'ed25519-${stalwart.host}']";
            };
          };
          tls.aggregate = {
            from-name = "'TLS Aggregate Report'";
            from-address = "'noreply-tls@${stalwart.host}'";
            org-name = "'Jocelyn the Mailgirl'";
            contact-info = "'postmaster@${stalwart.host}'";
            send = "weekly";
            max-size = 26214400; # 25 mb
            sign = "['rsa-${stalwart.host}', 'ed25519-${stalwart.host}']";
          };

          analysis = {
            addresses = ["dmarc@${stalwart.host}" "abuse@${stalwart.host}" "postmaster@${stalwart.host}"];
            forward = true;
            store = "30d";
          };
        };

        tracer.stdout = {
          type = "stdout";
          level = "info";
          ansi = false;
          enable = true;
        };
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
