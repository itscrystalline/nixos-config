{
  lib,
  config,
  ...
}: let
  enabled = config.crystals-services.pm.enable;
  profile = config.crystals-services.pm.profile;

  tlpConfigs = {
    workstation = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      # The following prevents the battery from charging fully to
      # preserve lifetime. Run `tlp fullcharge` to temporarily force
      # full charge.
      # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
      START_CHARGE_THRESH_BAT1 = 30;
      STOP_CHARGE_THRESH_BAT1 = 85;

      # 100 being the maximum, limit the speed of my CPU to reduce
      # heat and increase battery usage:
      CPU_MIN_PERF_ON_AC = 20;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 65;

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      # reduce stutter due overscaling
      INTEL_GPU_MIN_FREQ_ON_AC = 600;
      INTEL_GPU_MIN_FREQ_ON_BAT = 400;
      INTEL_GPU_MAX_FREQ_ON_AC = 1050;
      INTEL_GPU_MAX_FREQ_ON_BAT = 1000;
      INTEL_GPU_BOOST_FREQ_ON_AC = 1050;
      INTEL_GPU_BOOST_FREQ_ON_BAT = 1050;
    };
    server = {
      CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_BOOST_ON_AC = 1;

      CPU_SCALING_MIN_FREQ_ON_AC = 400000;
      CPU_SCALING_MAX_FREQ_ON_AC = 2600000;

      INTEL_GPU_MIN_FREQ_ON_AC = 350;
      INTEL_GPU_MAX_FREQ_ON_AC = 1050;
      INTEL_GPU_BOOST_FREQ_ON_AC = 1050;

      PCIE_ASPM_ON_AC = "powersupersave";
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_DRIVER_DENYLIST = "";

      DISK_APM_LEVEL_ON_AC = "1";
      DISK_SPINDOWN_TIMEOUT_ON_AC = "60";
      SATA_LINKPWR_ON_AC = "min_power";
      AHCI_RUNTIME_PM_ON_AC = "on";
      AHCI_RUNTIME_PM_TIMEOUT = 15;

      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_AUDIO = 1;
      USB_EXCLUDE_BTUSB = 0;
      USB_DENYLIST = "";

      SOUND_POWER_SAVE_ON_AC = 1;
      SOUND_POWER_SAVE_CONTROLLER = "Y";

      WIFI_PWR_ON_AC = "on";

      NMI_WATCHDOG = 0;
      MAX_LOST_WORK_SECS_ON_AC = 60;
    };
  };
in {
  options.crystals-services.pm = {
    enable = lib.mkEnableOption "Laptop power management";
    profile = lib.mkOption {
      type = lib.types.either (lib.types.enum ["workstation" "server"]) lib.types.attrs;
      description = "A TLP preset profile, or custom.";
      default = "workstation";
    };
  };
  config.services = lib.mkIf enabled {
    power-profiles-daemon.enable = false;
    upower.enable = true;
    thermald.enable = true;
    tlp = {
      enable = true;
      settings =
        if builtins.isAttrs profile
        then profile
        else tlpConfigs.${profile};
    };
  };
}
