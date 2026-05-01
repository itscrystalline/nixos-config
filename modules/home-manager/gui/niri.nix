{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.hm.gui) niri;
  inherit (config.hm.programs) gui;
  enabled = niri.enable && config.hm.gui.enable;
  guiProgramsEnabled = config.hm.programs.gui.enable;
  cliProgramsEnabled = config.hm.programs.cli.enable;
  shellEnabled = config.hm.gui.shell.enable;
in {
  options.hm.gui.niri.enable = lib.mkEnableOption "niri & friends (home-manager)";

  config = lib.mkIf (enabled && pkgs.stdenv.isLinux) {
    home.packages = [
      pkgs.xwayland-satellite
      pkgs.wl-mirror
      pkgs.wl-kbptr
    ];

    services = {
      hypridle = {
        enable = true;
        settings = let
          lock = "noctalia-shell ipc call lockScreen lock";
          screen_on = "niri msg action power-on-monitors";
          screen_off = "niri msg action power-off-monitors";
        in {
          general = {
            after_sleep_cmd = screen_on;
            ignore_dbus_inhibit = false;
            lock_cmd = lock;
            before_sleep_cmd = lock;
          };
          listener = [
            {
              timeout = 600;
              on-timeout = lock;
            }
            {
              timeout = 900;
              on-timeout = screen_off;
              on-resume = screen_on;
            }
            {
              timeout = 1200;
              on-timeout = "systemctl suspend";
              on-resume = screen_on;
            }
          ];
        };
      };
    };

    programs = lib.optionalAttrs enabled {
      niri = {
        package = pkgs.niri-stable;
        settings = {
          binds = with config.lib.niri.actions; let
            sh = spawn "sh" "-c";
            noctalia = spawn "noctalia-shell" "ipc" "call";
          in
            (lib.optionalAttrs shellEnabled {
              "Mod+Shift+Q".action = noctalia "sessionMenu" "toggle";

              "XF86AudioMute".action = noctalia "volume" "muteOutput";
              "Mod+Shift+M".action = noctalia "volume" "muteOutput";
              "XF86AudioRaiseVolume".action = noctalia "volume" "increase";
              "XF86AudioLowerVolume".action = noctalia "volume" "decrease";
              "XF86MonBrightnessUp".action = noctalia "brightness" "increase";
              "XF86MonBrightnessDown".action = noctalia "brightness" "decrease";

              "Mod+Control+Space".action = noctalia "media" "playPause";
              "Mod+Control+Equal".action = noctalia "media" "next";
              "Mod+Control+Minus".action = noctalia "media" "previous";
              "XF86AudioPlay".action = noctalia "media" "playPause";
              "XF86AudioPause".action = noctalia "media" "playPause";
              "XF86AudioNext".action = noctalia "media" "next";
              "XF86AudioPrev".action = noctalia "media" "previous";
              "XF86AudioStop".action = noctalia "media" "pause";

              "Mod+Comma".action = noctalia "settings" "toggle";
              "Mod+L".action = noctalia "lockScreen" "lock";
            })
            // (lib.optionalAttrs guiProgramsEnabled {
              "Mod+Shift+C".action = spawn "hyprpicker" "-a";
              "Mod+Space".action = lib.mkIf gui.vicinae.enable (spawn "vicinae" "toggle");
              "Mod+Shift+W".action = lib.mkIf gui.vicinae.enable (spawn "vicinae" "vicinae://launch/wm/switch-windows");

              "Mod+E".action = spawn "nautilus" "--new-window";
              "Mod+M".action = spawn "thunderbird";
              "Mod+I".action = sh ''XDG_CURRENT_DESKTOP="gnome" gnome-control-center'';
              "Mod+V".action = spawn "pavucontrol";
              "Mod+W".action = spawn "zen-twilight" "-p" "crystal";
              "Mod+B".action = spawn "neovide";
              "Mod+Return".action = spawn "ghostty";
              "Mod+Control+M".action = sh "pgrep youtube-music && niri msg action focus-workspace music || youtube-music --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime &";
              "Control+Shift+Escape".action = spawn "missioncenter";
              "XF86Calculator".action = spawn "gnome-calculator";
            })
            // {
              "Mod+Slash".action = show-hotkey-overlay;

              "Mod+1".action = focus-workspace-up;
              "Mod+2".action = focus-workspace-down;
              "Mod+Up".action = focus-window-up-or-column-right;
              "Mod+Down".action = focus-window-down-or-column-left;
              "Mod+Left".action = focus-column-or-monitor-left;
              "Mod+Right".action = focus-column-or-monitor-right;
              "Mod+WheelScrollUp".action = focus-column-right;
              "Mod+WheelScrollDown".action = focus-column-left;
              "Mod+TouchpadScrollUp".action = focus-column-right;
              "Mod+TouchpadScrollDown".action = focus-column-left;

              "Mod+Shift+1".action = move-window-up-or-to-workspace-up;
              "Mod+Shift+2".action = move-window-down-or-to-workspace-down;
              "Mod+Shift+Left".action = move-column-left;
              "Mod+Shift+Right".action = move-column-right;
              "Mod+Shift+WheelScrollUp".action = move-window-up-or-to-workspace-up;
              "Mod+Shift+WheelScrollDown".action = move-window-down-or-to-workspace-down;
              "Mod+Shift+TouchpadScrollUp".action = move-window-up-or-to-workspace-up;
              "Mod+Shift+TouchpadScrollDown".action = move-window-down-or-to-workspace-down;

              "Mod+Control+Left".action = focus-monitor-left;
              "Mod+Control+Right".action = focus-monitor-right;
              "Mod+Control+Shift+Left".action = move-window-to-monitor-left;
              "Mod+Control+Shift+Right".action = move-window-to-monitor-right;

              "Mod+J".action = consume-or-expel-window-right;
              "Mod+Minus".action = set-window-width "-10%";
              "Mod+Equal".action = set-window-width "+10%";
              "Mod+Underscore".action = set-window-height "-10%";
              "Mod+Plus".action = set-window-height "+10%";
              "Mod+Control+0".action = expand-column-to-available-width;
              "Mod+F".action = fullscreen-window;
              "Mod+Alt+F".action = toggle-windowed-fullscreen;
              "Mod+Alt+Space".action = toggle-window-floating;

              "Mod+MouseMiddle".action = focus-workspace "social";
              "Mod+Z".action = focus-workspace "social";
              "Mod+MouseBack".action = focus-workspace "music";
              "Mod+X".action = focus-workspace "music";
              "Mod+MouseForward".action = focus-workspace-previous;
              "Mod+C".action = focus-workspace-previous;

              "Mod+Q".action = close-window;
              "Mod+Grave".action = toggle-overview;
              "Mod+Tab".action = switch-preset-window-width;
              "Mod+Shift+Tab".action = switch-preset-window-height;
              "Mod+Shift+S".action.screenshot = {};
              "Mod+Shift+Alt+S".action.screenshot-window.write-to-disk = true;
              "Print".action.screenshot-screen.write-to-disk = true;

              "Mod+F1".action = switch-layout "next";

              "Mod+A".action = spawn "wl-kbptr" "-o" "modes=floating,click" "-o" "mode_floating.source=detect";
            };

          overview.backdrop-color = config.lib.stylix.colors.withHashtag.base00;
          screenshot-path = "~/Pictures/Screenshots/Screenshot at %Y-%m-%d %H-%M-%S.png";

          workspaces = {
            social.open-on-output = "eDP-1";
            music = {};
          };
          prefer-no-csd = true;

          spawn-at-startup =
            [
              {argv = ["swww-daemon" "--format" "argb"];}
              {argv = ["fcitx5"];}
              {argv = ["gnome-keyring-daemon" "--start" "--components=secrets"];}
              {argv = ["xhost" "+SI:localuser:root"];}
            ]
            ++ lib.optionals shellEnabled [
              {argv = ["swww" "img" "/home/itscrystalline/bg.gif" "--filter=Nearest"];}
              {sh = ["QT_IM_MODULE=wayland noctalia-shell"];}
            ]
            ++ lib.optionals cliProgramsEnabled [
              {argv = ["valent" "--gapplication-service"];}
            ]
            ++ lib.optionals guiProgramsEnabled [
              {argv = ["vesktop" "--enable-features=UseOzonePlatform" "--ozone-platform=wayland" "--enable-wayland-ime"];}
              {argv = ["teams-for-linux" "--enable-features=UseOzonePlatform" "--ozone-platform=wayland" "--enable-features=WebRTCPipeWireCapturer" "--enable-wayland-ime"];}
              {argv = ["keepassxc"];}
              {argv = ["thunderbird"];}
              {argv = ["rog-control-center"];}
            ];

          input = {
            focus-follows-mouse = {
              enable = true;
              max-scroll-amount = "20%";
            };
            keyboard = {
              repeat-delay = 400;
              repeat-rate = 30;
              xkb.layout = "us,us(colemak)";
            };
            mouse.accel-profile = "flat";
            touchpad = {
              accel-profile = "adaptive";
              click-method = "clickfinger";
              disabled-on-external-mouse = false;
              scroll-method = "two-finger";
              drag = true;
              dwt = true;
              tap-button-map = "left-right-middle";
              natural-scroll = true;
            };
            warp-mouse-to-focus = {
              enable = true;
              mode = "center-xy";
            };
            power-key-handling.enable = false;
          };

          outputs = {
            eDP-1 = {
              mode = {
                width = 1920;
                height = 1080;
                refresh = 144.0;
              };
              position = {
                x = 0;
                y = 0;
              };
              scale = 1;
              variable-refresh-rate = "on-demand";
            };
            HDMI-A-1 = {
              mode = {
                width = 1920;
                height = 1080;
                refresh = 100.0;
              };
              position = {
                x = 1920;
                y = 0;
              };
              scale = 1;
              variable-refresh-rate = true;
            };
          };

          layout = {
            background-color = lib.mkForce null;
            gaps = 16;
            border = {
              enable = true;
              width = 2;
            };
            focus-ring = {
              enable = true;
              width = 2;
            };
            shadow = {
              enable = true;
              draw-behind-window = true;
              offset.x = 0;
              offset.y = 0;
              spread = 16;
            };
            preset-window-heights = [
              {proportion = 1.0 / 3.0;}
              {proportion = 1.0 / 2.0;}
              {proportion = 2.0 / 3.0;}
              {proportion = 1.0;}
            ];
            preset-column-widths = [
              {proportion = 1.0 / 3.0;}
              {proportion = 1.0 / 2.0;}
              {proportion = 2.0 / 3.0;}
              {proportion = 1.0;}
            ];
            default-column-width = {};
          };

          window-rules = let
            mkWorkspace = name: workspace: proportion: {
              matches = [{app-id = name;} {title = name;}];
              open-on-workspace = workspace;
              default-column-width.proportion = proportion;
            };
          in [
            {
              geometry-corner-radius = {
                top-left = 20.0;
                bottom-left = 20.0;
                top-right = 20.0;
                bottom-right = 20.0;
              };
              clip-to-geometry = true;
            }
            (mkWorkspace "vesktop" "social" 0.6667)
            (mkWorkspace "teams-for-linux" "social" 0.6667)
            (mkWorkspace "thunderbird" "social" 0.6667)
            (mkWorkspace "LINE" "social" 0.5)
            (mkWorkspace "valent" "social" 0.5)
            {
              matches = [{app-id = "^org\.keepassxc\.KeePassXC$";}];
              open-on-workspace = "social";
              default-column-width.proportion = 0.5;
              block-out-from = "screencast";
            }
            {
              matches = [
                {
                  app-id = "^org\.keepassxc\.KeePassXC$";
                  title = "^データベースのロックを解除 - KeePassXC$";
                }
              ];
              open-focused = true;
              block-out-from = "screencast";
              open-on-workspace = null;
            }
            {
              matches = [
                {
                  app-id = "^org\.keepassxc\.KeePassXC$";
                  title = "^KeePassXC - ブラウザーのアクセス要求$";
                }
              ];
              open-focused = true;
              open-on-workspace = null;
            }
            (mkWorkspace "com.github.th_ch.youtube_music" "music" 0.6667)
            {
              matches = [{title = "^(steam)$";}];
              tiled-state = true;
            }
            {
              matches = [{app-id = "zen-twilight";}];
              open-maximized = true;
            }
            {
              matches = [
                {
                  app-id = "zen-twilight$";
                  title = "^ピクチャーインピクチャー$";
                }
              ];
              open-floating = true;
              default-column-width.proportion = 0.333;
              default-window-height.proportion = 0.333;
            }
            {
              matches = [{app-id = "org.gnome.Nautilus";}];
              default-column-width.proportion = 0.333;
            }
            {
              matches = [{app-id = "neovide";}];
              open-maximized = true;
            }
            {
              matches = [{app-id = "at.yrlf.wl_mirror";}];
              open-fullscreen = true;
              open-on-output = "HDMI-A-1";
            }
            {
              matches = [{is-window-cast-target = true;}];
              focus-ring = {
                active.color = "#f38ba8";
                inactive.color = "#7d0d2d";
                width = 6;
              };
              border.inactive.color = "#7d0d2d";
              shadow.color = "#7d0d2d70";
              tab-indicator = {
                active.color = "#f38ba8";
                inactive.color = "#7d0d2d";
              };
            }
          ];

          debug.honor-xdg-activation-with-invalid-serial = [];
        };
      };
    };
  };
}
