{ pkgs, ... }:
{
  services.flatpak.enable = true;
  # avoid compiling gnome-software
  environment.gnome.excludePackages = [ pkgs.gnome-software ];
}
