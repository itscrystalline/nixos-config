{
  lib,
  config,
  ...
}: let
  enabled = config.crystals-services.tailscale.enable;
in {
  options.crystals-services.tailscale.enable = lib.mkEnableOption "Tailscale";
  config = lib.mkIf enabled {
    services.tailscale = {
      enable = true;
      extraSetFlags = ["--operator=${config.core.primaryUser}"];
    };
    systemd.services.tailscaled.serviceConfig.Restart = lib.mkForce "always";
  };
}
