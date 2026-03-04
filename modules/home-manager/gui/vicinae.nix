{
  lib,
  config,
  pkgs,
  ...
}: let
  guiEnabled = config.hm.gui.enable;
in
  lib.mkIf (guiEnabled && pkgs.stdenv.isLinux) {
    services.vicinae = {
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
