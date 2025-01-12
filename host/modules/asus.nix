{ pkgs, lib, ... }:
{
  hardware.asus.battery = {
    chargeUpto = 85;   # Maximum level of charge for your battery, as a percentage.
    enableChargeUptoScript = true; # Whether to add charge-upto to environment.systemPackages. `charge-upto 85` temporarily sets the charge limit to 85%.
  };

  services = {
      asusd = {
        enable = true;
        enableUserService = true;
      };
      # supergfxd = {
      #   enable = true;
      #   settings = {
      #     # mode = "Integrated";
      #     vfio_enable = true;
      #     vfio_save = false;
      #     always_reboot = false;
      #     no_logind = false;
      #     logout_timeout_s = 20;
      #     hotplug_type = "Asus";
      #   };
      # };

      power-profiles-daemon.enable = false;
      thermald.enable = true;
      # auto-cpufreq = {
      #   enable = false;
      #   settings = {
      #     battery = {
      #        governor = "powersave";
      #        turbo = "never";
      #     };
      #     charger = {
      #        governor = "performance";
      #        turbo = "auto";
      #     };
      #   };
      # };

      tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

          # The following prevents the battery from charging fully to
          # preserve lifetime. Run `tlp fullcharge` to temporarily force
          # full charge.
          # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
          START_CHARGE_THRESH_BAT0 = 30;
          STOP_CHARGE_THRESH_BAT0 = 85;

          # 100 being the maximum, limit the speed of my CPU to reduce
          # heat and increase battery usage:
          CPU_MIN_PERF_ON_AC = 0;
          CPU_MAX_PERF_ON_AC = 100;
          CPU_MIN_PERF_ON_BAT = 0;
          CPU_MAX_PERF_ON_BAT = 65;
        };
      };
  };

  # systemd.services.supergfxd.path = [ pkgs.kmod pkgs.pciutils ];

  hardware.enableRedistributableFirmware = true;
}
