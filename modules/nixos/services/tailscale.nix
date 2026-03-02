{
  lib,
  config,
  ...
}: let
  enabled = config.crystals-services.tailscale.enable;
in {
  options.crystals-services.tailscale.enable = lib.mkEnableOption "Tailscale";
  config.services.tailscale = lib.mkIf enabled {
    enable = true;
    extraSetFlags = ["--operator=${config.core.primaryUser}"];
  };
}
