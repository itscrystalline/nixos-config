{...}: {
  crystals-services.nginx.public.sites."static".locations."/api" = {
    proxyPass = "http://127.0.0.1:3001";
  };
  virtualisation.oci-containers.containers = {
    iw2tryhard-dev = {
      image = "git.iw2tryhard.dev/itscrystalline/iw2tryhard-dev-3.0:latest";
      ports = ["127.0.0.1:3001:3000"];
      extraOptions = ["--network=bridge" "--dns=1.1.1.1"];
      autoStart = true;
    };
  };
}
