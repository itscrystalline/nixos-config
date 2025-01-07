{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    (prismlauncher.override {
      # Add binary required by some mod
      additionalPrograms = [ ffmpeg ];

      gamemodeSupport = true;

      # Change Java runtimes available to Prism Launcher
      jdks = [
        graalvm-ce
      ];
    })
  ];
}
