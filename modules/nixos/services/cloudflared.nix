{
  lib,
  config,
  ...
}: let
  inherit (config.crystals-services) cloudflared;
  inherit (lib) types;
  enabled = cloudflared.enable;
  mkDomains = attrs:
    lib.mergeAttrsList (map (key: {
      "${key}${
        if key != ""
        then "."
        else ""
      }iw2tryhard.dev" =
        attrs."${key}"
        // {
          service = "http://localhost:80";
        };
    }) (builtins.attrNames attrs));
in {
  options.crystals-services.cloudflared = {
    enable = lib.mkEnableOption "Cloudflare tunnel";
    domains = lib.mkOption {
      type = types.attrsOf types.attrs;
      description = "Domains to open to the public via cloudflare tunnels";
      default = {};
    };
  };
  config = lib.mkIf enabled {
    services.cloudflared = {
      enable = true;
      tunnels."fc4d0058-a84e-4ef5-b66f-56c2a1a7eb7f" = {
        credentialsFile = config.sops.secrets."cloudflared-credentials".path;
        ingress = mkDomains cloudflared.domains;
        warp-routing.enabled = false;
        default = "http_status:404";
      };
    };
  };
}
