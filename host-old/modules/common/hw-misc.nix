{
  config,
  lib,
  pkgs,
  ...
} @ inputs: let
  cfg = config.crystal.hw-misc;
in {
  options.crystal.hw-misc.enable = lib.mkEnableOption "hardware misc settings" // {default = true;};

  config = lib.mkIf cfg.enable {
    hardware.enableRedistributableFirmware = true;
  };
}
