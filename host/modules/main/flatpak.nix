{config, pkgs, lib, ...}: let
  cfg = config.crystal.flatpak;
in {
  options.crystal.flatpak.enable = lib.mkEnableOption "flatpak" // {default = true;};
  config = lib.mkIf cfg.enable {
  services.flatpak.enable = true;

  services.flatpak.update.onActivation = true;
  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "weekly"; # Default value
  };
  # avoid compiling gnome-software
  environment.gnome.excludePackages = [pkgs.gnome-software];
  };
}
