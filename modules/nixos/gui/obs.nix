{
  lib,
  config,
  pkgs,
  ...
}: let
  enabled = config.gui.obs.enable && config.gui.enable && config.programs.enable;
in {
  options.gui.obs.enable = lib.mkEnableOption "OBS Studio";
  config.programs.obs-studio = lib.mkIf enabled {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      droidcam-obs
    ];
  };
}
