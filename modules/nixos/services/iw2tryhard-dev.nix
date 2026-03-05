{
  lib,
  config,
  ...
}: let
  inherit (config.crystals-services) iw2tryhard-dev;
  enabled = iw2tryhard-dev.enable;
in {
  options.crystals-services.iw2tryhard-dev.enable = lib.mkEnableOption "personal website services";
  config = lib.mkIf enabled {
    virtualisation.oci-containers.containers = {
      iw2tryhard-dev = {
        image = "ghcr.io/itscrystalline/iw2tryhard-dev-3.0:main";
        ports = ["127.0.0.1:3000:3000"];
        extraOptions = ["--network=bridge" "--dns=1.1.1.1"];
        autoStart = true;
      };
      thaddev-com = {
        image = "ghcr.io/itscrystalline/thaddev.com-2.0:main";
        ports = ["127.0.0.1:3001:3000"];
        extraOptions = ["--network=bridge" "--dns=1.1.1.1"];
        autoStart = true;
      };
    };
    services.nginx.virtualHosts = {
      "iw2tryhard.dev" = {
        serverAliases = ["www.iw2tryhard.dev"];
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
        };
      };
      "v2.iw2tryhard.dev" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3001";
        };
      };
    };
  };
}
