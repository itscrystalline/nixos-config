{
  config,
  pkgs,
  lib,
  # inputs,
  ...
}: let
  cfg = config.crystal.hm.theme;
in {
  # imports = ["${inputs.stylix-unstable}/modules/zen-browser/hm.nix"];

  options.crystal.hm.theme.enable = lib.mkEnableOption "theme configuration" // {default = true;};
  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf config.gui {
      home = {
        sessionVariables = {
          NIXOS_OZONE_WL = "1";
          NVD_BACKEND = "direct";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
          GSK_RENDERER = "ngl";
        };

        packages = [pkgs.adwsteamgtk];

        file.".binaryninja/themes/catppuccin-mocha.bntheme".source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/binary-ninja/refs/heads/main/themes/catppuccin-mocha.bntheme";
          sha256 = "sha256-VPWBEVIjcbbb7VB71KVPIjTBxr50nMpbizL5Xhuky48=";
        };
      };

      xdg.configFile = {
        "aseprite/extensions/mocha".source = pkgs.fetchzip {
          url = "https://github.com/catppuccin/aseprite/releases/download/v1.2.0/mocha.aseprite-extension";
          sha256 = "sha256-/O2ul4SQ//AU0bo1A0XAwOZAZ0R2zU0nPb6XZGOd6h8=";
          extension = "zip";
        };
      };

      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    })

    {
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
          size = 16;
        };
        targets = {
          starship.enable = false;
          zen-browser = {
            enable = config.gui;
            profileNames = ["crystal"];
          };
        };
      };
    }
  ]);
}
