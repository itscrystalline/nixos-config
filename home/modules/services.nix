{config, lib, ...}: let
  cfg = config.crystal.hm.services;
in {
  options.crystal.hm.services.enable = lib.mkEnableOption "services" // {default = true;};
  config = lib.mkIf cfg.enable {
    # MPRIS Proxy (Bluetooth Audio)
    services.mpris-proxy.enable = config.gui;
  };
}
