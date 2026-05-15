{
  lib,
  config,
  pkgs,
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
        (prismlauncher.override {
          additionalPrograms = [ffmpeg mangohud];
          gamemodeSupport = true;
          jdks = [
            graalvmPackages.graalvm-ce
            graalvmPackages.graalvm-oracle_17
            zulu8
            zulu17
            zulu21
            zulu25
          ];
        })
        itch
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        mcpelauncher-ui-qt
        nur.repos.itscrystalline.irony-mod-manager
        bottles
      ];

    services.flatpak.packages = lib.optionals (pkgs.stdenv.isLinux && config.hm.flatpak.enable) [
      "org.vinegarhq.Sober"
    ];
  });
}
