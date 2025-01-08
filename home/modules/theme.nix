{ config, pkgs, catppuccin, ... }@inputs:
{
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    NVD_BACKEND = "direct";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    GSK_RENDERER = "ngl";

    QT_STYLE_OVERRIDE = "kvantum";
  };

  # Steam Theme
  home.packages = [ pkgs.adwsteamgtk ];

  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.mochaPink;
    name = "catppuccin-mocha-pink-cursors";
    size = 48;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.morewaita-icon-theme;
      name = "MoreWaita";
    };
    font = {
      name = "Inter Display";
      size = 11;
    };
    cursorTheme = {
      package = pkgs.catppuccin-cursors.mochaPink;
      name = "catppuccin-mocha-pink-cursors";
      size = 16;
    };
  };

  catppuccin = {
    flavor = "mocha";
    accent = "pink";

    gtk.enable = true;
    btop.enable = true;
    zsh-syntax-highlighting.enable = true;
    nvim.enable = true;
    cava.enable = true;
    kitty.enable = true;
    zed.enable = true;
    kvantum = {
      enable = true;
      apply = true;
    };
  };

  # Blender Catppuccin
  xdg.configFile."blender/4.3/scripts/presets/interface_theme/mocha_pink.xml".source = pkgs.fetchurl {
    url = "https://github.com/Dalibor-P/blender/releases/download/v1.1/mocha_pink.xml";
    sha256 = "sha256-bEmn7pne5q0Cebyq6UKkluuMfGkfGf+uUMQzLUikUaU=";
  };
}
