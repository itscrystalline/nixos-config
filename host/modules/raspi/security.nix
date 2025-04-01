{config, ...}: {
  imports = [../common/security.nix];

  security.acme = {
    acceptTerms = true;
    defaults = {
      dnsProvider = "cloudflare";
      credentialFiles = {
        "CLOUDFLARE_API_KEY_FILE" = "${builtins.toPath ../../../secrets/cf_api_key}";
      };
      email = "real@iw2tryhard.dev";
      group = "nginx";
      webroot = "/var/lib/acme/.challenges";
    };
    # certs.${config.services.nextcloud.hostName} = {
    # };
  };
}
