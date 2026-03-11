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
      description = "The tailscale role this host using. This is to configure required options for tailscale's features to work.";
    };
  };
  config = lib.mkIf enabled {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = tailscale.role;
      extraSetFlags = ["--operator=${config.core.primaryUser}"] ++ lib.optional (tailscale.role == "server" && tailscale.asExitNode) "--advertise-exit-node";
    };
    systemd.services.tailscaled.serviceConfig.Restart = lib.mkForce "always";
  };
}
