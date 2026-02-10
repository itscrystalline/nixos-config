{
  config,
  lib,
  ...
} @ inputs: let
  cfg = config.crystal.desktop.hwMisc;
in {
  imports = [../common/hw-misc.nix];
  options.crystal.desktop.hwMisc.enable = lib.mkEnableOption "desktop hardware misc" // {default = true;};

  config = lib.mkIf cfg.enable {
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    hardware.i2c.enable = true;
  };
}
