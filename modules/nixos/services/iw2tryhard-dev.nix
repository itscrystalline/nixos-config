{
  lib,
  config,
  ...
}: let
  inherit (config.crystals-services) iw2tryhard-dev;
  enabled = iw2tryhard-dev.enable;
in {
  options.crystals-services.iw2tryhard-dev.enable = lib.mkEnableOption "personal website";
  config = lib.mkIf enabled {
    virtualisation.oci-containers.containers = {
      iw2tryhard-dev = {
        image = "git.iw2tryhard.dev/itscrystalline/iw2tryhard-dev-3.0:latest";
        ports = ["127.0.0.1:3000:3000"];
        extraOptions = ["--network=bridge" "--dns=1.1.1.1"];
        autoStart = true;
      };
    };
    crystals-services.nginx.public.sites = {
      "" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
        };
        aliases = ["www"];
        acme = true;
      };
    };
    crystals-services.cloudflared.domains = {
      "" = {};
      "www" = {};
    };
  };
}
