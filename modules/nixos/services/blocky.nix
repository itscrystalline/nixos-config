{
  lib,
  config,
  ...
}: let
  inherit (config.crystals-services) blocky;
  enabled = blocky.enable;
in {
  options.crystals-services.blocky = {
    enable = lib.mkEnableOption "Blocky DNS server";
    allowList = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Custom allowlist entries (one domain per line)";
    };
    denyList = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Custom denylist entries (one domain per line)";
    };
  };
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

        customDNS.mapping = let
          suffix = config.crystals-services.nginx.localSuffix;
        in {
          "dorm.${suffix}" = "100.122.114.13";
          "${suffix}" = "100.125.37.13";
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
            custom = lib.optional (blocky.denyList != "") blocky.denyList;
          };
          allowlists.custom = lib.optional (blocky.allowList != "") blocky.allowList;
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
