{
  lib,
  config,
  pkgs,
  inputs ? {},
  ...
}: let
  guiEnabled = config.hm.programs.gui.enable;
  largePrograms = config.hm.programs.gui.largePrograms.enable;

  youtube-music = isLinux:
    if isLinux
    then
      (pkgs.youtube-music.overrideAttrs {
        desktopItems = [
          (pkgs.makeDesktopItem {
            name = "youtube-music";
            exec = "youtube-music --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime %u";
            icon = "youtube-music";
            desktopName = "Youtube Music";
            startupWMClass = "Youtube Music";
            categories = ["AudioVideo"];
          })
        ];
      })
    else pkgs.youtube-music;

  mirrorScript = pkgs.writeShellScript "niri-mirror.sh" ''
    ${pkgs.wl-mirror}/bin/wl-mirror $(niri msg --json focused-output | ${pkgs.jq}/bin/jq -r .name)
  '';
in {
  options.hm.programs.gui = {
    enable = lib.mkEnableOption "GUI apps";
    obs.enable = lib.mkEnableOption "OBS Studio";
    largePrograms.enable = lib.mkEnableOption "Large GUI apps";
  };

  config = lib.mkIf guiEnabled {
    home = {
      packages =
        (with pkgs.stable; [
          vesktop
          beeper
          keepassxc
          vlc
          blockbench
          wireshark
          gimp
        ])
        ++ [(youtube-music pkgs.stdenv.isLinux)]
        ++ lib.optionals largePrograms (with pkgs.stable; [
          kdePackages.kdenlive
          audacity
          libreoffice
          logisim-evolution
        ])
        ++ lib.optionals pkgs.stdenv.isLinux (with pkgs.stable; [
          teams-for-linux
          pavucontrol
          hyprpicker
          alsa-utils
          tesseract
          gparted
          mission-center
          wl-clipboard
        ]);

      shellAliases = lib.mkIf (pkgs.stdenv.isLinux && config.hm.gui.niri.enable) {
        mirror = "${mirrorScript}";
        open = "${lib.getExe pkgs.nautilus} . &>/dev/null &|";
      };

      sessionVariables = lib.mkIf pkgs.stdenv.isLinux {
        DEFAULT_BROWSER = lib.optionalString (inputs ? zen-browser) "${inputs.zen-browser.packages.${pkgs.hostsys}.twilight}/bin/zen";
      };
    };

    programs = {
      chromium = {
        enable = true;
        extensions = [
          "ophjlpahpchlmihnnnihgmmeilfjmjjc" # LINE
        ];
      };

      obs-studio = lib.mkIf config.hm.programs.gui.obs.enable {
        enable = true;
        plugins =
          (with pkgs.stable.obs-studio-plugins; [
            obs-composite-blur
            droidcam-obs
          ])
          ++ lib.optionals pkgs.stdenv.isLinux (with pkgs.stable.obs-studio-plugins; [
            obs-pipewire-audio-capture
          ]);
      };

      kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = true;
      };

      fuzzel.enable = true;

      ghostty = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
        settings = {
          font-size = 12;
          clipboard-paste-protection = false;
          clipboard-trim-trailing-spaces = true;
        };
        systemd.enable = pkgs.stdenv.isLinux;
      };

      zen-browser = lib.mkIf pkgs.stdenv.isLinux {
        enable = true;
        setAsDefaultBrowser = true;
        policies = let
          mkLockedAttrs = builtins.mapAttrs (_: value: {
            Value = value;
            Status = "locked";
          });
        in {
          AutofillAddressEnabled = true;
          AutofillCreditCardEnabled = false;
          DisableAppUpdate = true;
          DisableFeedbackCommands = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          Preferences = mkLockedAttrs {
            "browser.tabs.warnOnClose" = false;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          };
        };
      };
    };

    xdg = lib.mkIf pkgs.stdenv.isLinux {
      desktopEntries = {
        LINE = {
          name = "LINE";
          exec = "${pkgs.chromium}/bin/chromium --app=chrome-extension://ophjlpahpchlmihnnnihgmmeilfjmjjc/index.html";
          terminal = false;
          type = "Application";
          categories = [""];
          mimeType = ["x-scheme-handler/org-protocol"];
        };
        niri-mirror-screen = lib.mkIf config.hm.gui.niri.enable {
          name = "Start Screen Mirroring (Niri)";
          exec = "${mirrorScript}";
          terminal = false;
          type = "Application";
        };
      };

      mimeApps = {
        enable = true;
        defaultApplications = let
          desktopFile = pkg:
            builtins.head (builtins.filter (f: lib.hasSuffix ".desktop" f)
              (builtins.attrNames (builtins.readDir "${pkg}/share/applications")));
          image_viewer = desktopFile pkgs.loupe;
          pdf_viewer = desktopFile pkgs.papers;
          text_editor = desktopFile pkgs.gnome-text-editor;
          video_player = desktopFile pkgs.totem;
          archiver = desktopFile pkgs.file-roller;
          file_manager = desktopFile pkgs.nautilus;
        in {
          "inode/directory" = file_manager;
          "image/jpeg" = image_viewer;
          "image/png" = image_viewer;
          "image/gif" = image_viewer;
          "image/svg+xml" = image_viewer;
          "image/webp" = image_viewer;
          "image/bmp" = image_viewer;
          "image/tiff" = image_viewer;
          "image/x-icon" = image_viewer;
          "image/vnd.microsoft.icon" = image_viewer;
          "image/heif" = image_viewer;
          "image/heic" = image_viewer;
          "image/avif" = image_viewer;
          "application/pdf" = pdf_viewer;
          "text/plain" = text_editor;
          "text/css" = text_editor;
          "text/csv" = text_editor;
          "text/markdown" = text_editor;
          "application/json" = text_editor;
          "application/xml" = text_editor;
          "video/mp4" = video_player;
          "video/webm" = video_player;
          "video/x-msvideo" = video_player;
          "video/quicktime" = video_player;
          "video/ogg" = video_player;
          "video/mpeg" = video_player;
          "video/3gpp" = video_player;
          "video/3gpp2" = video_player;
          "video/x-matroska" = video_player;
          "application/zip" = archiver;
          "application/gzip" = archiver;
          "application/vnd.rar" = archiver;
          "application/x-7z-compressed" = archiver;
        };
      };
    };

    services.flatpak.packages = lib.optionals (pkgs.stdenv.isLinux && config.hm.flatpak.enable) [
      "com.github.tchx84.Flatseal"
      "us.zoom.Zoom"
    ];
  };
}
