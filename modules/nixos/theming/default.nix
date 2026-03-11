{
  lib,
  config,
  pkgs,
  ...
}: let
  enabled = config.theming.enable;

  boot-wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/refs/heads/main/gradients/magenta_pink.png";
    hash = "sha256-Skj2LLYAPaSZytl8v3sQvsl+fx06CIpbloue11Ti24c=";
  };
in {
  imports = [./gui.nix];

  options.theming.enable = lib.mkEnableOption "Theming using stylix";
  config = lib.mkIf enabled {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      polarity = "dark";
      autoEnable = true;
      targets = {
        plymouth.enable = false;
        limine.image = lib.mkIf (config.boot.bootloader == "limine") {
          enable = true;
          override = "${boot-wallpaper}";
        };
      };
    };
  };
}
