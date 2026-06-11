{
  lib,
  config,
  pkgs,
  options,
  ...
}: let
  inherit (config.hm.gui) shell;
  enabled = shell.enable;
  guiEnabled = config.hm.gui.enable;
  nextcloudEnabled = config.hm.services.nextcloud.enable;
in {
  options.hm.gui.shell.enable = lib.mkEnableOption "Noctalia shell";

  config = lib.mkIf (enabled && guiEnabled) (lib.mkMerge [
    {
      home.packages = with pkgs; [
        qt6.qtwebsockets
        grim
        slurp
        wl-clipboard
        tesseract
        imagemagick
        zbar
        curl
        translate-shell
        wl-screenrec
        ffmpeg
        jq
      ];
    }
    (lib.optionalAttrs (options.programs ? noctalia) {
      sops = lib.mkIf nextcloudEnabled {
        secrets."nextcloud-caldav" = {};
        templates."noctalia-state.toml" = {
          path = "${config.home.homeDirectory}/.local/state/noctalia/state.toml";
          content = ''
            [calendar_credentials]
            nextcloud_password = "${config.sops.placeholder.nextcloud-caldav}"
          '';
        };
      };

      programs.noctalia = {
        enable = true;
        systemd.enable = true;

        settings = {
          shell = {
            font-family = lib.head config.fonts.fontconfig.defaultFonts.sansSerif;
            lang = "en";
            polkit_agent = true;
            avatar_path = "~/.face";
            clipboard_enabled = false;
            launch_apps_as_systemd_services = true;

            panel = {
              wallpaper_placement = "centered";
              session_placement = "centered";
            };

            screenshot = {
              directory = "~/Pictures/Screenshots";
              filename_pattern = "Screenshot at %Y-%m-%d %H-%M-%S";
              copy_to_clipboard = true;
              freeze_screen = true;
            };

            screen_corners = {
              enabled = true;
              size = 32;
            };
          };

          bar.main = {
            position = "left";
            capsule = false;
            margin_edge = 8;
            margin_ends = 8;
            padding = 12;
            radius = 80;
            thickness = 32;

            start = ["control-center" "active_window" "media"];
            center = ["lock_keys" "taskbar" "sysmon"];
            end = ["tray" "notifications" "group:conn-media" "group:bat" "clock" "session"];

            capsule_group = [
              {
                id = "conn-media";
                members = ["network" "bluetooth" "volume"];
              }
              {
                id = "bat";
                members = ["brightness" "battery"];
              }
            ];
          };
          widget = {
            taskbar = {
              group_by_workspace = true;
              hide_empty_workspaces = true;
              show_workspace_label = false;
              inactive_opacity = 0.8;
            };
            sysmon.show_label = false;
            network.show_label = false;
            volume.show_label = false;
            brightness.show_label = false;
            battery.display_mode = "graphic";
            clock.capsule = true;
          };

          wallpaper = {
            enabled = true;
            fill_color = config.lib.stylix.colors.withHashtag.base00;
            transition_on_startup = true;
            default.path = "/home/itscrystalline/bg.png";
          };

          theme = {
            mode = "dark"; # dark | light | auto
            source = "builtin"; # builtin | wallpaper | community | custom
            builtin = "Catppuccin"; # bundled palette name
          };

          brightness.enable_ddcutil = true;

          audio = {
            enable_overdrive = true;
            enable_sounds = true;
          };
          calendar = {
            enabled = true;
            account.nextcloud = lib.mkIf nextcloudEnabled {
              type = "caldav";
              name = "Nextcloud";
              provider = "custom";
              server_url = "https://nc.iw2tryhard.dev/remote.php/dav/";
              username = "itscrystalline";
              calendars = []; # optional discovered collection ids; empty = all
            };
          };

          idle = {
            pre_action_fade_seconds = 1.5;
            behavior = {
              lock = {
                enabled = true;
                timeout = 600;
                command = "noctalia:session lock";
              };
              screen-off = {
                enabled = true;
                timeout = 900;
                command = "noctalia:dpms-off";
                resume_command = "noctalia:dpms-on";
              };
              suspend = {
                enabled = true;
                timeout = 1200;
                command = "noctalia:session suspend";
                resume_command = "noctalia:dpms-on";
              };
            };
          };

          location = {
            auto_locate = true;
            address = "Bangkok, TH";
          };
          weather.enable = true;

          hooks = {
            battery_charging = "niri msg output eDP-1 mode 1920x1080@144.003; noctalia msg brightness-set 100; brightnessctl -d asus::kbd_backlight set 3; asusctl profile -P Balanced";
            battery_plugged = "niri msg output eDP-1 mode 1920x1080@144.003; noctalia msg brightness-set 100; brightnessctl -d asus::kbd_backlight set 3; asusctl profile -P Balanced";
            battery_discharging = "niri msg output eDP-1 mode 1920x1080@60.004; noctalia msg brightness-set 65; brightnessctl -d asus::kbd_backlight set 0; asusctl profile -P LowPower";
          };
        };
      };
    })
  ]);
}
