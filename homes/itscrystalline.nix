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
      gui = {
        enable = true;
        blender.enable = true;
        vicinae.enable = true;
      };
      cli = {
        enable = true;
        dev.enable = true;
      };
      ides.enable = true;
      games.enable = true;
    };

    services.nextcloud.enable = true;
    services.enable = true;
  };
}
