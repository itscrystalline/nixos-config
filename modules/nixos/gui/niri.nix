{
  config,
  pkgs,
  lib,
  ...
}: let
  enabled = config.gui.niri.enable && config.gui.enable;
in {
  options.gui.niri.enable = lib.mkEnableOption "niri & friends (nixos)";
  config = lib.mkIf enabled {
    users.users.${config.core.primaryUser}.extraGroups = ["ydotool"];
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
      displayManager = {
        defaultSession = "niri";
        gdm.enable = true;
      };
      gvfs.enable = true;
      xserver.enable = true;
    };
    environment.systemPackages = with pkgs; [
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
    i18n.inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
    };
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}
