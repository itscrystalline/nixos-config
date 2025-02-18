{ config, pkgs, ... }@inputs:
{
  networking.hostName = "cwystaws-meowchine";
  networking.networkmanager.enable = true;

  # Valent (KDE Connect)
  networking.firewall = rec {
    trustedInterfaces = [ "p2p-wl+" ];
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedTCPPorts = [7236 7250 8475];
    allowedUDPPortRanges = allowedTCPPortRanges;
    allowedUDPPorts = allowedTCPPorts;
  };
}
