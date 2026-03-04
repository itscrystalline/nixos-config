{
  lib,
  config,
  ...
}: let
  inherit (config.crystals-services) blocky;
  enabled = blocky.enable;
in {
  options.crystals-services.blocky.enable = lib.mkEnableOption "Blocky DNS server";
  config = lib.mkIf enabled {
    services.blocky = {
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
            ads = [
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt"
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_3.txt"
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_33.txt"
            ];
            malware = [
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_8.txt"
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_50.txt"
            ];
            scam = [
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_10.txt"
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_30.txt"
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_47.txt"
            ];
            trackers = [
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_39.txt"
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_63.txt"
            ];
            ai = [
              "https://raw.githubusercontent.com/laylavish/uBlockOrigin-HUGE-AI-Blocklist/main/noai_hosts.txt"
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
        prometheus.enable = config.crystals-services.monitoring.enable;
      };
    };
  };
}
