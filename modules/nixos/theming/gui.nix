{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  enabled = config.theming.enable && config.gui.enable;
in {
  config = lib.mkIf enabled {
    environment.systemPackages = with pkgs; [
      kdePackages.qtstyleplugin-kvantum
      kdePackages.qt6ct
      libsForQt5.qt5ct
    ];

    qt.enable = true;

    fonts = {
      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        inter
        libertinus
        nerd-fonts.jetbrains-mono
        unstable.material-symbols
        sarabun-font
        inputs.my-nur.packages.${pkgs.hostsys}.sipa-th-fonts
      ];

      fontconfig = {
        defaultFonts = {
          serif = ["Libertinus Serif" "Material Symbols Rounded" "Noto Serif Thai" "Noto Color Emoji"];
          sansSerif = ["Inter" "Material Symbols Rounded" "Noto Sans CJK JP" "Noto Sans Thai" "Noto Color Emoji"];
          monospace = ["JetbrainsMono Nerd Font Mono" "Material Symbols Rounded" "Noto Color Emoji"];
        };
      };

      fontDir.enable = true;
    };

    stylix = {
      fonts = {
        sansSerif = {
          package = pkgs.inter;
          name = "Inter";
        };
        serif = {
          package = pkgs.libertinus;
          name = "Libertinus Serif";
        };
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetbrainsMono Nerd Font Mono";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
      cursor = {
        name = "catppuccin-mocha-pink-cursors";
        package = pkgs.catppuccin-cursors.mochaPink;
        size = 48;
      };
    };
  };
}
