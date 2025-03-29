{config, ...}: {
  imports = [../common/security.nix];

  security.acme = {
    acceptTerms = true;
    defaults.email = "real@iw2tryhard.dev";
    # certs.${config.services.nextcloud.hostName} = {
    #   group = "nginx";
    #   webroot = "/var/lib/acme/.challenges";
    # };
  };
}
