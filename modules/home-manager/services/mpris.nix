{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.hm) services;
  enabled = services.enable;
in {
  options.hm.services.enable = lib.mkEnableOption "home services" // {default = true;};

  config = lib.mkIf enabled {
    services.mpris-proxy.enable =
      pkgs.stdenv.isLinux
      && config.hm.gui.enable
      && config.hm.bluetooth.enable;
  };
}
