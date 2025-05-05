{
  lib,
  secrets,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.adguard;

  mkListFn = keyname: (attrs: map (key: attrs."${key}" // {"${keyname}" = key;}) (builtins.attrNames attrs));
  mkFilterList = mkListFn "name";
  mkRewriteList = mkListFn "domain";
in {
  options.adguard = {
    enable = mkEnableOption "Enable the adguard module.";
    port = mkOption {
      default = 5000;
      type = types.port;
      description = ''
        Port to serve HTTP pages on.
      '';
    };
    rewriteList = mkOption {
      type = types.nullOr (types.attrs);
      default = null;
      description = "Mapping of DNS entries to IP addresses.";
      example = {
        "*.crys".answer = "100.125.37.13";
        "home.crys".answer = "100.127.3.111";
      };
    };
  };

  config.services.adguardhome = with secrets.adguard;
    mkIf cfg.enable {
      enable = true;
      port = cfg.port;
      mutableSettings = true;
      settings = {
        http.session_ttl = "3h";
        users = [
          {
            name = user;
            password = pass;
          }
        ];
        auth_attempts = 10;
        block_auth_min = 10;
        dns = {
          bind_hosts = ["0.0.0.0"];
          port = 53;
          upstream_dns = ["https://cloudflare-dns.com/dns-query" "https://dns.google/dns-query"];
          bootstrap_dns = ["1.1.1.1" "8.8.8.8"];
        };
        filtering.rewrites = mkRewriteList cfg.rewriteList;
        filters =
          mkFilterList
          {
            "Thai Annoyances" = {
              enabled = true;
              url = "https://adblock-thai.github.io/thai-ads-filter/annoyance.txt";
            };
            "Thai Blocklist" = {
              enabled = true;
              url = "https://adblock-thai.github.io/thai-ads-filter/subscription.txt";
            };

            "AdGuard DNS filter" = {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
            };
            "Peter Lowe's Blocklist" = {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_3.txt";
            };
            "NoCoin Filter List" = {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_8.txt";
            };
            "The Big List of Hacked Malware Web Sites" = {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt";
            };
            "Scam Blocklist by DurableNapkin" = {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_10.txt";
            };
            "Phishing URL Blocklist (PhishTank and OpenPhish)" = {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_30.txt";
            };
            "Steven Black's List" = {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_33.txt";
            };
            "Dandelion Sprout's Anti Push Notifications" = {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_39.txt";
            };
            "HaGeZi's Gambling Blocklist" = {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_47.txt";
            };
            "uBlock₀ filters – Badware risks" = {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_50.txt";
            };
            "HaGeZi's Windows/Office Tracker Blocklist" = {
              enabled = true;
              url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_63.txt";
            };
          };
        user_rules = [
          "@@||t.co^"
          "@@||urbandictionary.com^"
          "@@||urbandictionary.com^$important"
          "@@||telegra.ph^$important"
          "@@||s.youtube.com^"
          "@@||pantip.com^$important"
          "@@||app.localhost.direct^"
          "@@||register.appattest.apple.com^"
          "||ocsp.apple.com^"
          "||ocsp2.apple.com^"
          "||valid.apple.com^"
          "||crl.apple.com^"
          "||certs.apple.com^"
          "||appattest.apple.com^"
          "||vpp.itunes.apple.com^"
        ];
      };
    };
}
