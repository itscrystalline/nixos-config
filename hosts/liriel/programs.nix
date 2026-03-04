{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    doas-sudo-shim
  ];
}
