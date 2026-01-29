{config, ...}: {
  programs.noctalia-shell = {
    enable = true;
    plugins = {
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = let
        mkEnable = plugins:
          builtins.listToAttrs (map (plugin: {
              name = "${plugin}";
              value = {
                enabled = true;
                sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
              };
            })
            plugins);
      in
        mkEnable ["catwalk" "privacy-indicator" "battery-threshold" "mpris-lyric" "tailscale" "noctalia-supergfxctl" "keyboard-cheatsheet"];
      version = 1;
    };
    pluginSettings = {
      catwalk = {
        minimumThreshold = 25;
        hideBackground = true;
      };
    };
    settings = {
      # configure noctalia here
      bar = {
        # density = "compact";
        position = "left";
        showCapsule = true;
        floating = true;

        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
            {
              id = "plugin:keybind-cheatsheet";
            }
            {
              id = "ActiveWindow";
            }
            {
              id = "MediaMini";
            }
          ];
          center = [
            {
              id = "Workspace";
              labelMode = "none";
            }
          ];
          right = [
            {
              id = "Tray";
            }
            {
              id = "NotificationHistory";
            }
            {
              id = "Volume";
            }
            {
              id = "Brightness";
            }
            {
              id = "Network";
            }
            {
              id = "plugin:tailscale";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "Battery";
              alwaysShowPercentage = false;
              warningThreshold = 30;
            }
            {
              id = "Clock";
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
          ];
        };
      };
      colors = with config.lib.stylix.colors.withHashtag; {
        mPrimary = base0E;
        mOnPrimary = base05;
        mSecondary = base0F;
        mOnSecondary = base05;
        mTertiary = base0D;
        mOnTertiary = base05;
        mError = base08;
        mOnError = base05;
        mSurface = base00;
        mOnSurface = base05;
        mHover = base02;
        mOnHover = base05;
        mSurfaceVariant = base01;
        mOnSurfaceVariant = base05;
        mOutline = base04;
        mShadow = base03;
      };
      general = {
        avatarImage = "${config.home.homeDirectory}/.face";
        showScreenCorners = true;
        dimmerOpacity = 0.4;
      };
      location = {
        monthBeforeDay = false;
        name = "Bangkok, Thailand";
      };
      wallpaper.enabled = false;
      dock.enabled = false;
      sessionMenu.largeButtonsStyle = true;
      desktopWidgets = {
        enabled = true;
        gridSnap = true;
        monitorWidgets = [
          {
            name = "eDP-1";
            widgets = [
              {
                clockStyle = "minimal";
                customFont = "";
                format = "HH:mm\nd MMMM yyyy";
                id = "Clock";
                roundedCorners = true;
                scale = 1.6738138369056803;
                showBackground = true;
                useCustomFont = false;
                usePrimaryColor = false;
                x = 1660;
                y = 940;
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
                scale = 0.9346110369793378;
                showBackground = true;
                x = 1660;
                y = 860;
              }
            ];
          }
        ];
      };
    };
  };
}
