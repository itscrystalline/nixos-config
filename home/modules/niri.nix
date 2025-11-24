{
  options,
  config,
  pkgs,
  ...
}: {
  programs =
    if builtins.hasAttr "niri" options.programs
    then {
      niri = {
        enable = true;
        package = pkgs.niri-stable;
        settings = {
          binds = with config.lib.niri.actions; let
            sh = spawn "sh" "-c";
          in {
            "Mod+Shift+Q".action = quit;

            "Mod+XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_SOURCE@" "toggle";
            "XF86AudioMute".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0%";
            "Mod+Shift+M".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0%";
            "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "5%+";
            "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-";
            "XF86MonBrightnessUp".action = spawn "brightnessctl" "set" "12.75+";
            "XF86MonBrightnessDown".action = spawn "brightnessctl" "set" "12.75-";

            "Mod+Control+Space".action = spawn "playerctl" "play-pause";
            "Mod+Control+Equal".action = spawn "playerctl" "next";
            "Mod+Control+Minus".action = spawn "playerctl" "previous";
            "XF86AudioPlay".action = spawn "playerctl" "play-pause";
            "XF86AudioPause".action = spawn "playerctl" "play-pause";
            "XF86AudioNext".action = spawn "playerctl" "next";
            "XF86AudioPrev".action = spawn "playerctl" "previous";
            "XF86AudioStop".action = spawn "playerctl" "stop";

            "Mod+1".action = focus-workspace-up;
            "Mod+2".action = focus-workspace-down;
            "Mod+Up".action = focus-window-up-or-column-right;
            "Mod+Down".action = focus-window-down-or-column-left;
            "Mod+Left".action = focus-window-or-monitor-left;
            "Mod+Right".action = focus-window-or-monitor-right;
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

            "Mod+Minus".action = set-window-width "-10%";
            "Mod+Equal".action = set-window-width "+10%";
            "Mod+Underscore".action = set-window-height "-10%";
            "Mod+Plus".action = set-window-height "+10%";
            "Mod+Control+Plus".action = expand-column-to-available-width;
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
            "Mod+Shift+S".action = screenshot;
            "Mod+Shift+C".action = spawn "hyprpicker" "-a";
            "Mod+Shift+Alt+S".action = screenshot_window {write-to-disk = true;};
            "Print".action = {
              screenshot-screen = 1;
              write-to-disk = true;
            };
            "Mod+Alt+R".action = spawn "ignis" "run-command" "recorder-record-region";
            "Mod+Alt+Shift+R".action = spawn "ignis" "run-command" "recorder-record-screen";
            "Mod+Alt+Control+R".action = spawn "ignis" "run-command" "recorder-record-portal";

            "Mod+Space".action = spawn "vicinae" "toggle";
            "Mod+E".action = spawn "nautilus" "--new-window";
            "Mod+I".action = sh ''XDG_CURRENT_DESKTOP="gnome" gnome-control-center'';
            "Mod+V".action = spawn "pavucontrol";
            "Mod+W".action = spawn "zen";
            "Mod+B".action = spawn "neovide";
            "Mod+Return".action = spawn "ghostty";
            "Mod+L".action = spawn "hyprlock";
            "Mod+Control+Alt".action = sh "pgrep youtube-music && niri msg action focus-workspace music || youtube-music --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime &";
            "Control+Shift+Escape".action = spawn "missioncenter";
          };
          switch-events.lid-close.action.spawn = ["systemctl" "suspend"];

          screenshot-path = "~/Pictures/Screenshots/Screenshot at %Y-%m-%d %H-%M-%S.png";
          workspaces = {
            social.open-on-output = "eDP-1";
            music = {};
          };

          prefer-no-csd = true;

          spawn-at-startup = [
            {argv = ["swww-daemon" "--format" "xrgb"];}
            {argv = ["fcitx5"];}
            {argv = ["hypridle"];}
            {argv = ["gnome-keyring-daemon" "--start" "--components=secrets"];}
            {argv = ["xhost" "+SI:localuser:root"];}
            {argv = ["swww" "img" "/home/itscrystalline/bg.gif" "--filter=Nearest"];}
            {argv = ["ignis" "init"];}

            {argv = ["vesktop" "--enable-features=UseOzonePlatform" "--ozone-platform=wayland" "--enable-wayland-ime"];}
            {argv = ["teams-for-linux" "--enable-features=UseOzonePlatform" "--ozone-platform=wayland" "--enable-features=WebRTCPipeWireCapturer" "--enable-wayland-ime"];}
            {argv = ["keepassxc"];}
            {argv = ["rog-control-center"];}
            {argv = ["valent" "--gapplication-service"];}
          ];

          input = {
            focus-follows-mouse.enable = true;
            keyboard = {
              repeat-delay = 400;
              repeat-rate = 30;
              xkb.layout = "us";
            };
            mouse.accel-profile = "flat";
            touchpad = {
              accel-profile = "adaptive";
              click-method = "clickfinger";
              disabled-on-external-mouse = true;
              drag = true;
              dwt = true;
              tap-button-map = "left-right-middle";
            };
            warp-mouse-to-focus = {
              enable = true;
              mode = "center-xy";
            };
          };
        };
      };
    }
    else {};
}
