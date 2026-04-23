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
  };

  config = lib.mkIf enabled {
    sops.secrets = {
      "stalwart-admin-password".owner = "stalwart-mail";
      "stalwart-cloudflare-token".owner = "stalwart-mail";
      "stalwart-dkim-rsa-key".owner = "stalwart-mail";
      "stalwart-dkim-ed25519-key".owner = "stalwart-mail";
    };

    services.stalwart-mail = {
      enable = true;
      dataDir = stalwart.directory;
      openFirewall = true;

      credentials = with config.sops.secrets; {
        admin_pass = stalwart-admin-password.path;
        cloudflare_token = stalwart-cloudflare-token.path;
        "dkim-rsa.key" = stalwart-dkim-rsa-key.path;
        "dkim-ed25519.key" = stalwart-dkim-ed25519-key.path;
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

        auth.dkim.sign = [
          {
            "if" = "is_local_domain('*', sender_domain)";
            # "then" = "['rsa-' + sender_domain, 'ed25519-' + sender_domain]";
            "then" = "['rsa-' + sender_domain]";
          }
          {"else" = false;}
        ];
        signature = {
          "rsa-${stalwart.host}" = {
            private-key = "%{file:/run/credentials/stalwart-mail.service/dkim-rsa.key}%";
            domain = stalwart.host;
            selector = "202604r";
            headers = ["From" "To" "Cc" "Date" "Subject" "Message-ID" "MIME-Version" "Content-Type" "In-Reply-To" "References" "List-Id"];
            algorithm = "rsa-sha256";
            canonicalization = "relaxed/relaxed";
            set-body-length = false;
            report = true;
          };
          "ed25519-${stalwart.host}" = {
            private-key = "%{file:/run/credentials/stalwart-mail.service/dkim-ed25519.key}%";
            domain = stalwart.host;
            selector = "202604e";
            headers = ["From" "To" "Cc" "Date" "Subject" "Message-ID" "MIME-Version" "Content-Type" "In-Reply-To" "References" "List-Id"];
            algorithm = "ed25519-sha256";
            canonicalization = "relaxed/relaxed";
            set-body-length = false;
            report = true;
          };
        };

        report = {
          domain = stalwart.host;
          submitter = "'mx1.${stalwart.host}'";

          dsn = {
            from-name = "'Mail Delivery Subsystem'";
            from-address = "'mailer-daemon@${stalwart.host}'";
            # sign = "['rsa-${stalwart.host}', 'ed25519-${stalwart.host}']";
            sign = "['rsa-${stalwart.host}']";
          };
          dkim = {
            from-name = "'Report Subsystem'";
            from-address = "'noreply-dkim@${stalwart.host}'";
            subject = "'DKIM Authentication Failure Report'";
            # sign = "['rsa-${stalwart.host}', 'ed25519-${stalwart.host}']";
            sign = "['rsa-${stalwart.host}']";
            send = "1/1d";
          };
          spf = {
            from-name = "'Report Subsystem'";
            from-address = "'noreply-spf@${stalwart.host}'";
            subject = "'SPF Authentication Failure Report'";
            # sign = "['rsa-${stalwart.host}', 'ed25519-${stalwart.host}']";
            sign = "['rsa-${stalwart.host}']";
            send = "1/1d";
          };
          dmarc = {
            from-name = "'Report Subsystem'";
            from-address = "'noreply-dmarc@${stalwart.host}'";
            subject = "'DMARC Authentication Failure Report'";
            # sign = "['rsa-${stalwart.host}', 'ed25519-${stalwart.host}']";
            sign = "['rsa-${stalwart.host}']";
            send = "1/1d";

            aggregate = {
              from-name = "'DMARC Aggregate Report'";
              from-address = "'noreply-dmarc@${stalwart.host}'";
              org-name = "'Jocelyn the Mailgirl'";
              contact-info = "'postmaster@${stalwart.host}'";
              send = "weekly";
              max-size = 26214400; # 25mb
              # sign = "['rsa-${stalwart.host}', 'ed25519-${stalwart.host}']";
              sign = "['rsa-${stalwart.host}']";
            };
          };
          tls.aggregate = {
            from-name = "'TLS Aggregate Report'";
            from-address = "'noreply-tls@${stalwart.host}'";
            org-name = "'Jocelyn the Mailgirl'";
            contact-info = "'postmaster@${stalwart.host}'";
            send = "weekly";
            max-size = 26214400; # 25 mb
            # sign = "['rsa-${stalwart.host}', 'ed25519-${stalwart.host}']";
            sign = "['rsa-${stalwart.host}']";
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
  };
}
