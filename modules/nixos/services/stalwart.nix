{
  lib,
  config,
  ...
}: let
  inherit (config.crystals-services) stalwart;
  enabled = stalwart.enable;

  p = p: let strp = builtins.toString p; in "${strp}:${strp}";
in {
  options.crystals-services.stalwart = {
    enable = lib.mkEnableOption "stalwart (docker)";

    host = lib.mkOption {
      type = lib.types.str;
      description = "Mail domain (e.g. example.com).";
      default = "";
    };
  };

  config = lib.mkIf enabled {
    assertions = [
      {
        assertion = stalwart.host != "";
        message = "crystals-services.stalwart.host must be set to a non-empty domain when enabled.";
      }
    ];

    systemd.tmpfiles.rules = [
      "d '/var/lib/stalwart' - root root - -"
    ];

    nginx.virtualHosts."stalwart.${config.crystals-services.nginx.localSuffix}".locations."/" = {
      proxyPass = "http://127.0.0.1:8080";
      proxyWebsockets = true;
    };
    virtualisation.oci-containers.containers = {
      stalwart = {
        image = "stalwartlabs/stalwart:latest";
        ports = [
          (p 25)
          (p 443)
          (p 465)
          (p 993)
          "127.0.0.1:8080:8080"
        ];
        volumes = [
          "/var/lib/stalwart:/opt/stalwart"
        ];
      };
    };
  };
}
