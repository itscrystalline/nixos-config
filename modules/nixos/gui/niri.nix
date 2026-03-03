{
  config,
  pkgs,
  lib,
  ...
}: let
  enabled = config.gui.niri.enable && config.gui.enable;
in {
  options.crystal.niri.enable = lib.mkEnableOption "niri & friends";
  config = lib.mkIf enabled {
    programs = {
      niri.enable = true;
      niri.package = pkgs.niri-stable;

      ydotool.enable = true;

      nautilus-open-any-terminal = {
        enable = true;
        terminal = "ghostty";
      };
    };
    services = {
      displayManager.gdm.enable = true;
      xserver.enable = true;
    };
    environment.systemPackages = with pkgs; [
      polkit_gnome
      gnome-keyring
      nautilus-python
      ghostty
      nautilus
      gnome-text-editor # default text editor
      loupe # default image viewer
      totem # default video player
      papers # default PDF viewer
      gnome-disk-utility # disks
      file-roller # default archiver
    ];
  };
}
