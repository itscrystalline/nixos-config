{
  lib,
  config,
  ...
}: let
  enabled = config.gui.enable;
in {
  options.gui.enable = lib.mkEnableOption "GUI support";
  config = lib.mkIf enabled {
    programs.dconf.enable = true;
  };
}
