{
  config,
  pkgs,
  lib,
  ...
} @ inputs: let
  cfg = config.crystal.dormpi.localization;
in {
  options.crystal.dormpi.localization.enable = lib.mkEnableOption "dormpi localization configuration" // {default = true;};

  config = lib.mkIf cfg.enable {
    # Set your time zone.
    time.timeZone = "Asia/Bangkok";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "th_TH.UTF-8";
      LC_MEASUREMENT = "th_TH.UTF-8";
      LC_MONETARY = "th_TH.UTF-8";
      LC_NAME = "th_TH.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "th_TH.UTF-8";
      LC_TELEPHONE = "th_TH.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    console.keyMap = "colemak";
  };
}
