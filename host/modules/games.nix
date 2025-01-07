{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gamemode
    # Proton
    protonup-qt
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  };
}
