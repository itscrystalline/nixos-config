# itscrystalline's home-manager config.
{...}: {
  hm = {
    core.username = "itscrystalline";

    bluetooth.enable = true;
    theming.enable = true;
    flatpak.enable = true;

    gui = {
      enable = true;
      niri.enable = true;
      shell.enable = true;
    };

    programs = {
      gui.enable = true;
      gui.blender.enable = true;
      gui.vicinae.enable = true;
      cli.enable = true;
      cli.dev.enable = true;
      ides.enable = true;
      games.enable = true;
    };

    services.nextcloud.enable = true;
    services.enable = true;
  };
}
