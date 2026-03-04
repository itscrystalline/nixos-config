{
  lib,
  config,
  ...
}: let
  inherit (config.hm) flatpak;
  enabled = flatpak.enable;
in {
  options.hm.flatpak.enable = lib.mkEnableOption "Flatpak support";

  config = lib.mkIf (enabled && config.hm.gui.enable) {
    home.sessionVariables.XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
  };
}
