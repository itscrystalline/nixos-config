{
  config,
  pkgs,
  nur,
  lib,
  ...
}:
lib.mkIf config.gui {
  home.packages = with pkgs; [
    (prismlauncher.override {
      # Add binary required by some mod
      additionalPrograms = [ffmpeg];

      gamemodeSupport = true;

      # Change Java runtimes available to Prism Launcher
      jdks = [
        graalvm-ce
        zulu8
        zulu21
        nur.legacyPackages."${pkgs.system}".repos."7mind".graalvm-legacy-packages.graalvm17-ce
      ];
    })
    itch
    mcpelauncher-ui-qt
  ];
}
