{
  lib,
  config,
  pkgs,
  options,
  ...
}: let
  inherit (lib) types;
  inherit (config.hm.programs.gui) vicinae;
  enabled = config.hm.gui.enable && vicinae.enable;
  themeEnabled = config.hm.theming.enable;
in {
  options.hm.programs.gui.vicinae = {
    enable = lib.mkEnableOption "Vicinae launcher";
    plugins = {
      own = lib.mkOption {
        type = types.listOf types.str;
        description = "List of vicinae plugins to install.";
        default = [];
      };
      raycast = lib.mkOption {
        type = types.listOf types.str;
        description = "List of vicinae-compatable raycast plugins to install.";
        default = [];
      };
    };
  };

  config = lib.mkIf (enabled && pkgs.stdenv.isLinux) {
    sops.templates."vicinae-secrets.json".content = ''
      {
        "providers": {
          "@knoopx/nix-0": {
             "preferences": {
                "githubToken": "${config.sops.placeholder.gh-token}"
             }
          }
        }
      }
    '';

    programs = lib.optionalAttrs (options.programs? vicinae) {
      vicinae = {
        enable = true;
        settings = lib.mkMerge [
          (lib.mkIf themeEnabled {
            theme = {
              light.name = "stylix";
              dark.name = "stylix";
            };
            font.normal.size = 10;
            font.normal.family = lib.head config.fonts.fontconfig.defaultFonts.sansSerif;
            launcher_window.client_side_decorations = {
              enabled = true;
              rounding = 10;
            };
          })
          {
            imports = [config.sops.templates."vicinae-secrets.json".path];
            favicon_service = "twenty";
            pop_to_root_on_close = false;
            search_files_in_root = false;
            favorites = [
              "clipboard:history"
              "core:search-emojis"
              "@knoopx/nix:packages"
              "@knoopx/nix:options"
              "@knoopx/nix:home-manager-options"
              "@tonka3000/0a3cf1ce-7de6-415c-9e37-91a892d1747e:lights"
            ];
            providers = {
              files.preferences = {
                autoIndexing = true;
                indexingPaths = ["/home/itscrystalline"];
                excludedIndexingPaths = ["/home/itscrystalline/Nextcloud/" "/home/itscrystalline/.cache/"];
              };
              "@tonka3000/0a3cf1ce-7de6-415c-9e37-91a892d1747e".preferences.instance = "http://dorm.crys";
            };
          }
        ];
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

          extensions = names: let
            src = pkgs.fetchgit {
              rev = "c7a8d7d2e3fa599922c4964a94315c55c9bfe80b";
              sha256 = "sha256-n9iCpADO7kZRNVwWhY40ID54TDWa4/amrYYvsvJpyXk=";
              url = "https://github.com/vicinaehq/extensions";
              sparseCheckout = map (e: "/extensions/${e}") names;
            };
          in
            map (ext:
              mkExtension {
                name = ext;
                src = "${src}/extensions/${ext}";
              })
            names;

          raycastExtensions = names: let
            rayCli = pkgs.fetchurl {
              url = "https://cli.raycast.com/1.86.0-alpha.65/linux/ray";
              sha256 = "sha256-UgDA2hIH7HwKl3j4UEGIlvh6eE+IWUlSML0wloHFPQw=";
            };
            sources = pkgs.fetchgit {
              rev = "427cf26de9bfbb0737d073fc6df7138c0af5d28a";
              sha256 = "sha256-tLThvYYSMApy4GtRN2v9wwTREltzXz/4GefEspD85Zs=";
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
          (extensions vicinae.plugins.own) ++ (raycastExtensions vicinae.plugins.raycast);
      };
    };
  };
}
