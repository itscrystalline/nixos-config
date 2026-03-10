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
  options.hm.theming.enable = lib.mkEnableOption "theming configuration";

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
      stylix = lib.mkMerge [
        {
          enable = true;
          base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
          polarity = "dark";
          autoEnable = true;

          targets.starship.enable = false;
        }

        (lib.mkIf guiEnabled {
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

          targets.zen-browser = {
            enable = true;
            profileNames = ["crystal"];
          };
        })
      ];
    })

    {
      programs.eza.theme = {
        colourful = true;
        filekinds = {
          normal = {foreground = "#BAC2DE";};
          directory = {foreground = "#89B4FA";};
          symlink = {foreground = "#89DCEB";};
          pipe = {foreground = "#7F849C";};
          block_device = {foreground = "#EBA0AC";};
          char_device = {foreground = "#EBA0AC";};
          socket = {foreground = "#585B70";};
          special = {foreground = "#CBA6F7";};
          executable = {foreground = "#A6E3A1";};
          mount_point = {foreground = "#74C7EC";};
        };
        perms = {
          user_read = {foreground = "#CDD6F4";};
          user_write = {foreground = "#F9E2AF";};
          user_execute_file = {foreground = "#A6E3A1";};
          user_execute_other = {foreground = "#A6E3A1";};
          group_read = {foreground = "#BAC2DE";};
          group_write = {foreground = "#F9E2AF";};
          group_execute = {foreground = "#A6E3A1";};
          other_read = {foreground = "#A6ADC8";};
          other_write = {foreground = "#F9E2AF";};
          other_execute = {foreground = "#A6E3A1";};
          special_user_file = {foreground = "#CBA6F7";};
          special_other = {foreground = "#585B70";};
          attribute = {foreground = "#A6ADC8";};
        };
        size = {
          major = {foreground = "#A6ADC8";};
          minor = {foreground = "#89DCEB";};
          number_byte = {foreground = "#CDD6F4";};
          number_kilo = {foreground = "#BAC2DE";};
          number_mega = {foreground = "#89B4FA";};
          number_giga = {foreground = "#CBA6F7";};
          number_huge = {foreground = "#CBA6F7";};
          unit_byte = {foreground = "#A6ADC8";};
          unit_kilo = {foreground = "#89B4FA";};
          unit_mega = {foreground = "#CBA6F7";};
          unit_giga = {foreground = "#CBA6F7";};
          unit_huge = {foreground = "#74C7EC";};
        };
        users = {
          user_you = {foreground = "#CDD6F4";};
          user_root = {foreground = "#F38BA8";};
          user_other = {foreground = "#CBA6F7";};
          group_yours = {foreground = "#BAC2DE";};
          group_other = {foreground = "#7F849C";};
          group_root = {foreground = "#F38BA8";};
        };
        links = {
          normal = {foreground = "#89DCEB";};
          multi_link_file = {foreground = "#74C7EC";};
        };
        git = {
          new = {foreground = "#A6E3A1";};
          modified = {foreground = "#F9E2AF";};
          deleted = {foreground = "#F38BA8";};
          renamed = {foreground = "#94E2D5";};
          typechange = {foreground = "#F5C2E7";};
          ignored = {foreground = "#7F849C";};
          conflicted = {foreground = "#EBA0AC";};
        };
        git_repo = {
          branch_main = {foreground = "#CDD6F4";};
          branch_other = {foreground = "#CBA6F7";};
          git_clean = {foreground = "#A6E3A1";};
          git_dirty = {foreground = "#F38BA8";};
        };
        security_context = {
          colon = {foreground = "#7F849C";};
          user = {foreground = "#BAC2DE";};
          role = {foreground = "#CBA6F7";};
          typ = {foreground = "#585B70";};
          range = {foreground = "#CBA6F7";};
        };
        file_type = {
          image = {foreground = "#F9E2AF";};
          video = {foreground = "#F38BA8";};
          music = {foreground = "#A6E3A1";};
          lossless = {foreground = "#94E2D5";};
          crypto = {foreground = "#585B70";};
          document = {foreground = "#CDD6F4";};
          compressed = {foreground = "#F5C2E7";};
          temp = {foreground = "#EBA0AC";};
          compiled = {foreground = "#74C7EC";};
          build = {foreground = "#585B70";};
          source = {foreground = "#89B4FA";};
        };
        punctuation = {foreground = "#7F849C";};
        date = {foreground = "#F9E2AF";};
        inode = {foreground = "#A6ADC8";};
        blocks = {foreground = "#9399B2";};
        header = {foreground = "#CDD6F4";};
        octal = {foreground = "#94E2D5";};
        flags = {foreground = "#CBA6F7";};
        symlink_path = {foreground = "#89DCEB";};
        control_char = {foreground = "#74C7EC";};
        broken_symlink = {foreground = "#F38BA8";};
        broken_path_overlay = {foreground = "#585B70";};
      };
    }
  ]);
}
