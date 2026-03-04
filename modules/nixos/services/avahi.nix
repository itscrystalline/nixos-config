{
  lib,
  config,
  ...
}: let
  inherit (config.crystals-services) avahi;
  enabled = avahi.enable;
in {
  options.crystals-services.avahi = {
    enable = lib.mkEnableOption "Avahi MDNS/SD";
    publish = {
      enable = lib.mkEnableOption "Avahi service publishing";
      userServices = lib.mkEnableOption "publishing of user services";
    };
  };
  config.services.avahi = lib.mkIf enabled {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = lib.mkIf avahi.publish.enable {
      enable = true;
      userServices = avahi.publish.userServices;
    };
  };
}
