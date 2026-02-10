# Per-device configuration. Each device's settings are defined here in one place.
# `vars`    — options from vars.nix (gui, doas, keep_generations, username)
# `hostModule` — path to the device's host.nix (controls NixOS module imports)
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
    hostModule = ./host/devices/cwystaws-meowchine/host.nix;
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
    extraNixosConfig = {};
    extraHmConfig = {};
  };
}
