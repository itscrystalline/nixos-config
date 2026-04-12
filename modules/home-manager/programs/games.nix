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
          additionalPrograms = [ffmpeg];
          gamemodeSupport = true;
          jdks = [
            graalvmPackages.graalvm-ce
            zulu8
            zulu21
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
