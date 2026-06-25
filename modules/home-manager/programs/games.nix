{
  lib,
  config,
  pkgs,
  spkgs,
  options,
  ...
}: let
  inherit (config.hm.programs) games;
  enabled = games.enable;
  guiEnabled = config.hm.gui.enable;
in {
  options.hm.programs.games.enable = lib.mkEnableOption "games";

  config = lib.mkIf enabled (lib.mkIf guiEnabled {
    home.packages = with pkgs;
      [
        spkgs.prismlauncher
        itch
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        mcpelauncher-ui-qt
        nur.repos.itscrystalline.irony-mod-manager
      ];

    services = lib.optionalAttrs (options.services ? flatpak) {
      flatpak.packages = lib.optionals (pkgs.stdenv.isLinux && config.hm.flatpak.enable) [
        "org.vinegarhq.Sober"
        "com.usebottles.bottles"
      ];
    };
  });
}
