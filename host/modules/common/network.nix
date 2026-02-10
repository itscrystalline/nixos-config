{
  config,
  lib,
  pkgs,
  ...
} @ inputs: let
  cfg = config.crystal.network;
in {
  options.crystal.network.enable = lib.mkEnableOption "network settings" // {default = true;};

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;
    networking.firewall.enable = true;
  };
}
