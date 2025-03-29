{config, ...}: {
  imports = [../common/security.nix];

  security.acme = {
    acceptTerms = true;
    certs.${config.services.nextcloud.hostName} = {
      email = "real@iw2tryhard.dev";
      group = "nginx";
      webroot = "/var/lib/acme/.challenges";
    };
  };
}
