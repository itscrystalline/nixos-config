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
      auto-cpufreq = {
        enable = false;
        settings = {
          battery = {
             governor = "powersave";
             turbo = "never";
          };
          charger = {
             governor = "performance";
             turbo = "auto";
          };
        };
      };
  };

  # systemd.services.supergfxd.path = [ pkgs.kmod pkgs.pciutils ];

  hardware.enableRedistributableFirmware = true;
}
