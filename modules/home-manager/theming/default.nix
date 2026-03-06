{
  lib,
  config,
  pkgs,
  inputs ? {},
  options,
  ...
}: let
  inherit (config.hm) theming;
  enabled = theming.enable;
  guiEnabled = config.hm.gui.enable;
in {
  options.hm.theming.enable = lib.mkEnableOption "theming configuration" // {default = true;};

  config = lib.mkIf enabled (lib.mkMerge [
    (lib.mkIf guiEnabled {
      home = {
        sessionVariables = {
          NIXOS_OZONE_WL = "1";
          NVD_BACKEND = "direct";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
          GSK_RENDERER = "ngl";
        };
        packages = with pkgs;
          [
            adwsteamgtk
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-color-emoji
            inter
            nerd-fonts.jetbrains-mono
            sarabun-font
            unstable.material-symbols
          ]
          ++ lib.optionals (inputs ? my-nur) [
            inputs.my-nur.packages.${pkgs.hostsys}.sipa-th-fonts
          ];
        activation.installSteamSkin = lib.hm.dag.entryAfter ["writeBoundary"] ''
          if [ -d "$HOME/.local/share/Steam" ]; then
            ${lib.getExe pkgs.adwsteamgtk} -o "color_theme:catppuccin-mocha;win_controls:adwaita;win_controls_layout:adwaita" -i || true
          fi
        '';
      };

      fonts.fontconfig = {
        enable = true;
        defaultFonts = {
          serif = ["Libertinus Serif" "Material Symbols Rounded" "Noto Serif Thai" "Noto Color Emoji"];
          sansSerif = ["Inter" "Material Symbols Rounded" "Noto Sans Thai" "Noto Sans CJK JP" "Noto Color Emoji"];
          monospace = ["JetbrainsMono Nerd Font Mono" "Material Symbols Rounded" "Noto Color Emoji"];
        };
      };

      xdg.configFile = {
        "aseprite/extensions/mocha".source = pkgs.fetchzip {
          url = "https://github.com/catppuccin/aseprite/releases/download/v1.2.0/mocha.aseprite-extension";
          sha256 = "sha256-/O2ul4SQ//AU0bo1A0XAwOZAZ0R2zU0nPb6XZGOd6h8=";
          extension = "zip";
        };
        "AdwSteamGtk/custom.css".text = with config.lib.stylix.colors; ''
          :root {
          	--adw-accent-bg-rgb: ${base0F-rgb-r}, ${base0F-rgb-g}, ${base0F-rgb-b};
          	--adw-accent-rgb: ${base06-rgb-r}, ${base06-rgb-g}, ${base06-rgb-b};
          }
        '';
        "lazygit/config.yml".text = ''
          git:
            paging:
              colorArg: always
              pager: ${pkgs.delta}/bin/delta --dark --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}"
        '';
      };

      programs.ghostty.settings.font-family = ["JetBrainsMono Nerd Font" "Noto Sans CJK JP" "Noto Sans Thai" "Noto Color Emoji"];

      dconf.settings = {
        "org/gnome/desktop/interface".color-scheme = "prefer-dark";
        "io/github/Foldex/AdwSteamGtk".prefs-install-custom-css = true;
      };
    })

    (lib.optionalAttrs (options ? stylix) {
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
        polarity = "dark";
        autoEnable = true;
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
          size = 16;
        };
        targets = {
          starship.enable = false;
          zen-browser = {
            enable = guiEnabled;
            profileNames = ["crystal"];
          };
        };
      };
    })
  ]);
}
