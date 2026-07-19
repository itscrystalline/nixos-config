{...}: {
  crystals-services.nginx.public.sites."static".locations."/api" = {
    proxyPass = "http://127.0.0.1:3010";
  };
  virtualisation.oci-containers.containers = {
    l10n-fetch = {
      image = "git.iw2tryhard.dev/itscrystalline/l10n-fetch:latest";
      ports = ["127.0.0.1:3010:3000"];
      extraOptions = ["--network=bridge" "--dns=1.1.1.1"];
      autoStart = true;
    };
  };
}
