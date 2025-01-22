{ config, pkgs, ... }@inputs:
{
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      inter
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      material-symbols
      sarabun-font
    ];

    fontconfig = {
      defaultFonts = {
        serif = [  "Noto Serif" "Material Symbols Rounded" "Noto Sans Thai" "Noto Color Emoji" ];
        sansSerif = [ "Inter" "Material Symbols Rounded" "Noto Sans Thai" "Noto Color Emoji" ];
        monospace = [ "JetbrainsMono Nerd Font Mono" "Material Symbols Rounded" "Noto Color Emoji" ];
      };
    };
  };

  # flatpak compat
  fonts.fontDir.enable = true;

  catppuccin = {
    flavor = "mocha";
    accent = "pink";

    tty.enable = true;
    fcitx5.enable = true;
  };
}
