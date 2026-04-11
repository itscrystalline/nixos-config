{
  lib,
  config,
  ...
}: let
  inherit (config.crystals-services) mailserver;
  enabled = mailserver.enable;

  mkMailboxes = mailboxes:
    builtins.listToAttrs (map ({
      name,
      value,
    }: {
      name = "${name}@${mailserver.host}";
      value =
        (
          if value ? aliases
          then
            (
              let
                mappedAliases = map (alias: "${alias}@${mailserver.host}") value.aliases;
              in
                value // {aliases = mappedAliases;}
            )
          else value
        )
        // {hashedPasswordFile = config.sops.secrets."email-${name}-password".path;};
    }) (lib.attrsToList mailboxes));
in {
  options.crystals-services.mailserver = {
    enable = lib.mkEnableOption "simple-nixos-mailserver";

    host = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "Mail domain (e.g. example.com).";
      default = "iw2tryhard.dev";
    };
    mailboxes = lib.mkOption {
      type = lib.types.attrs;
      description = ''
        Mailboxes. See https://nixos-mailserver.readthedocs.io/en/latest/options.html#mailserver-accounts for config.
        Passwords are provided by defining a hased password as `email-{mailbox name}-password` in the secrets yaml file.
      '';
      default = {};
    };
  };

  config = lib.mkIf enabled {
    assertions = [
      {
        assertion = mailserver.host != null && mailserver.host != "";
        message = "crystals-services.mailserver.host must be set to a non-empty domain when enabled.";
      }
      {
        assertion = !(config ? mailserver);
        message = "import `simple-nixos-mailserver.nixosModule` to use `crystals-services.mailserver`.";
      }
    ];

    sops.secrets = builtins.listToAttrs (map (name: {
        name = "email-${name}-password";
        value = {};
      })
      (builtins.attrNames mailserver.mailboxes));

    mailserver = rec {
      enable = true;
      fqdn = "mx1.${mailserver.host}";
      domains = [mailserver.host];
      x509.useACMEHost = fqdn;
      stateVersion = 4;
      certificateScheme = "acme-nginx";
      openFirewall = true;
      loginAccounts = mkMailboxes mailserver.mailboxes;
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "real@${mailserver.host}";
    };
    services.nginx.virtualHosts.${config.mailserver.fqdn}.enableACME = true;
  };
}
