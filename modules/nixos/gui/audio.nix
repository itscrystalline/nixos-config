{
  lib,
  config,
  ...
}: let
  inherit (config.gui) audio;
  enabled = audio.enable && config.gui.enable;
in {
  options.gui.audio.enable = lib.mkEnableOption "PipeWire audio" // {default = config.gui.enable;};
  config = lib.mkIf enabled {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      extraConfig.pipewire = {
        "98-crackling-fix" = {
          "context.properties" = {
            "default.clock.quantum" = 1024;
            "default.clock.min-quantum" = 1024;
            "default.clock.max-quantum" = 8192;
          };
        };
      };

      wireplumber.extraConfig = lib.mkIf config.bluetooth.enable {
        bluetoothEnhancements = {
          "monitor.bluez.properties" = {
            "bluez5.enable-sbc-xq" = true;
            "bluez5.enable-msbc" = true;
            "bluez5.enable-hw-volume" = true;
            "bluez5.roles" = ["a2dp_sink" "a2dp_source" "bap_sink" "bap_source" "hfp_hf" "hfp_ag"];
            "bluez5.codecs" = ["sbc" "sbc_xq" "msbc" "aac" "aptx" "aptx_hd" "ldac"];
          };
        };
      };
    };
  };
}
