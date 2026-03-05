{
  lib,
  config,
  ...
}: let
  inherit (config.crystals-services) argonone;
  enabled = argonone.enable;
in {
  options.crystals-services.argonone = {
    enable = lib.mkEnableOption "Argonone fan/power controller";
    fans = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      description = "Fan speed percentages corresponding to each temperature threshold.";
      default = [30 60 100];
    };
    temps = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      description = "Temperature thresholds in °C for fan speed steps.";
      default = [45 60 70];
    };
    hysteresis = lib.mkOption {
      type = lib.types.int;
      description = "Temperature hysteresis in °C before stepping down fan speed.";
      default = 5;
    };
  };
  config = lib.mkIf enabled {
    services.hardware.argonone.enable = true;
    environment.etc."argononed.conf".text = ''
      fans = ${lib.concatStringsSep ", " (map toString argonone.fans)}
      temps = ${lib.concatStringsSep ", " (map toString argonone.temps)}

      hysteresis = ${toString argonone.hysteresis}
    '';
  };
}
