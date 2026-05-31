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
      niri.package = pkgs.niri-unstable;

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

    # FIXME: https://github.com/NixOS/nixpkgs/issues/523332#issuecomment-4528189167
    environment.sessionVariables.XDG_DATA_DIRS = ["${pkgs.gdm}/share"];
    services.displayManager.gdm.settings.debug.Enable = true;
    security.pam.services.gdm-launch-environment.rules.session.gnome-session-path = {
      inherit (config.security.pam.services.gdm-launch-environment.rules.session.env) control modulePath;
      order = config.security.pam.services.gdm-launch-environment.rules.session.env.order + 50;
      settings = {
        conffile = let
          envfile = pkgs.writeText "gnome-session-path.env" ''
            PATH   DEFAULT="''${PATH}:${pkgs.gnome-session}/bin"
          '';
        in "${envfile}";
        readenv = 0;
      };
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

    systemd.user.services = {
      xdg-desktop-portal.after = ["xdg-desktop-autostart.target"];
      xdg-desktop-portal-gtk.after = ["xdg-desktop-autostart.target"];
      xdg-desktop-portal-gnome.after = ["xdg-desktop-autostart.target"];
      niri-flake-polkit = lib.mkForce {};
    };
  };
}
