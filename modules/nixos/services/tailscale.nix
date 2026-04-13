{
  lib,
  config,
  ...
}: let
  inherit (config.crystals-services) tailscale;
  enabled = tailscale.enable;
in {
  options.crystals-services.tailscale = {
    enable = lib.mkEnableOption "Tailscale";
    asExitNode = lib.mkEnableOption "the use of this host as an exit node, only if 'role' is set to 'server'.";
    role = lib.mkOption {
      type = lib.types.enum ["client" "server"];
      default = "client";
      description = "The tailscale role this host using. This is to configure required options for tailscale's features to work. If set to 'server', this also configures the auth key.";
    };
  };
  config = lib.mkIf enabled (lib.mkMerge [
    {
      network.trustedInterfaces = ["tailscale0"];
      services.tailscale = {
        enable = true;
        useRoutingFeatures = tailscale.role;
        extraSetFlags = ["--operator=${config.core.primaryUser}"];
      };
      systemd.services.tailscaled.serviceConfig.Restart = lib.mkForce "always";
    }
    (lib.mkIf (tailscale.role == "server") {
      sops.secrets."tailscale-auth-key".restartUnits = ["tailscaled-autoconnect.service"];

      services.tailscale = {
        extraSetFlags = ["--ssh"] ++ lib.optional tailscale.asExitNode "--advertise-exit-node";
        authKeyFile = config.sops.secrets.tailscale-auth-key.path;
      };
    })
  ]);
}
