{pkgs, ...}: {
  services.flatpak.enable = true;

  services.flatpak.update.onActivation = true;
  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "weekly"; # Default value
  };
  # avoid compiling gnome-software
  environment.gnome.excludePackages = [pkgs.gnome-software];
}
