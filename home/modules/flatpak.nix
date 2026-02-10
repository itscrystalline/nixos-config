{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crystal.hm.flatpak;
in {
  options.crystal.hm.flatpak.enable = lib.mkEnableOption "Flatpak support" // {default = true;};
  config = lib.mkIf cfg.enable (lib.mkIf config.gui {
    # session vars
    home.sessionVariables = {
      XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
    };
  });
}
