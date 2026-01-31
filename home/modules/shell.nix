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
        mkEnable ["privacy-indicator" "battery-threshold" "tailscale" "keybind-cheatsheet"];
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
            {
              compactMode = false;
              compactShowAlbumArt = true;
              compactShowVisualizer = false;
              hideMode = "hidden";
              hideWhenIdle = false;
              id = "MediaMini";
              maxWidth = 145;
              panelShowAlbumArt = true;
              panelShowVisualizer = true;
              scrollingMode = "hover";
              showAlbumArt = true;
              showArtistFirst = true;
              showProgressRing = true;
              showVisualizer = false;
              useFixedWidth = false;
              visualizerType = "linear";
            }
            {
              id = "plugin:keybind-cheatsheet";
            }
          ];
          center = [
            {
              id = "plugin:tailscale";
            }
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
            {
              id = "plugin:privacy-indicator";
            }
          ];
          right = [
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
              showNoctaliaPerformance = false;
              showPowerProfiles = false;
              warningThreshold = 30;
            }
            {
              id = "plugin:battery-threshold";
            }
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
        language = "en";
        avatarImage = "${config.home.homeDirectory}/.face";
        showScreenCorners = true;
        dimmerOpacity = 0.4;
        forceBlackScreenCorners = true;
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
}
