{
  config,
  lib,
  pkgs,
  ...
}: let
  enabled = config.programs.enable && config.gui.enable;
in {
  config =
    lib.mkIf enabled {
    };
}
