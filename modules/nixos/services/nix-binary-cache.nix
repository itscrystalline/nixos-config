{
  lib,
  config,
  ...
}: let
  nbc = config.crystals-services.nix-binary-cache;

  inherit (config.crystals-services.nginx) local;
in {
  options.crystals-services.nix-binary-cache = {
    domain = lib.mkOption {
      type = lib.types.str;
      description = "local domain for all cache-related things. this is affixed by `config.crystals-services.nginx.local.suffix`.";
      default = "cache";
    };
    harmonia = {
      enable = lib.mkEnableOption "Serve local nix store as cache";
    };
    ncro = {
      enable = lib.mkEnableOption "Lightweight HTTP proxy for optimizing Nix cache routes for fast access";
      publish = lib.mkEnableOption "Publishing to the network via nginx";
      nixCaches = lib.mkOption {
        type = lib.types.listOf (lib.types.submodule {
          options.url = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Upstream cache URL.";
          };
          options.public_key = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Upstream public keys.";
          };
        });
        default = [];
        description = "Nix cache config for ncro to use.";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf nbc.harmonia.enable {
      sops.secrets."harmonia-secret-key".owner = "harmonia";
      users.users.harmonia = {
        isSystemUser = true;
        group = "harmonia";
      };
      users.groups.harmonia = {};

      services = {
        harmonia-dev = {
          daemon.enable = true;
          cache = {
            enable = true;
            signKeyPaths = [config.sops.secrets.harmonia-secret-key.path];
            settings.bind = "[::]:8502";
          };
        };
      };

      crystals-services.nginx.local.sites = {
        "harmonia.${nbc.domain}" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:8502";
            proxyWebsockets = true;
          };
        };
      };

      networking.hosts = {
        "127.0.0.1" = ["harmonia.${nbc.domain}.${local.suffix}"];
      };
    })
    (lib.mkIf nbc.ncro.enable {
      services = {
        ncro = {
          enable = true;
          settings = {
            upstreams = builtins.map (upstream: upstream // {priority = 10;}) nbc.ncro.nixCaches;
            logging.level = "info";
            server = {
              listen = ":8503";
              cache_priority = 20;
            };
            cache = {
              ttl = "2h";
              negative_ttl = "15m";
            };
          };
        };
      };
      crystals-services.nginx.local.sites = lib.mkIf nbc.ncro.publish {
        "${nbc.domain}" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:8503";
            proxyWebsockets = true;
          };
        };
      };
      networking.hosts = {
        "127.0.0.1" = ["${nbc.domain}.${local.suffix}"];
      };
    })
  ];
}
