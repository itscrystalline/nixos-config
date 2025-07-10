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
      material-symbols
      sarabun-font
      (import ./thai-sarabun-font.nix {inherit pkgs;})
    ];

    fontconfig = {
      defaultFonts = {
        serif = ["Noto Serif" "Material Symbols Rounded" "Noto Sans Thai" "Noto Color Emoji"];
        sansSerif = ["Inter" "Material Symbols Rounded" "Noto Sans Thai" "Noto Color Emoji"];
        monospace = ["JetbrainsMono Nerd Font Mono" "Material Symbols Rounded" "Noto Color Emoji"];
      };
    };
  };

  # flatpak compat
  fonts.fontDir.enable = true;

  catppuccin = {
    flavor = "mocha";
    accent = "pink";
    enable = true;

    plymouth.enable = lib.mkForce false;
    # tty.enable = true;
    # fcitx5.enable = true;
  };
}
