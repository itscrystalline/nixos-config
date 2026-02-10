# Per-device configuration. Each device's settings are defined here in one place.
# These values are used by both the NixOS/Darwin system config and home-manager.
{
  cwystaws-meowchine = {
    gui = true;
    doas = true;
    keep_generations = 5;
    username = "itscrystalline";
  };

  cwystaws-raspi = {
    gui = false;
    doas = true;
    keep_generations = 3;
    username = "itscrystalline";
  };

  cwystaws-dormpi = {
    gui = false;
    doas = true;
    keep_generations = 3;
    username = "itscrystalline";
  };

  cwystaws-macbook = {
    gui = true;
    doas = true;
    keep_generations = 5;
    username = "itscrystalline";
  };
}
