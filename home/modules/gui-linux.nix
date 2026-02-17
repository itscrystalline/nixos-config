{
  config,
  pkgs,
  inputs,
  secrets,
  lib,
  ...
}: let
  inherit (inputs) zen-browser;
  cfg = config.crystal.hm.guiLinux;
in {
  imports = [./gui.nix];

  options.crystal.hm.guiLinux.enable = lib.mkEnableOption "Linux GUI applications";
  config = lib.mkIf cfg.enable {
    xdg = {
      # desktop file
      desktopEntries.LINE = lib.mkIf config.gui {
        name = "LINE";
        exec = "${pkgs.chromium}/bin/chromium --app=chrome-extension://ophjlpahpchlmihnnnihgmmeilfjmjjc/index.html";
        terminal = false;
        type = "Application";
        categories = [""];
        mimeType = ["x-scheme-handler/org-protocol"];
      };

      # Default Apps
      mimeApps = lib.mkIf config.gui {
        enable = true;
        defaultApplications = let
          # Derive desktop file names from the packages themselves
          desktopFile = pkg:
            builtins.head (builtins.filter (f: lib.hasSuffix ".desktop" f)
              (builtins.attrNames (builtins.readDir "${pkg}/share/applications")));
          browser =
            if config.gui
            then zen-browser.packages.${pkgs.hostsys}.twilight.meta.desktopFileName
            else "";
          image_viewer = desktopFile pkgs.loupe;
          pdf_viewer = desktopFile pkgs.papers;
          text_editor = desktopFile pkgs.gnome-text-editor;
          video_player = desktopFile pkgs.totem;
          archiver = desktopFile pkgs.file-roller;
          file_manager = desktopFile pkgs.nautilus;
        in {
          "inode/directory" = file_manager;

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
        };
      };
    };
    home = {
      shellAliases.mirror = "${pkgs.wl-mirror}/bin/wl-mirror $(niri msg --json focused-output | ${pkgs.jq}/bin/jq -r .name)";
      sessionVariables = {
        # MOZ_LEGACY_PROFILES = 1;
        DEFAULT_BROWSER = lib.optionalString config.gui "${zen-browser.packages.${pkgs.hostsys}.twilight}/bin/zen";
      };

      packages = lib.mkIf config.gui (with pkgs.stable;
        [
          teams-for-linux # teams :vomit:
          (youtube-music.overrideAttrs {
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
          }) # YT Music
          pavucontrol

          # cli that depend on gui
          hyprpicker
          alsa-utils
          tesseract
          gparted
          mission-center
        ]
        ++ (with pkgs.unstable; [
          valent
        ]));
    };

    programs.obs-studio = lib.mkIf config.gui {
      plugins = with pkgs.stable.obs-studio-plugins; [
        obs-pipewire-audio-capture
      ];
    };

    programs.zen-browser = {
      enable = config.gui;

      policies = let
        mkLockedAttrs = builtins.mapAttrs (_: value: {
          Value = value;
          Status = "locked";
        });
        # mkExtensionSettings = builtins.map (pluginId: {
        #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
        #   installation_mode = "force_installed";
        # });
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
        # ExtensionSettings = mkExtensionSettings [
        #   "audio-equalizer-wext"
        #   "backrooms-dark-mode"
        #   "btroblox"
        #   "colorzilla"
        #   "copyfish-ocr-software"
        #   "direct-currency-converter-2"
        #   "enhancer-for-youtube"
        #   "gcr-enhancer"
        #   "google-forms-auto-filler"
        #   "istilldontcareaboutcookies"
        #   "jisho-search-plugin"
        #   "google-lighthouse"
        #   "soundfixer"
        #   "alias-url"
        #   "vim-for-docs"
        #   "wappalyzer"
        #   "tampermonkey"
        #   "youtube-recommended-videos"
        # ];
      };

      # profiles.crystal = {
      #   id = 0;
      #   isDefault = true;
      #   extensions.packages = with nur.legacyPackages."${pkgs.hostsys}".repos.rycee.firefox-addons; [
      #     dearrow
      #     decentraleyes
      #     auth-helper
      #     cookies-txt
      #     darkreader
      #     dearrow
      #     fastforwardteam
      #     firefox-color
      #     firenvim
      #     foxyproxy-standard
      #     furiganaize
      #     hover-zoom-plus
      #     indie-wiki-buddy
      #     keepassxc-browser
      #     mtab
      #     plasma-integration
      #     privacy-badger
      #     # pwas-for-firefox
      #     pronoundb
      #     react-devtools
      #     reddit-enhancement-suite
      #     return-youtube-dislikes
      #     sponsorblock
      #     steam-database
      #     stylus
      #     terms-of-service-didnt-read
      #     to-google-translate
      #     ublock-origin
      #     user-agent-string-switcher
      #     wayback-machine
      #     yomitan
      #   ];
      # };
    };

    services.flatpak.packages = lib.optionals config.gui [
      "com.github.tchx84.Flatseal"
      "us.zoom.Zoom"
    ];

    services.vicinae = {
      enable = config.gui;
      settings = {
        theme = {
          light.name = "stylix";
          dark.name = "stylix";
        };

        favicon_service = "twenty";
        font.normal.size = 10;
        pop_to_root_on_close = false;
        search_files_in_root = false;
        launcher_window.client_side_decorations = {
          enabled = true;
          rounding = 10;
        };
        favorites = [
          "clipboard:history"
          "core:search-emojis"
          "@knoopx/store.vicinae.nix:packages"
          "@knoopx/store.vicinae.nix:options"
          "@knoopx/store.vicinae.nix:home-manager-options"
          "@tonka3000/0a3cf1ce-7de6-415c-9e37-91a892d1747e:lights"
        ];
        providers = {
          "@knoopx/store.vicinae.nix".preferences.githubToken = secrets.ghToken;
          "@tonka3000/0a3cf1ce-7de6-415c-9e37-91a892d1747e".preferences.instance = secrets.homeassistant.instance;
        };
      };
      systemd = {
        enable = true;
        autoStart = true;
      };
      extensions = let
        # https://github.com/nix-community/home-manager/blob/0d782ee42c86b196acff08acfbf41bb7d13eed5b/modules/programs/vicinae.nix#L162-L180
        mkExtension = {
          name,
          src,
        }: (pkgs.buildNpmPackage {
          inherit name src;
          installPhase = ''
            runHook preInstall

            mkdir -p $out
            cp -r /build/.local/share/vicinae/extensions/${name}/* $out/

            runHook postInstall
          '';
          npmDeps = pkgs.importNpmLock {npmRoot = src;};
          inherit (pkgs.importNpmLock) npmConfigHook;
        });

        extensions = names:
          map (ext:
            mkExtension {
              name = ext;
              src =
                pkgs.fetchFromGitHub {
                  owner = "vicinaehq";
                  repo = "extensions";
                  rev = "ffbb04567d5108a0fb197aedb7642a0aa6ae7aad";
                  hash = "sha256-1Q/vrarA1M5rIIOZeSmqpC2e33ncpI7dL8AkNIHgtVo=";
                }
                + "/extensions/${ext}";
            })
          names;
        raycastExtensions = names: let
          rayCli = pkgs.fetchurl {
            url = "https://cli.raycast.com/1.86.0-alpha.65/linux/ray";
            sha256 = "sha256-UgDA2hIH7HwKl3j4UEGIlvh6eE+IWUlSML0wloHFPQw=";
          };
          sources = pkgs.fetchgit {
            rev = "4a6e46f1dae389a4f8c52f12eb5722542cdfe6f3";
            sha256 = "sha256-600VVV8DrKgL+Wk5wJGpVG/ckwvzEV948/qXj9q6vKE=";
            url = "https://github.com/raycast/extensions";
            sparseCheckout = map (e: "/extensions/${e}") names;
          };
        in
          map (
            ext:
              pkgs.buildNpmPackage {
                name = ext;
                src = "${sources}/extensions/${ext}";
                buildPhase = ''
                  runHook preBuild
                  mkdir -p node_modules/@raycast/api/bin/linux
                  cp ${rayCli} node_modules/@raycast/api/bin/linux/ray
                  chmod +x node_modules/@raycast/api/bin/linux/ray
                  npm run build
                  runHook postBuild
                '';
                installPhase = ''
                  set -x
                  runHook preInstall
                  mkdir -p $out/
                  echo
                  cp -r /build/.config/*/extensions/${ext}/* $out/
                  runHook postInstall
                '';
                npmDeps = pkgs.importNpmLock {npmRoot = "${sources}/extensions/${ext}";};
                inherit (pkgs.importNpmLock) npmConfigHook;
              }
          )
          names;
      in
        (extensions ["wifi-commander" "nix" "it-tools" "niri" "bluetooth"]) # `systemd` fails to build
        ++ (raycastExtensions ["bintools" "github" "latex-math-symbols" "gif-search" "devdocs" "homeassistant" "wikipedia" "speedtest"]);
    };
  };
}
