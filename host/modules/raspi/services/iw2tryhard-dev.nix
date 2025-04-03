{
  inputs,
  pkgs,
  ...
}: let
  site = inputs.iw2tryhard-dev.packages.${pkgs.system}.docker;
  domain = "iw2tryhard.dev";
  port = "3000";
in {
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      iw2tryhard-dev = {
        image = "iw2tryhard-dev";
        imageFile = site;
        ports = ["127.0.0.1:${port}:3000"];
        extraOptions = ["--network=bridge"];
      };
    };
  };
  services.nginx.virtualHosts.${domain} = {
    serverAliases = ["www.${domain}"];
    locations."/" = {
      proxyPass = "http://127.0.0.1:${port}";
    };
  };
}
