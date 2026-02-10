{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crystal.niri;
in {
  options.crystal.niri.enable = lib.mkEnableOption "niri" // {default = true;};
  config = lib.mkIf cfg.enable {
    programs.niri = {
      enable = true;
      package = pkgs.niri-stable;
    };
  };
}
