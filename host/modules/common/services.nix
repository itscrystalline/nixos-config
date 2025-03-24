{ config, pkgs, ... }@inputs:
{
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Tailscale VPN
  services.tailscale.enable = true;
}

