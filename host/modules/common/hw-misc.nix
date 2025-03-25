{
  config,
  pkgs,
  ...
} @ inputs: {
  hardware.enableRedistributableFirmware = true;
}
