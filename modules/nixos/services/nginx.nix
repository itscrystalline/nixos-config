{
  lib,
  config,
  pkgs,
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
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      description = "Extra config for this site.";
      default = "";
    };
  };

  expandDomain = suffix: name: "${name}${
    if name != ""
    then "."
    else ""
  }${suffix}";

  mkLocalDomains = domains:
    builtins.listToAttrs (map ({
      name,
      value,
    }: {
      name = expandDomain nginx.local.suffix name;
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
      expandDomain' = expandDomain nginx.public.suffix;
      domain = expandDomain' name;
    in {
      name = domain;
      value = {
        inherit (value) locations;
        serverAliases = value.aliases;
        acmeRoot = null;
        forceSSL = value.acme != false;
        useACMEHost =
          if builtins.isBool value.acme
          then
            (
              if value.acme
              then domain
              else null
            )
          else expandDomain' value.acme;
      };
    }) (lib.attrsToList domains));

  mkACMECertificateOrders = domains: let
    domainNames = builtins.attrNames domains;
    expandDomain' = expandDomain nginx.public.suffix;

    topLevelDomains = builtins.filter (domain: let d = domains.${domain}; in builtins.isBool d.acme && d.acme) domainNames;
    referrers = domain: builtins.filter (other: domains.${other}.acme == domain) domainNames;
  in
    builtins.listToAttrs (map (tld: let
        ref = referrers tld;
        search = attr:
          map
          (d: d.${attr}) # extracts the service name
          
          ( # filters to those that have defined it
            builtins.filter
            (d: !(builtins.isNull d.${attr}))
            ( # maps to their respective attrs
              map
              (name: domains.${name})
              ([tld] ++ ref) # search domains
            )
          );

        neededServices = search "acmeReloadedService";
        neededUsers = builtins.foldl' (acc: elem: "${acc},u:${elem}:rx") "u:${config.services.nginx.user}:rx" (search "acmeUser");
        name = expandDomain' tld;
      in {
        inherit name;
        value = {
          inherit (config.services.nginx) group;
          extraDomainNames = map expandDomain' ref;
          dnsProvider = "cloudflare";
          environmentFile = config.sops.templates.acme-cloudflare.path;
          postRun = ''
            # set permission on dir
            ${pkgs.acl}/bin/setfacl -m ${neededUsers} /var/lib/acme/${name}
            # set permission on key file
            ${pkgs.acl}/bin/setfacl -m ${neededUsers} /var/lib/acme/${name}/*.pem
          '';
          reloadServices = neededServices;
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
              acmeReloadedService = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                description = "The systemd service that is to be restarted when the certificate refreshes.";
                default = null;
              };
              acmeUser = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                description = "The user that will have read access to the certificate dir & file.";
                default = null;
              };
            };
        });
        description = "Attrset of local sites. the name constitutes a subdomain, an empty name means the domain apex.";
        default = {};
      };
    };
  };
  config = lib.mkIf enabled {
    sops.templates."acme-cloudflare".content = ''
      CLOUDFLARE_DNS_API_TOKEN=${config.sops.placeholder.cloudflare-token}
    '';
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
