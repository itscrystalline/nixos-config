{
  config,
  pkgs,
  ...
} @ inputs: {
  imports = [../common/services.nix];

  systemd.extraConfig = "DefaultTimeoutStopSec=20s";
  systemd.user.extraConfig = "DefaultTimeoutStopSec=20s";

  # fwupd
  services.fwupd.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gvfs.enable = true;

  # TeamViewer service
  services.teamviewer.enable = true;

  # Suspend on power button click
  services.logind.powerKey = "suspend";

  # ananicy: an auto nice daemon
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  # sched-ext scheduler
  services.scx.enable = false; # by default uses scx_rustland scheduler
  services.scx.scheduler = "scx_bpfland";

  services.power-profiles-daemon.enable = false;
  services.thermald.enable = true;

  services.earlyoom = {
    enableNotifications = true;
  };

  services.sunshine = {
    package = pkgs.unstable.sunshine;
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  services.tlp = {
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
  };
}
