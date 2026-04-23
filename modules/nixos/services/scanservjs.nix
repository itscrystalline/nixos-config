{
  lib,
  config,
  ...
}: let
  inherit (config.crystals-services) scanservjs;
  enabled = scanservjs.enable;
in {
  options.crystals-services.scanservjs = {
    enable = lib.mkEnableOption "scanservjs network scanner service";
    nginxVhost = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "Nginx virtual host name to proxy scanservjs under. Null to disable.";
      default = "scan";
    };
  };
  config = lib.mkIf enabled {
    services.scanservjs = {
      enable = true;
      settings.host = "0.0.0.0";
    };
    crystals-services.nginx.local.sites."${scanservjs.nginxVhost}" = lib.mkIf (scanservjs.nginxVhost != null) {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.scanservjs.settings.port}";
      };
    };
  };
}
