{
  config,
  pkgs,
  lib,
  secrets,
  ...
}: let
  cfg = config.crystal.dormpi.programs;
in {
  imports = [../common/programs.nix];

  options.crystal.dormpi.programs.enable = lib.mkEnableOption "dormpi programs configuration" // {default = true;};

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
      doas-sudo-shim
    ];
  };
}
