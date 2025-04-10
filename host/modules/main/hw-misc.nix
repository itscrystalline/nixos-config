{
  config,
  lib,
  ...
} @ inputs: {
  imports = [../common/hw-misc.nix];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.i2c.enable = true;
}
