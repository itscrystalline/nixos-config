{
  config,
  lib,
  ...
}: let
  enabled = config.gui.flatpak.enable;
in {
  options.gui.flatpak.enable = lib.mkEnableOption "flatpak" // {default = config.gui.enable;};
  config = lib.mkIf enabled {
    services.flatpak = {
      enable = true;

      update.onActivation = true;
      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };
  };
}
