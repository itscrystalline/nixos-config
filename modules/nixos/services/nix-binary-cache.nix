{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  nbc = config.crystals-services.nix-binary-cache;
  enabled = nbc.enable;

  inherit (config.crystals-services.nginx) local;
in {
  options.crystals-services.nix-binary-cache = {
    enable = lib.mkEnableOption "Local nix binary cache";
    domain = lib.mkOption {
      type = lib.types.str;
      description = "local domain for all cache-related things. this is affixed by `config.crystals-services.nginx.local.suffix`.";
      default = "cache";
    };
    nixCaches = lib.mkOption {
      type = lib.types.enum [
        "system"
        (lib.types.submodule {
          options.urls = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "Upstream caches for the binary cache.";
          };
          options.publicKeys = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "Upstream public keys for the binary cache.";
          };
        })
      ];
      default = {
        urls = [];
        publicKeys = [];
      };
      description = "Nix cache config for ncps to use. 'system' means to use the global nix caches.";
    };
    basePath = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/ncps";
      description = "Base directory for ncps's data, temp, and database files";
    };
    openTelemetryGrpcUrl = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "OpenTelemetry gRPC URL for sending logs and traces. If null, telemetry is emitted to stdout.";
    };
  };

  disabledModules = ["services/networking/ncps.nix" "services/networking/harmonia.nix"];
  imports = [
    (inputs.nixpkgs-unstable + "/nixos/modules/services/networking/ncps.nix")
    (inputs.nixpkgs-unstable + "/nixos/modules/services/networking/harmonia.nix")
  ];

  config = lib.mkIf enabled {
    sops.secrets."harmonia-secret-key".owner = "harmonia";

    services = {
      ncps = {
        enable = true;
        package = pkgs.unstable.ncps;
        cache = {
          inherit (config.networking) hostName;
          storage.local = nbc.basePath;
          databaseURL = "sqlite:${nbc.basePath}/db/db.sqlite";
          maxSize = "100G";
          lru.schedule = "0 2 * * *";
          lru.scheduleTimeZone = config.core.localization.timezone;
          allowPutVerb = true;
          allowDeleteVerb = true;
          cdc.enabled = true;

          upstream =
            if (nbc.nixCaches == "system")
            then {
              urls =
                (builtins.filter (url: !(lib.strings.hasInfix local.suffix url)) config.nix.settings.substituters)
                ++ [
                  "http://127.0.0.1:8502"
                ];
              publicKeys =
                (builtins.filter (key: !(lib.strings.hasInfix config.core.name key)) config.nix.settings.trusted-public-keys)
                ++ [
                  "harmonia.${nbc.domain}.${local.suffix}:5IjKpw7rA9DxB2BVvDY/NzD0Zakjn9t9SB40AEpY2Q8="
                ];
            }
            else nbc.nixCaches;
        };
        server.addr = ":8501";
        prometheus.enable = true;
        openTelemetry = {
          enable = true;
          grpcURL = nbc.openTelemetryGrpcUrl;
        };
      };

      harmonia = {
        package = pkgs.unstable.harmonia;
        daemon.enable = true;
        cache = {
          enable = true;
          signKeyPaths = [config.sops.secrets.harmonia-secret-key.path];
          settings.bind = "[::]:8502";
        };
      };
    };

    crystals-services.nginx.local.sites = {
      "${nbc.domain}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8501";
          proxyWebsockets = true;
        };
      };
      "harmonia.${nbc.domain}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8502";
          proxyWebsockets = true;
        };
      };
    };

    networking.hosts = {
      "127.0.0.1" = ["${nbc.domain}.${local.suffix}" "harmonia.${nbc.domain}.${local.suffix}"];
    };
  };
}
