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
    basePath = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/main/ncps";
      description = "Base directory for ncps data, temp, and database files";
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
      server.addr = "0.0.0.0:${toString port}";
      upstream = {
        caches = [
          "https://devenv.cachix.org"
          "https://sanzenvim.cachix.org"
          "https://nix-community.cachix.org"
          "https://nixpkgs-python.cachix.org"
          "https://cuda-maintainers.cachix.org"
        ];
        publicKeys = [
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
          "sanzenvim.cachix.org-1:zNf9OhUUfJ/NM55vbjx9fSM6O/Q3L6JDoFwU1VCEohc="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
          "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        ];
      };
    };
    services.nginx.virtualHosts."cache.crys".locations."/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
      proxyWebsockets = true;
    };
  };
}
