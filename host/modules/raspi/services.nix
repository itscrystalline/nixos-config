{
  config,
  inputs,
  pkgs,
  lib,
  secrets,
  ...
}: let
  cfg = config.crystal.raspi.services;
  mkLocalNginx = name: port: alsoWs: {
    services.nginx.virtualHosts."${name}.crys".locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString port}";
      proxyWebsockets = alsoWs;
    };
  };
in {
  imports = [
    ../common/services.nix
    ../../services/adguardhome.nix
    ./docker.nix
    ./services/cloudflared.nix
    ./services/nextcloud.nix
    ./services/iw2tryhard-dev.nix
    (import ./services/grafana.nix {inherit config pkgs secrets mkLocalNginx;})
    (import ./services/manga.nix {inherit inputs config secrets mkLocalNginx;})
    (import ./services/ncps.nix {inherit config mkLocalNginx;})

    (mkLocalNginx "scan" config.services.scanservjs.settings.port false)
    (mkLocalNginx "cock" config.services.cockpit.port false)
    # (mkLocalNginx "dns" config.services.adguardhome.port false)
  ];

  options.crystal.raspi.services.enable = lib.mkEnableOption "raspi services configuration" // {default = true;};

  config = lib.mkIf cfg.enable {
    adguard = {
      enable = false;
      rewriteList = {
        "dorm.crys".answer = "100.122.114.13";
        "*.crys".answer = "100.125.37.13";
      };
    };
    services = {
      blocky = {
        enable = true;
        settings = {
          ports = {
            dns = 53;
            tls = 83;
            http = 5000;
            https = 5443;
          };
          upstreams = {
            init.strategy = "fast";
            groups.default = ["https://cloudflare-dns.com/dns-query" "https://dns.google/dns-query" "1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4"];
          };
          bootstrapDns = [
            {
              upstream = "https://cloudflare-dns.com/dns-query";
              ips = ["1.1.1.1" "1.0.0.1"];
            }
            {
              upstream = "https://dns.google/dns-query";
              ips = ["8.8.8.8" "8.8.4.4"];
            }
          ];

          customDNS.mapping = {
            "dorm.crys" = "100.122.114.13";
            "crys" = "100.125.37.13";
          };

          blocking = rec {
            denylists = {
              # nvm these are ubo blocklists
              # thai = [
              #   # Thai-specific ad, popup, and annoyance filters
              #   "https://adblock-thai.github.io/thai-ads-filter/annoyance.txt"
              #   # Main Thai ads and tracking domains blocklist
              #   "https://adblock-thai.github.io/thai-ads-filter/subscription.txt"
              # ];

              ads = [
                # AdGuard DNS filter – general ad and tracking domains
                "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt"
                # Peter Lowe’s blocklist – widely used global ads & trackers list
                "https://adguardteam.github.io/HostlistsRegistry/assets/filter_3.txt"
                # Steven Black’s unified hosts list (ads + some trackers)
                "https://adguardteam.github.io/HostlistsRegistry/assets/filter_33.txt"
              ];

              malware = [
                # NoCoin – blocks cryptomining and cryptojacking domains
                "https://adguardteam.github.io/HostlistsRegistry/assets/filter_8.txt"
                # Known hacked and malware-hosting websites
                "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"
                # uBlock₀ badware & risk domains
                "https://adguardteam.github.io/HostlistsRegistry/assets/filter_50.txt"
              ];

              scam = [
                # Scam and fraud domains maintained by DurableNapkin
                "https://adguardteam.github.io/HostlistsRegistry/assets/filter_10.txt"
                # Phishing URLs from PhishTank and OpenPhish
                "https://adguardteam.github.io/HostlistsRegistry/assets/filter_30.txt"
                # Gambling domains (often associated with scammy ads)
                "https://adguardteam.github.io/HostlistsRegistry/assets/filter_47.txt"
              ];

              trackers = [
                # Blocks push-notification spam domains
                "https://adguardteam.github.io/HostlistsRegistry/assets/filter_39.txt"
                # Windows & Office telemetry and tracking endpoints
                "https://adguardteam.github.io/HostlistsRegistry/assets/filter_63.txt"
              ];

              custom = [
                ''
                  ocsp.apple.com
                  ocsp2.apple.com
                  valid.apple.com
                  crl.apple.com
                  certs.apple.com
                  appattest.apple.com
                  vpp.itunes.apple.com
                ''
              ];
            };
            allowlists.custom = [
              ''
                t.co
                urbandictionary.com
                telegra.ph
                s.youtube.com
                pantip.com$important
                app.localhost.direct
                register.appattest.apple.com
              ''
            ];

            clientGroupsBlock.default = builtins.attrNames denylists;
            loading = {
              concurrency = 8;
              strategy = "fast";
            };
          };

          caching.prefetching = true;
          prometheus.enable = true;
        };
      };

      avahi = {
        publish = {
          enable = true;
          userServices = true;
        };
      };

      printing = {
        listenAddresses = ["*:631"];
        allowFrom = ["all"];
        browsing = true;
        defaultShared = true;
        openFirewall = true;
        drivers = with pkgs; [gutenprint];
        extraConf = ''
          DefaultPaperSize A4
        '';
      };

      scanservjs = {
        enable = true;
        settings.host = "0.0.0.0";
      };

      hardware.argonone.enable = true;

      nfs.server = {
        enable = true;
        exports = ''
          /export 192.168.1.0/24(rw,sync,no_subtree_check) 100.0.0.0/8(rw,sync,no_subtree_check)
        '';
      };

      nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        recommendedOptimisation = true;
        clientMaxBodySize = "100G";
      };

      cockpit = {
        enable = true;
        settings = {
          WebService = {
            AllowUnencrypted = true;
          };
        };
      };
    };
    environment.etc = {
      "argononed.conf".text = ''
        fans = 30, 60, 100
        temps = 45, 60, 70

        hysteresis = 5
      '';
    };

    # SSH auto restart
    systemd.services.sshd.serviceConfig.Restart = lib.mkForce "always";
    systemd.services.tailscaled.serviceConfig.Restart = lib.mkForce "always";
  };
}
