{
  lib,
  config,
  ...
}: let
  inherit (config.crystals-services) avahi printing;
  enabled = avahi.enable;
in {
  options.crystals-services.avahi = {
    enable = lib.mkEnableOption "Avahi MDNS/SD";
  };
  config.services.avahi = lib.mkIf enabled {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = printing.enable;
    };
  };
}
