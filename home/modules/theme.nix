{
  config,
  pkgs,
  lib,
  catppuccin,
  ...
} @ inputs: {
  home = lib.mkIf config.gui {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      NVD_BACKEND = "direct";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      GSK_RENDERER = "ngl";
    };

    # Steam Theme
    packages = [pkgs.adwsteamgtk];

    pointerCursor = {
      package = pkgs.catppuccin-cursors.mochaPink;
      name = "catppuccin-mocha-pink-cursors";
      size = 48;
    };

    file.".binaryninja/themes/catppuccin-mocha.bntheme".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/binary-ninja/refs/heads/main/themes/catppuccin-mocha.bntheme";
      sha256 = "sha256-VPWBEVIjcbbb7VB71KVPIjTBxr50nMpbizL5Xhuky48=";
    };
  };

  dconf.settings = lib.mkIf config.gui {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    # set cursor 3 times !!! (thanks gnome)
    "org/gnome/desktop/interface" = {
      cursor-theme = "catppuccin-mocha-pink-cursors";
      cursor-size = 16;
    };
  };

  qt = lib.mkIf config.gui {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  gtk = lib.mkIf config.gui {
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

  # kitty extra
  programs.kitty = lib.mkIf config.gui {
    font = {
      name = "Jetbrains Mono";
      size = 11;
    };
  };

  xdg.configFile = lib.mkIf config.gui {
    "blender/4.3/scripts/presets/interface_theme/mocha_pink.xml".source = pkgs.fetchurl {
      url = "https://github.com/Dalibor-P/blender/releases/download/v1.1/mocha_pink.xml";
      sha256 = "sha256-bEmn7pne5q0Cebyq6UKkluuMfGkfGf+uUMQzLUikUaU=";
    };
    "aseprite/extensions/mocha".source = pkgs.fetchzip {
      url = "https://github.com/catppuccin/aseprite/releases/download/v1.2.0/mocha.aseprite-extension";
      sha256 = "sha256-/O2ul4SQ//AU0bo1A0XAwOZAZ0R2zU0nPb6XZGOd6h8=";
      extension = "zip";
    };
    "ghostty/catppuccin-mocha".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/ghostty/refs/heads/main/themes/catppuccin-mocha.conf";
      hash = "sha256-ObWG1CqlSc79FayG7WpIetpYb/gsY4FZ9KPo44VByGk=";
    };
    "ghostty/config".text = ''
      config-file = catppuccin-mocha
      font-family = JetBrainsMono Nerd Font
      font-family = Noto Sans Thai
      font-family = Noto Sans CJK JP
      font-family = Noto Color Emoji
      font-size = 12
    '';
    "vicinae/themes/custom.json".text = builtins.toJSON {
      version = "1.0.0";
      appearance = "dark";
      icon = "";
      name = "Custom Theme";
      description = "Theme generated from NixOS defaults colorScheme";
      palette = {
        background = "#11111b";
        foreground = "#cdd6f4";
        blue = "#89b4fa";
        green = "#a6e3a1";
        magenta = "#cba6f7";
        orange = "#fab387";
        purple = "#f5c2e7";
        red = "#f38ba8";
        yellow = "#f9e2af";
        cyan = "#94e2d5";
      };
    };
  };

  catppuccin = {
    flavor = "mocha";
    accent = "pink";
    enable = true;

    gtk.enable = true;
    # kitty.enable = true;
    # zed.enable = true;
    # kvantum = {
    #   enable = true;
    #   apply = true;
    # };
    #
    # lazygit.enable = true;
    # fuzzel.enable = true;
    # btop.enable = true;
    # zsh-syntax-highlighting.enable = true;
    # nvim.enable = true;
    # cava.enable = true;
    # obs.enable = true;
  };
}
