{
  config,
  pkgs,
  zen-browser,
  blender-flake,
  quickshell,
  my-nur,
  lib,
  ...
} @ inputs: {
  imports = [./gui.nix];

  home.sessionVariables.QML2_IMPORT_PATH = lib.optionalString config.gui "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml:${inputs.quickshell.packages.${pkgs.system}.default}/lib/qt-6/qml";
  # desktop file
  xdg.desktopEntries.LINE = lib.mkIf config.gui {
    name = "LINE";
    exec = "${pkgs.chromium}/bin/chromium --app=chrome-extension://ophjlpahpchlmihnnnihgmmeilfjmjjc/index.html";
    terminal = false;
    type = "Application";
    categories = [""];
    mimeType = ["x-scheme-handler/org-protocol"];
  };

  home.packages = lib.mkIf config.gui (with pkgs.stable;
    [
      quickshell.packages.${pkgs.system}.default

      my-nur.packages.${pkgs.system}.app2nix

      teams-for-linux # teams :vomit:
      (youtube-music.overrideAttrs (finalAttrs: previousAttrs: {
        desktopItems = [
          (makeDesktopItem {
            name = "youtube-music";
            exec = "youtube-music --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime %u";
            icon = "youtube-music";
            desktopName = "Youtube Music";
            startupWMClass = "Youtube Music";
            categories = ["AudioVideo"];
          })
        ];
      })) # YT Music
      teamviewer
      pavucontrol

      # cli that depend on gui
      copyq
      grim
      hyprpicker
      slurp
      wl-clipboard
      alsa-utils
      bemoji
      tesseract

      gnome-network-displays
      gparted

      figma-linux

      # wine
      wineWowPackages.waylandFull

      # fwupd
      gnome-firmware

      mission-center
      zen-browser.packages.${pkgs.system}.default

      # vicinae
      # my-nur.packages.${pkgs.system}.vicinae
    ]
    ++ (with pkgs.unstable; [
      valent
      winetricks
    ]));

  programs.obs-studio = lib.mkIf config.gui {
    plugins = with pkgs.stable.obs-studio-plugins; [
      obs-pipewire-audio-capture
    ];
  };

  # Default Apps
  xdg.mimeApps = lib.mkIf config.gui {
    enable = true;
    defaultApplications = (
      let
        browser = "zen.desktop";
        image_viewer = "org.gnome.Loupe.desktop";
        pdf_viewer = "org.gnome.Evince.desktop";
        text_editor = "org.gnome.TextEditor.desktop";
        video_player = "org.gnome.Totem.desktop";
        archiver = "org.gnome.FileRoller.desktop";
      in {
        # Browser-related MIME types
        "text/html" = browser;
        "text/xml" = browser;
        "application/xhtml+xml" = browser;
        "application/vnd.mozilla.xul+xml" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;

        # Image MIME types
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

        # PDF MIME types
        "application/pdf" = pdf_viewer;

        # Text file MIME types
        "text/plain" = text_editor;
        "text/css" = text_editor;
        "text/csv" = text_editor;
        "text/markdown" = text_editor;
        "application/json" = text_editor;
        "application/xml" = text_editor;

        # Video MIME types
        "video/mp4" = video_player;
        "video/webm" = video_player;
        "video/x-msvideo" = video_player; # AVI
        "video/quicktime" = video_player; # MOV
        "video/ogg" = video_player;
        "video/mpeg" = video_player;
        "video/3gpp" = video_player;
        "video/3gpp2" = video_player;
        "video/x-matroska" = video_player; # MKV

        # Archive MIME types (optional)
        "application/zip" = archiver;
        "application/gzip" = archiver;
        "application/vnd.rar" = archiver;
        "application/x-7z-compressed" = archiver;
      }
    );
  };
  home.sessionVariables.DEFAULT_BROWSER = lib.optionalString config.gui "${zen-browser.packages.${pkgs.system}.default}/bin/zen";

  xdg.configFile = lib.mkIf config.gui {
    "uwsm/env".text = ''
      export QT_IM_MODULE=fcitx
      export XMODIFIERS=@im=fcitx
      export SDL_IM_MODULE=fcitx
      export GLFW_IM_MODULE=ibus
      export INPUT_METHOD=fcitx
      export GTK_IM_MODULE=fcitx

      export QT_QPA_PLATFORM=wayland

      export ILLOGICAL_IMPULSE_VIRTUAL_ENV=~/.local/state/ags/.venv
    '';
    "uwsm/env-hyprland".text = ''
      export AQ_DRM_DEVICES="/dev/dri/card1:/dev/dri/card0"
      export GRIMBLAST_HIDE_CURSOR=0
      export GSK_RENDERER=ngl
    '';
    "swapy/config".text = ''
      [Default]
      save_dir=$HOME/Pictures/Screenshots
      save_filename_format=Screenshot_%Y-%m-%d_%H.%M.%S.png
      show_panel=false
      line_size=5
      text_size=20
      text_font=sans-serif
      paint_mode=brush
      early_exit=false
      fill_shape=false
      auto_save=false
      custom_color=rgba(193,125,17,1)
    '';
  };

  services.flatpak.packages = lib.optionals config.gui [
    "com.github.tchx84.Flatseal"
  ];

  services.vicinae = lib.mkIf config.gui {
    enable = true; # default: false
    autoStart = true; # default: true
  };
}
