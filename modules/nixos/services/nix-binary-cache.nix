{
  lib,
  config,
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
          options.caches = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "Upstream caches for ncps.";
          };
          options.publicKeys = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "Upstream public keys for ncps.";
          };
        })
      ];
      default = {};
      description = "Nix cache config for ncps to use. 'system' means to use the global nix caches.";
    };
    basePath = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/ncps";
      description = "Base directory for ncps's data, temp, and database files";
    };
    broadcastAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "The addresses ncps will be available at.";
    };
  };
  config = lib.mkIf enabled {
    services = {
      ncps = {
        enable = true;
        cache = {
          inherit (config.networking) hostName;
          dataPath = "${nbc.basePath}/data";
          tempPath = "${nbc.basePath}/temp";
          databaseURL = "sqlite:${nbc.basePath}/db/db.sqlite";
          maxSize = "100G";
          lru.schedule = "0 2 * * *";
          allowPutVerb = true;
          allowDeleteVerb = true;
        };
        server.addr = "${nbc.broadcastAddress}:8501";
        upstream =
          if (nbc.nixCaches == "system")
          then {
            caches =
              (builtins.filter (url: !(lib.strings.hasInfix config.crystals-services.nginx.localSuffix url)) config.nix.settings.substituters)
              ++ [
                "http://127.0.0.1:5000"
              ];
            publicKeys =
              (builtins.filter (key: !(lib.strings.hasInfix config.core.name key)) config.nix.settings.trusted-public-keys)
              ++ [
                "harmonia:z1iV14fiWCOjqPiTbVjF0dLdYQPfz0OjcKcGQ+2oejc="
              ];
          }
          else nbc.nixCaches;
      };

      sops.secrets."harmonia-secret-key".owner = "harmonia";
      harmonia = {
        enable = true;
        signKeyPaths = [config.sops.secrets."harmonia-secret-key".path];
        settings.bind = "127.0.0.1:5000";
      };

      nginx.virtualHosts."cache.${config.crystals-services.nginx.localSuffix}".locations."/" = {
        proxyPass = "http://127.0.0.1:8501";
        proxyWebsockets = true;
      };
    };
  };
}
