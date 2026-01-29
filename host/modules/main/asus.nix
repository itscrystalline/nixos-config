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

  services.udev.extraRules = ''
    # Battery Threshold Control - udev rule
    # Grants write access to charge_control_end_threshold for users in the
    # 'battery_ctl' group, only for BAT0
    SUBSYSTEM=="power_supply", KERNEL=="BAT0", \
        RUN+="${pkgs.coreutils-full}/bin/chgrp battery_ctl /sys$devpath/charge_control_end_threshold", \
        RUN+="${pkgs.coreutils-full}/bin/chmod g+w /sys$devpath/charge_control_end_threshold"
  '';
}
