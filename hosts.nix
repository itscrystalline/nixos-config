# Per-device configuration. Each device's settings are defined here in one place.
# `vars`    — options from vars.nix (gui, doas, keep_generations, username)
# `hostModule` — path to the device's host.nix (controls NixOS module imports)
# `hm`      — list of additional HM module paths to import
# `extraNixosConfig` — escape hatch: arbitrary NixOS config attrset
# `extraHmConfig`    — escape hatch: arbitrary HM config attrset
#
# Module defaults: core system, full HM, and device-specific modules are
# enabled by default.  Desktop / GUI / extra-service modules default to
# disabled and must be turned on per-host below.
let
  # Desktop NixOS modules to enable for GUI systems
  desktopNixos = {
    crystal.boot.enable = true;
    crystal.desktop.programs.enable = true;
    crystal.desktop.services.enable = true;
    crystal.desktop.network.enable = true;
    crystal.desktop.hwMisc.enable = true;
    crystal.desktop.localization.enable = true;
    crystal.graphics.enable = true;
    crystal.niri.enable = true;
    crystal.pipewire.enable = true;
    crystal.bluetooth.enable = true;
    crystal.flatpak.enable = true;
    crystal.mounts.enable = true;
    crystal.users.desktop.itscrystalline.enable = true;
    crystal.users.nixremote.enable = true;
  };

  # Desktop HM modules to enable for GUI systems
  desktopHm = {
    crystal.hm.gui.enable = true;
    crystal.hm.guiLinux.enable = true;
    crystal.hm.niri.enable = true;
    crystal.hm.blender.enable = true;
    crystal.hm.flatpak.enable = true;
    crystal.hm.nextcloud.enable = true;
  };

  # Gaming modules (NixOS + HM)
  gamingNixos = {
    crystal.games.enable = true;
    crystal.virtualisation.enable = true;
  };

  gamingHm = {
    crystal.hm.games.enable = true;
    crystal.hm.gamesLinux.enable = true;
    crystal.hm.virtualisation.enable = true;
  };
in {
  cwystaws-meowchine = {
    vars = {
      gui = true;
      doas = true;
      keep_generations = 5;
      username = "itscrystalline";
    };
    hostModule = ./host/devices/cwystaws-meowchine/host.nix;
    hm = [];
    extraNixosConfig =
      desktopNixos
      // gamingNixos
      // {
        crystal.asus.enable = true;
      };
    extraHmConfig = desktopHm // gamingHm;
  };

  cwystaws-raspi = {
    vars = {
      gui = false;
      doas = true;
      keep_generations = 3;
      username = "itscrystalline";
    };
    hostModule = ./host/devices/cwystaws-raspi/host.nix;
    hm = [];
    extraNixosConfig = {};
    extraHmConfig = {};
  };

  cwystaws-dormpi = {
    vars = {
      gui = false;
      doas = true;
      keep_generations = 3;
      username = "itscrystalline";
    };
    hostModule = ./host/devices/cwystaws-dormpi/host.nix;
    hm = [];
    extraNixosConfig = {};
    extraHmConfig = {};
  };

  cwystaws-macbook = {
    vars = {
      gui = true;
      doas = true;
      keep_generations = 5;
      username = "itscrystalline";
    };
    hostModule = ./host/devices/cwystaws-macbook/host.nix;
    hm = [];
    extraNixosConfig = {
      crystal.mac.homebrew.enable = true;
      crystal.users.mac.itscrystalline.enable = true;
    };
    extraHmConfig = desktopHm;
  };
}
