# itscrystalline's home-manager config.
{...}: {
  hm = {
    core.username = "itscrystalline";

    gui.enable = true;
    bluetooth.enable = true;

    cli.enable = true;
    dev.enable = true;
    ides.enable = true;
    theming.enable = true;

    games.enable = true;
    gui.blender.enable = true;
    flatpak.enable = true;

    niri.enable = true;
    shell.enable = true;
    services.nextcloud.enable = true;
    services.enable = true;
  };
}
