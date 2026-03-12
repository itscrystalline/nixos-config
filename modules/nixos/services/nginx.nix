{
  lib,
  config,
  ...
}: let
  inherit (config.crystals-services) nginx;
  enabled = nginx.enable;
in {
  options.crystals-services.nginx = {
    enable = lib.mkEnableOption "Nginx reverse proxy";
    localSuffix = lib.mkOption {
      type = lib.types.str;
      description = "suffix for local domains.";
      default = "crys";
    };
  };
  config = lib.mkIf enabled {
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      clientMaxBodySize = "100G";
    };
  };
}
