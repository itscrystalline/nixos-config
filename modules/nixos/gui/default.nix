{
  lib,
  config,
  ...
}: let
  enabled = config.gui.enable;
in {
  imports = [
    ./flatpak.nix
    ./steam.nix
    ./graphics.nix
    ./niri.nix
    ./obs.nix
  ];

  options.gui.enable = lib.mkEnableOption "GUI support";
  config = lib.mkIf enabled {
    programs.dconf.enable = true;
  };
}
