{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.hm.gui) shell;
  enabled = shell.enable;
  guiEnabled = config.hm.gui.enable;
  niriEnabled = config.hm.gui.niri.enable;
in {
  options.hm.gui.shell.enable = lib.mkEnableOption "Noctalia shell";

  config = lib.mkIf (enabled && guiEnabled) {
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
      gifski
      jq
    ];
    programs.noctalia-shell = {
      enable = true;
      plugins = {
        sources = [
          {
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
          {
            enabled = true;
            name = "Crystal's Noctalia Plugins";
            url = "https://github.com/itscrystalline/noctalia-plugins";
          }
        ];
        states = let
          mkEnable = host: plugins:
            builtins.listToAttrs (map (plugin: {
                name = plugin;
                value = {
                  enabled = true;
                  sourceUrl = "https://github.com/${host}/noctalia-plugins";
                };
              })
              plugins);
        in
          mkEnable "noctalia-dev" [
            "privacy-indicator"
            "tailscale"
            "keybind-cheatsheet"
            "battery-threshold"
            "battery-actions"
            "polkit-agent"
            "usb-drive-manager"
            "hassio"
            "screen-toolkit"
            "lyrics-fetch"
          ];
        version = 1;
      };
      pluginSettings = {
        tailscale = {
          refreshInterval = 10000;
          compactMode = true;
          showIpAddress = false;
          showPeerCount = false;
          hideDisconnected = false;
          terminalCommand = "ghostty";
          pingCount = 5;
          defaultPeerAction = "copy-ip";
        };
        privacy-indicator = {
          hideInactive = true;
          iconSpacing = 4;
          removeMargins = false;
        };
        battery-threshold = {
          chargeThreshold = 85;
          batteryDevice = "/sys/class/power_supply/BAT1";
        };
        battery-actions = lib.mkIf niriEnabled {
          pluggedInScript = "niri msg output eDP-1 mode 1920x1080@144.003; noctalia-shell ipc call brightness set 100%; noctalia-shell ipc call powerProfile disableNoctaliaPerformance; brightnessctl -d asus::kbd_backlight set 3; asusctl profile -P Balanced";
          onBatteryScript = "niri msg output eDP-1 mode 1920x1080@60.004; noctalia-shell ipc call brightness set 65%; noctalia-shell ipc call powerProfile enableNoctaliaPerformance; brightnessctl -d asus::kbd_backlight set 0; asusctl profile -P LowPower";
        };
      };
      settings = {
        ui = {
          fontDefault = "Inter";
          fontFixed = lib.mkForce "JetbrainsMono NF";
        };
        bar = {
          position = "left";
          showCapsule = true;
          floating = true;
          widgets = {
            left = [
              {
                colorizeDistroLogo = false;
                colorizeSystemIcon = "primary";
                customIconPath = "";
                enableColorization = true;
                icon = "noctalia";
                id = "ControlCenter";
                useDistroLogo = true;
              }
              {
                colorizeIcons = false;
                hideMode = "hidden";
                id = "ActiveWindow";
                maxWidth = 145;
                scrollingMode = "hover";
                showIcon = true;
                useFixedWidth = false;
              }
              {id = "plugin:lyrics-fetch";}
              {id = "plugin:keybind-cheatsheet";}
            ];
            center = [
              {id = "plugin:screen-toolkit";}
              {id = "plugin:tailscale";}
              {
                characterCount = 2;
                colorizeIcons = false;
                emptyColor = "secondary";
                enableScrollWheel = true;
                focusedColor = "primary";
                followFocusedScreen = false;
                groupedBorderOpacity = 1;
                hideUnoccupied = true;
                iconScale = 0.8;
                id = "Workspace";
                labelMode = "none";
                occupiedColor = "secondary";
                reverseScroll = false;
                showApplications = true;
                showBadge = true;
                showLabelsOnlyWhenOccupied = true;
                unfocusedIconsOpacity = 0.65;
              }
              {id = "plugin:privacy-indicator";}
              {
                autoMount = true;
                fileBrowser = "xdg-open";
                terminalCommand = "ghostty";
                showNotifications = true;
                hideWhenEmpty = false;
                showBadge = true;
                id = "plugin:usb-drive-manager";
              }
            ];
            right = [
              {id = "plugin:hassio";}
              {
                blacklist = [];
                colorizeIcons = false;
                drawerEnabled = true;
                hidePassive = false;
                id = "Tray";
                pinned = [];
              }
              {
                hideWhenZero = false;
                hideWhenZeroUnread = false;
                id = "NotificationHistory";
                showUnreadBadge = true;
                unreadBadgeColor = "primary";
              }
              {
                displayMode = "onhover";
                id = "Volume";
                middleClickCommand = "pwvucontrol || pavucontrol";
              }
              {
                displayMode = "onhover";
                id = "Brightness";
              }
              {
                displayMode = "onhover";
                id = "Network";
              }
              {
                displayMode = "onhover";
                id = "Bluetooth";
              }
              {
                deviceNativePath = "";
                displayMode = "onhover";
                hideIfIdle = false;
                hideIfNotDetected = true;
                id = "Battery";
                showNoctaliaPerformance = true;
                showPowerProfiles = false;
                warningThreshold = 30;
              }
              {id = "plugin:battery-threshold";}
              {
                customFont = "Inter Display ExtraBold";
                formatHorizontal = "HH:mm";
                formatVertical = "HH mm";
                id = "Clock";
                tooltipFormat = "HH:mm ddd, MMM dd";
                useCustomFont = true;
                usePrimaryColor = true;
              }
            ];
          };
        };
        colorSchemes.predefinedScheme = "Catppuccin";
        plugins.autoUpdate = false;
        general = {
          language = "en";
          avatarImage = "${config.home.homeDirectory}/.face";
          showScreenCorners = true;
          dimmerOpacity = 0.4;
          forceBlackScreenCorners = true;
        };
        location = {
          name = "Helsinki";
          monthBeforeDay = false;
        };
        wallpaper.enabled = false;
        dock.enabled = false;
        sessionMenu.largeButtonsStyle = true;
        desktopWidgets = {
          enabled = true;
          gridSnap = false;
          monitorWidgets = [
            {
              name = "eDP-1";
              widgets = [
                {
                  clockStyle = "minimal";
                  customFont = "";
                  format = "HH:mm\\nd MMMM yyyy";
                  id = "Clock";
                  roundedCorners = true;
                  scale = 1.310832355896586;
                  showBackground = true;
                  useCustomFont = false;
                  usePrimaryColor = false;
                  x = 1600;
                  y = 949;
                }
                {
                  hideMode = "visible";
                  id = "MediaPlayer";
                  roundedCorners = true;
                  showAlbumArt = true;
                  showBackground = true;
                  showButtons = true;
                  showVisualizer = true;
                  visualizerType = "linear";
                  x = 48;
                  y = 992;
                }
                {
                  id = "Weather";
                  scale = 1.146743071335302;
                  showBackground = true;
                  x = 1599;
                  y = 838;
                }
              ];
            }
            {
              name = "HDMI-A-1";
              widgets = [
                {
                  clockStyle = "minimal";
                  customFont = "";
                  format = "HH:mm\\nd MMMM yyyy";
                  id = "Clock";
                  roundedCorners = true;
                  scale = 2.2303657992645927;
                  showBackground = true;
                  useCustomFont = false;
                  usePrimaryColor = false;
                  x = 1578;
                  y = 911;
                }
                {
                  hideMode = "visible";
                  id = "MediaPlayer";
                  roundedCorners = true;
                  scale = 1.1414213562373094;
                  showAlbumArt = true;
                  showBackground = true;
                  showButtons = true;
                  showVisualizer = true;
                  visualizerType = "linear";
                  x = 1448;
                  y = 16;
                }
              ];
            }
          ];
        };
      };
    };
  };
}
