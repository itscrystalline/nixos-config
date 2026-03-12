{
  lib,
  config,
  ...
}: let
  inherit (config.crystals-services) ncps;
  enabled = ncps.enable;
  port = 8501;
in {
  options.crystals-services.ncps = {
    enable = lib.mkEnableOption "ncps Nix cache proxy";
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
    services.ncps = {
      enable = true;
      cache = {
        inherit (config.networking) hostName;
        dataPath = "${ncps.basePath}/data";
        tempPath = "${ncps.basePath}/temp";
        databaseURL = "sqlite:${ncps.basePath}/db/db.sqlite";
        maxSize = "100G";
        lru.schedule = "0 2 * * *";
        allowPutVerb = true;
        allowDeleteVerb = true;
      };
      server.addr = "${ncps.broadcastAddress}:${toString port}";
      upstream =
        if (ncps.nixCaches == "system")
        then {
          caches = builtins.filter (url: !(lib.strings.hasInfix config.crystals-services.nginx.localSuffix url)) config.nix.settings.substituters;
          publicKeys = builtins.filter (key: !(lib.strings.hasInfix config.core.name key)) config.nix.settings.trusted-public-keys;
        }
        else ncps.nixCaches;
    };
    services.nginx.virtualHosts."cache.${config.crystals-services.nginx.localSuffix}".locations."/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
      proxyWebsockets = true;
    };
  };
}
