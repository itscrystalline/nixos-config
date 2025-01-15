{ config, pkgs, ... }@inputs:
{
  networking.hostName = "cwystaws-meowchine";
  networking.networkmanager.enable = true;

  # Valent (KDE Connect)
  networking.firewall = rec {
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };
}
