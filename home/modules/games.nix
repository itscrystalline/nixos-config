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

    # Proton
    protonup-qt
  ];

  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  };
}
