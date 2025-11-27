{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
lib.mkIf config.gui {
  environment.systemPackages = with pkgs; [
    kdePackages.qtstyleplugin-kvantum
    kdePackages.qt6ct
    libsForQt5.qt5ct

    inputs.quickshell.packages.${pkgs.system}.default
  ];

  qt.enable = true;
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      inter
      nerd-fonts.jetbrains-mono
      unstable.material-symbols
      sarabun-font
      inputs.my-nur.packages.${pkgs.system}.sipa-th-fonts
    ];

    fontconfig = {
      defaultFonts = {
        serif = ["Noto Serif" "Material Symbols Rounded" "Noto Sans Thai" "Noto Color Emoji"];
        sansSerif = ["Inter" "Material Symbols Rounded" "Noto Sans Thai" "Noto Color Emoji"];
        monospace = ["JetbrainsMono Nerd Font Mono" "Material Symbols Rounded" "Noto Color Emoji"];
      };
    };

    fontDir.enable = true;
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";
    autoEnable = true;
    fonts = rec {
      serif = {
        package = pkgs.inter;
        name = "Inter";
      };
      sansSerif = serif;
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

    targets.plymouth.enable = false;
  };
}
