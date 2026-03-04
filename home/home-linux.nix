# Standalone Linux entry point.
# Imports the full HM module system and enables the Linux-specific modules.
# For NixOS-embedded use, see homes/itscrystalline.nix instead.
{pkgs, ...}: {
  imports = [../modules/home-manager];

  hm = {
    core.username = "itscrystalline";

    # These are overridden by passthrough when embedded in NixOS;
    # set sensible standalone defaults here.
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
