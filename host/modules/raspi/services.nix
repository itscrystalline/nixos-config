{
  config,
  inputs,
  pkgs,
  lib,
  secrets,
  ...
}: let
  mkLocalNginx = name: port: alsoWs: {
    services.nginx.virtualHosts."${name}.crys".locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString port}";
      proxyWebsockets = alsoWs;
    };
  };
  mkListFn = keyname: (attrs: map (key: attrs."${key}" // {"${keyname}" = key;}) (builtins.attrNames attrs));
  mkFilterList = mkListFn "name";
  mkRewriteList = mkListFn "domain";
in {
  imports = [
    ../common/services.nix
    ./docker.nix

    (inputs.nixpkgs-unstable + "/nixos/modules/services/hardware/scanservjs.nix")

    ./services/nextcloud.nix
    (import ./services/grafana.nix {inherit config pkgs secrets mkLocalNginx;})

    (mkLocalNginx "scan" config.services.scanservjs.settings.port false)
    (mkLocalNginx "cock" config.services.cockpit.port false)
    (mkLocalNginx "dns" config.services.adguardhome.port false)
  ];

  services.avahi = {
    publish = {
      enable = true;
      userServices = true;
    };
  };

  services.printing = {
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

  # REMOVE: once scanservjs gits into stable
  nixpkgs.overlays = [
    (final: prev: {
      scanservjs = pkgs.unstable.scanservjs;
    })
  ];
  services.scanservjs = {
    enable = true;
    settings.host = "0.0.0.0";
  };

  services.hardware.argonone.enable = true;
  environment.etc = {
    "argononed.conf".text = ''
      fans = 30, 60, 100
      temps = 45, 60, 70

      hysteresis = 5
    '';
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /export 192.168.1.0/24(rw,sync,no_subtree_check) 100.0.0.0/8(rw,sync,no_subtree_check)
    '';
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
  };

  services.cockpit = {
    enable = true;
    settings = {
      WebService = {
        AllowUnencrypted = true;
      };
    };
  };

  services.adguardhome = with secrets.adguard; {
    enable = true;
    port = 5000;
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
      filtering.rewrites = mkRewriteList {
        "*.crys".answer = "100.125.37.13";
        "home.crys".answer = "100.127.3.111";
      };
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

  # SSH auto restart
  systemd.services.sshd.serviceConfig.Restart = lib.mkForce "always";
  systemd.services.tailscaled.serviceConfig.Restart = lib.mkForce "always";
}
