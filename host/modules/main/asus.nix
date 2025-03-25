{
  pkgs,
  lib,
  ...
}: {
  hardware.asus.battery = {
    chargeUpto = 85; # Maximum level of charge for your battery, as a percentage.
    enableChargeUptoScript = true; # Whether to add charge-upto to environment.systemPackages. `charge-upto 85` temporarily sets the charge limit to 85%.
  };

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };
}
