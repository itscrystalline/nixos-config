{
  lib,
  config,
  ...
}: let
  inherit (config.crystals-services) scanservjs;
  inherit (config.crystals-services.nginx) localSuffix;
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
    services.nginx.virtualHosts = lib.mkIf (scanservjs.nginxVhost != null) {
      "${scanservjs.nginxVhost}${localSuffix}".locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.scanservjs.settings.port}";
      };
    };
  };
}
