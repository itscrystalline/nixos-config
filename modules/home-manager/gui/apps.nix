{
  lib,
  config,
  pkgs,
  inputs ? {},
  ...
}: let
  guiEnabled = config.hm.gui.enable;
in
  lib.mkIf guiEnabled {
    home.packages =
      (with pkgs.stable; [
        vesktop
        beeper
        keepassxc
        vlc
        kdePackages.kdenlive
        gimp
        audacity
        blockbench
        libreoffice
        logisim-evolution
        wireshark
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        inter
        nerd-fonts.jetbrains-mono
        sarabun-font
      ])
      ++ [pkgs.unstable.material-symbols]
      ++ lib.optionals (inputs ? my-nur) [
        inputs.my-nur.packages.${pkgs.hostsys}.sipa-th-fonts
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin (with pkgs.stable; [
        youtube-music
      ])
      ++ lib.optionals pkgs.stdenv.isLinux (with pkgs.stable; [
        teams-for-linux
        (youtube-music.overrideAttrs {
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
        pavucontrol
        hyprpicker
        alsa-utils
        tesseract
        gparted
        mission-center
        wl-clipboard
      ])
      ++ lib.optionals pkgs.stdenv.isLinux (with pkgs.unstable; [
        valent
      ]);

    programs = {
      chromium = {
        enable = true;
        extensions = [
          "ophjlpahpchlmihnnnihgmmeilfjmjjc" # LINE
        ];
      };

      obs-studio = {
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
      desktopEntries.LINE = {
        name = "LINE";
        exec = "${pkgs.chromium}/bin/chromium --app=chrome-extension://ophjlpahpchlmihnnnihgmmeilfjmjjc/index.html";
        terminal = false;
        type = "Application";
        categories = [""];
        mimeType = ["x-scheme-handler/org-protocol"];
      };

      mimeApps = {
        enable = true;
        defaultApplications = let
          desktopFile = pkg:
            builtins.head (builtins.filter (f: lib.hasSuffix ".desktop" f)
              (builtins.attrNames (builtins.readDir "${pkg}/share/applications")));
          browser =
            lib.optionalString (inputs ? zen-browser)
            inputs.zen-browser.packages.${pkgs.hostsys}.twilight.meta.desktopFileName;
          image_viewer = desktopFile pkgs.loupe;
          pdf_viewer = desktopFile pkgs.papers;
          text_editor = desktopFile pkgs.gnome-text-editor;
          video_player = desktopFile pkgs.totem;
          archiver = desktopFile pkgs.file-roller;
          file_manager = desktopFile pkgs.nautilus;
        in {
          "inode/directory" = file_manager;
          "text/html" = browser;
          "text/xml" = browser;
          "application/xhtml+xml" = browser;
          "application/vnd.mozilla.xul+xml" = browser;
          "x-scheme-handler/http" = browser;
          "x-scheme-handler/https" = browser;
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

    home = lib.mkIf pkgs.stdenv.isLinux {
      shellAliases.mirror = "${pkgs.wl-mirror}/bin/wl-mirror $(niri msg --json focused-output | ${pkgs.jq}/bin/jq -r .name)";
      sessionVariables = {
        DEFAULT_BROWSER = lib.optionalString (inputs ? zen-browser) "${inputs.zen-browser.packages.${pkgs.hostsys}.twilight}/bin/zen";
      };
    };

    services.flatpak.packages = lib.optionals pkgs.stdenv.isLinux [
      "com.github.tchx84.Flatseal"
      "us.zoom.Zoom"
    ];

    services.vicinae = lib.mkIf pkgs.stdenv.isLinux {
      enable = true;
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
          "@knoopx/store.vicinae.nix".preferences.githubToken = config.secrets.ghToken;
          "@tonka3000/0a3cf1ce-7de6-415c-9e37-91a892d1747e".preferences.instance = config.secrets.homeassistant.instance;
        };
      };
      systemd = {
        enable = true;
        autoStart = true;
      };
      extensions = let
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
                  cp -r /build/.config/*/extensions/${ext}/* $out/
                  runHook postInstall
                '';
                npmDeps = pkgs.importNpmLock {npmRoot = "${sources}/extensions/${ext}";};
                inherit (pkgs.importNpmLock) npmConfigHook;
              }
          )
          names;
      in
        (extensions ["wifi-commander" "nix" "it-tools" "niri" "bluetooth"])
        ++ (raycastExtensions ["bintools" "github" "latex-math-symbols" "gif-search" "devdocs" "homeassistant" "wikipedia" "speedtest"]);
    };
  }
