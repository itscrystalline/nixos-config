{ config, pkgs, ... }@inputs:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Tailscale VPN
  services.tailscale.enable = true;

  # TeamViewer service
  services.teamviewer.enable = true;

  # Suspend on power button click
  services.logind.extraConfig = ''
     HandlePowerKey=suspend
   '';

   # sched-ext scheduler
   # services.scx.enable = true; # by default uses scx_rustland scheduler
}
