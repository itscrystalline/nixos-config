{
  lib,
  config,
  ...
}: let
  enabled = config.crystals-services.docker.enable;
in {
  options.crystals-services.docker.enable = lib.mkEnableOption "Docker";
  config.virtualisation.docker = lib.mkIf enabled {
    enable = true;
    enableOnBoot = true;
  };
}
