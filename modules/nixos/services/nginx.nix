{
  lib,
  config,
  ...
}: let
  inherit (config.crystals-services) nginx;
  enabled = nginx.enable;

  commonSiteOptions = {
    locations = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs;
      description = "Nginx locations.";
      default = {"/" = {};};
    };
    aliases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Aliases for this domain";
      default = [];
    };
  };

  mkLocalDomains = domains:
    builtins.listToAttrs (map ({
      name,
      value,
    }: {
      name = "${name}${
        if name != ""
        then "."
        else ""
      }${nginx.local.suffix}";
      value = {
        inherit (value) locations;
        serverAliases = value.aliases;
      };
    }) (lib.attrsToList domains));

  mkPublicDomains = domains:
    builtins.listToAttrs (map ({
      name,
      value,
    }: let
      domain = "${name}${
        if name != ""
        then "."
        else ""
      }${nginx.public.suffix}";
    in {
      name = domain;
      value = {
        inherit (value) locations;
        serverAliases = value.aliases;
        forceSSL = value.acme != false;
        useACMEHost =
          if builtins.isBool value.acme
          then
            (
              if value.acme
              then domain
              else null
            )
          else value.acme;
      };
    }) (lib.attrsToList domains));

  mkACMECertificateOrders = domains: let
    expandDomain = name: "${name}${
      if name != ""
      then "."
      else ""
    }${nginx.public.suffix}";
    domainNames = builtins.attrNames domains;

    topLevelDomains = builtins.filter (domain: let d = domains.${domain}; in builtins.isBool d.acme && d.acme) domainNames;
    referrers = domain: builtins.filter (other: domains.${other}.acme == domain) domainNames;
  in
    builtins.listToAttrs (map (tld: {
        name = expandDomain tld;
        value = {
          inherit (config.services.nginx) group;
          extraDomainNames = map expandDomain (referrers tld);
        };
      })
      topLevelDomains);
in {
  options.crystals-services.nginx = {
    enable = lib.mkEnableOption "Nginx reverse proxy";
    local = {
      suffix = lib.mkOption {
        type = lib.types.str;
        description = "suffix for local domains.";
        default = "crys";
      };
      sites = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = commonSiteOptions;
        });
        description = "Attrset of local sites. the name constitutes a subdomain, an empty name means the domain apex.";
        default = {};
      };
    };
    public = {
      suffix = lib.mkOption {
        type = lib.types.str;
        description = "suffix for local domains.";
        default = "iw2tryhard.dev";
      };
      sites = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options =
            commonSiteOptions
            // {
              acme = lib.mkOption {
                type = lib.types.either lib.types.bool lib.types.str;
                description = "If set to true, Registers a TLS certificate for this site and it's aliases. else, this site uses the ACME cert of the site entered here. if false, disables TLS.";
                default = true;
              };
            };
        });
        description = "Attrset of local sites. the name constitutes a subdomain, an empty name means the domain apex.";
        default = {};
      };
    };
  };
  config = lib.mkIf enabled {
    network.ports.tcp = [80 443];
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      clientMaxBodySize = "100G";
      virtualHosts = (mkLocalDomains nginx.local.sites) // (mkPublicDomains nginx.public.sites);
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "real@${nginx.public.suffix}";
      certs = mkACMECertificateOrders nginx.public.sites;
    };
  };
}
