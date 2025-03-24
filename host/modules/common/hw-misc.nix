{ config, pkgs, ... }@inputs:
{
  hardware.i2c.enable = true;
  hardware.enableRedistributableFirmware = true;
}
