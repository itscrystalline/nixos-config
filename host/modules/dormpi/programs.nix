{
  config,
  pkgs,
  secrets,
  ...
}: {
  imports = [../common/programs.nix];

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    doas-sudo-shim
  ];
}
