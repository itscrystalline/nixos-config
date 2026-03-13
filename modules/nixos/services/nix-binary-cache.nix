{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  nbc = config.crystals-services.nix-binary-cache;
  enabled = nbc.enable;
in {
  options.crystals-services.nix-binary-cache = {
    enable = lib.mkEnableOption "Local nix binary cache";
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
  };

  disabledModules = ["services/networking/ncps.nix" "services/networking/harmonia.nix"];
  imports = [
    (inputs.nixpkgs-unstable + "/nixos/modules/services/networking/ncps.nix")
    (inputs.nixpkgs-unstable + "/nixos/modules/services/networking/harmonia.nix")
  ];

  config = lib.mkIf enabled {
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
                (builtins.filter (url: !(lib.strings.hasInfix config.crystals-services.nginx.localSuffix url)) config.nix.settings.substituters)
                ++ [
                  "http://127.0.0.1:5000"
                ];
              publicKeys =
                (builtins.filter (key: !(lib.strings.hasInfix config.core.name key)) config.nix.settings.trusted-public-keys)
                ++ [
                  "harmonia.cache.crys:5IjKpw7rA9DxB2BVvDY/NzD0Zakjn9t9SB40AEpY2Q8="
                ];
            }
            else nbc.nixCaches;
        };
        server.addr = "127.0.0.1:8501";
        prometheus.enable = true;
      };

      sops.secrets."harmonia-secret-key".owner = "harmonia";
      harmonia = {
        package = pkgs.unstable.harmonia;
        daemon.enable = true;
        cache = {
          enable = true;
          signKeyPaths = [config.sops.secrets."harmonia-secret-key".path];
          settings.bind = "127.0.0.1:5000";
        };
      };

      nginx.virtualHosts."cache.${config.crystals-services.nginx.localSuffix}".locations."/" = {
        proxyPass = "http://127.0.0.1:8501";
        proxyWebsockets = true;
      };
      nginx.virtualHosts."harmonia.cache.${config.crystals-services.nginx.localSuffix}".locations."/" = {
        proxyPass = "http://127.0.0.1:5000";
        proxyWebsockets = true;
      };
    };
  };
}
