{
  config,
  pkgs,
  zen-browser,
  blender-flake,
  ...
} @ inputs: {
  imports = [
    ./gui/blender.nix
  ];

  # chromium with LINE extension
  programs.chromium = pkgs.lib.mkIf config.gui {
    enable = true;
    extensions = [
      "ophjlpahpchlmihnnnihgmmeilfjmjjc" # LINE
    ];
  };
  # desktop file
  xdg.desktopEntries.LINE = pkgs.lib.mkIf config.gui {
    name = "LINE";
    exec = "${pkgs.chromium}/bin/chromium --app=chrome-extension://ophjlpahpchlmihnnnihgmmeilfjmjjc/index.html";
    terminal = false;
    type = "Application";
    categories = [""];
    mimeType = ["x-scheme-handler/org-protocol"];
  };

  home.packages = pkgs.lib.mkIf config.gui (with pkgs.stable;
    [
      vesktop # discor
      teams-for-linux # teams :vomit:
      beeper # others
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
      keepassxc
      teamviewer
      pavucontrol
      vlc
      gparted

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

      # video, audio, and image editing
      kdenlive
      gimp
      davinci-resolve
      audacity
      aseprite
      blockbench
      figma-linux

      # wine
      wineWowPackages.waylandFull

      # fwupd
      gnome-firmware
    ]
    ++ [
      zen-browser.packages.${pkgs.system}.default
    ]
    ++ (with pkgs.unstable; [
      valent
      ghostty
      winetricks
    ]));

  programs.obs-studio = pkgs.lib.mkIf config.gui {
    enable = true;
    plugins = with pkgs.stable.obs-studio-plugins; [
      obs-composite-blur
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };

  programs.kitty = pkgs.lib.mkIf config.gui {
    enable = true;
    shellIntegration = {
      enableZshIntegration = true;
    };
  };

  programs.fuzzel.enable = config.gui;

  # Default Apps
  xdg.mimeApps = pkgs.lib.mkIf config.gui {
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
  home.sessionVariables.DEFAULT_BROWSER = pkgs.lib.optionalString config.gui "${zen-browser.packages.${pkgs.system}.default}/bin/zen";

  services.flatpak.packages = pkgs.lib.optionals config.gui [
    "com.github.tchx84.Flatseal"
  ];
}
