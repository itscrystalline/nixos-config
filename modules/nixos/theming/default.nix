{
  lib,
  config,
  pkgs,
  ...
}: let
  enabled = config.theming.enable;
in {
  imports = [./gui.nix];

  options.theming.enable = lib.mkEnableOption "Theming using stylix";
  config = lib.mkIf enabled {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      polarity = "dark";
      autoEnable = true;

      targets.plymouth.enable = false;
    };
  };
}
