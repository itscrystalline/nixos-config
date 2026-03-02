{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (inputs) my-nur;
  cfg = config.crystal.hm.games;
in {
  options.crystal.hm.games.enable = lib.mkEnableOption "games";
  config = lib.mkIf cfg.enable (lib.mkIf config.gui {
    home.packages = with pkgs; [
      (prismlauncher.override {
        # Add binary required by some mod
        additionalPrograms = [ffmpeg];

        gamemodeSupport = true;

        # Change Java runtimes available to Prism Launcher
        jdks = [
          graalvmPackages.graalvm-ce
          zulu8
          zulu21
          # nur.legacyPackages."${pkgs.hostsys}".repos."7mind".graalvm-legacy-packages.graalvm17-ce
        ];
      })
      itch
      mcpelauncher-ui-qt

      my-nur.packages.${pkgs.hostsys}.irony-mod-manager
    ];
  });
}
