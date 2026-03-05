{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.hm.services) mpris-proxy;
  enabled = mpris-proxy.enable && config.hm.bluetooth.enable;
in {
  options.hm.services.mpris-proxy.enable = lib.mkEnableOption "home MPRIS proxy";

  config.services.mpris-proxy.enable = pkgs.stdenv.isLinux && enabled;
}
