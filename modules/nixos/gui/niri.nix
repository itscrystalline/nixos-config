{
  config,
  pkgs,
  lib,
  options,
  ...
}: let
  enabled = config.gui.niri.enable && config.gui.enable;
in {
  options.gui.niri.enable = lib.mkEnableOption "niri & friends (nixos)";
  config = lib.mkIf enabled {
    users.users.${config.core.primaryUser}.extraGroups = ["ydotool"];
    programs = lib.mkMerge [
      {
        niri.enable = true;
        niri.package = pkgs.niri-unstable.overrideAttrs (_: {
          patches = [
            (pkgs.fetchpatch {
              url = "https://github.com/user-attachments/files/28446966/color.patch";
              hash = "sha256-cqyport7l+NOxAr/0LICJ2cP4+h7MZXGpwf/PZDsX+A=";
            })
          ];
        });

        ydotool.enable = true;

        nautilus-open-any-terminal = {
          enable = true;
          terminal = "ghostty";
        };
      }

      (lib.optionalAttrs (options.programs ? noctalia-greeter) {
        noctalia-greeter = {
          enable = true;
          greeter-args = "--session ${config.services.displayManager.defaultSession}";
        };
      })
    ];
    services = lib.mkMerge [
      {
        displayManager.defaultSession = "niri";

        gvfs.enable = true;
        xserver.enable = true;
        xserver.xkb = {
          layout = "us";
          variant = "";
        };
      }

      (
        if (options.programs ? noctalia-greeter)
        then {
          greetd.settings.default_session.user = config.core.primaryUser;
        }
        else {
          services.displayManager.ly.enable = true;
        }
      )
    ];

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
      gnome-calculator # calc (short for calculator)
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

    systemd.user.services = {
      xdg-desktop-portal.after = ["xdg-desktop-autostart.target"];
      xdg-desktop-portal-gtk.after = ["xdg-desktop-autostart.target"];
      xdg-desktop-portal-gnome.after = ["xdg-desktop-autostart.target"];
      niri-flake-polkit = lib.mkForce {};
    };
  };
}
