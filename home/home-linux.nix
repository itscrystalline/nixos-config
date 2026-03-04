# Linux home configuration — only hm.* option values.
# Module imports and infrastructure are managed in flake.nix.
{...}: {
  hm = {
    core.username = "itscrystalline";

    gui.enable = true;
    bluetooth.enable = true;
    doas.enable = false;

    cli.enable = true;
    dev.enable = true;
    ides.enable = true;
    theme.enable = true;

    games.enable = true;
    blender.enable = true;
    flatpak.enable = true;
    virtualisation.enable = true;

    niri.enable = true;
    shell.enable = true;
    nextcloud.enable = true;
    services.enable = true;
  };
}
