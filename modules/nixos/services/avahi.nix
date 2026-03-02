{
  lib,
  config,
  ...
}: let
  enabled = config.crystals-services.avahi.enable;
in {
  options.crystals-services.avahi.enable = lib.mkEnableOption "Avahi MDNS/SD";
  config.services.avahi = lib.mkIf enabled {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
