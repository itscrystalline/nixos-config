{
  inputs,
  pkgs,
  ...
}: let
  site = inputs.iw2tryhard-dev.packages.${pkgs.system}.docker;
  # site_v2 = inputs.iw2tryhard-dev.packages.${pkgs.system}.docker_v2;
  domain = "iw2tryhard.dev";
  port = "3000";
  port_v2 = "3001";
in {
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      iw2tryhard-dev = {
        image = "iw2tryhard-dev";
        imageFile = site;
        ports = ["127.0.0.1:${port}:3000"];
        extraOptions = ["--network=bridge" "--dns=1.1.1.1"];
        autoStart = true;
      };
      thaddev-com = {
        image = "ghcr.io/itscrystalline/thaddev.com-2.0:main";
        # imageFile = site_v2;
        ports = ["127.0.0.1:${port_v2}:3000"];
        extraOptions = ["--network=bridge" "--dns=1.1.1.1"];
        autoStart = true;
      };
    };
  };
  services.nginx.virtualHosts = {
    ${domain} = {
      serverAliases = ["www.${domain}"];
      locations."/" = {
        proxyPass = "http://127.0.0.1:${port}";
      };
    };
    "v2.${domain}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${port_v2}";
      };
    };
  };
}
