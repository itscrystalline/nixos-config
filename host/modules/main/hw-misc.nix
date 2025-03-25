{
  config,
  pkgs,
  ...
} @ inputs: {
  imports = [../common/hw-misc.nix];

  hardware.i2c.enable = true;
}
