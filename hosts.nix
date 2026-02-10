# Per-device configuration. Each device's settings are defined here in one place.
# `vars`    — options from vars.nix (gui, doas, keep_generations, username)
# `modules` — list of NixOS module paths to import for this host
# `hm`      — list of additional HM module paths to import
# `extraNixosConfig` — escape hatch: arbitrary NixOS config attrset
# `extraHmConfig`    — escape hatch: arbitrary HM config attrset
{
  cwystaws-meowchine = {
    vars = {
      gui = true;
      doas = true;
      keep_generations = 5;
      username = "itscrystalline";
    };
    modules = [
      ./host/devices/cwystaws-meowchine/hardware-configuration.nix
      ./host/modules/main/boot.nix
      ./host/modules/main/programs.nix
      ./host/modules/main/services.nix
      ./host/modules/main/bluetooth.nix
      ./host/modules/main/graphics.nix
      ./host/modules/main/network.nix
      ./host/modules/main/asus.nix
      ./host/modules/main/niri.nix
      ./host/modules/main/pipewire/pipewire.nix
      ./host/modules/main/games.nix
      ./host/modules/main/flatpak.nix
      ./host/modules/main/virtualisation.nix
      ./host/modules/main/hw-misc.nix
      ./host/modules/main/localization.nix
      ./host/modules/common/security.nix
      ./host/modules/main/mounts.nix
      ./host/modules/common/theming.nix
      ./host/modules/common/compat.nix
      ./host/modules/main/users/nixremote.nix
      ./host/modules/main/users/itscrystalline.nix
    ];
    hm = [];
    extraNixosConfig = {};
    extraHmConfig = {};
  };

  cwystaws-raspi = {
    vars = {
      gui = false;
      doas = true;
      keep_generations = 3;
      username = "itscrystalline";
    };
    modules = [
      ./host/devices/cwystaws-raspi/hardware-configuration.nix
      ./host/modules/raspi/boot.nix
      ./host/modules/raspi/network.nix
      ./host/modules/raspi/services.nix
      ./host/modules/raspi/printers.nix
      ./host/modules/raspi/programs.nix
      ./host/modules/raspi/hw-misc.nix
      ./host/modules/raspi/security.nix
      ./host/modules/common/localization.nix
      ./host/modules/common/theming.nix
      ./host/modules/raspi/users/itscrystalline.nix
    ];
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
    modules = [
      ./host/devices/cwystaws-dormpi/hardware-configuration.nix
      ./host/modules/dormpi/boot.nix
      ./host/modules/dormpi/network.nix
      ./host/modules/dormpi/services.nix
      ./host/modules/dormpi/programs.nix
      ./host/modules/dormpi/localization.nix
      ./host/modules/raspi/hw-misc.nix
      ./host/modules/common/security.nix
      ./host/modules/common/theming.nix
      ./host/modules/common/users/itscrystalline.nix
    ];
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
    modules = [
      ./host/devices/cwystaws-macbook/host.nix
    ];
    hm = [];
    extraNixosConfig = {};
    extraHmConfig = {};
  };
}
