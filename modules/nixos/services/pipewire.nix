{
  lib,
  config,
  ...
}: let
  enabled = config.crystals-services.pipewire.enable;
in {
  options.crystals-services.pipewire.enable = lib.mkEnableOption "PipeWire audio";
  config = lib.mkIf enabled {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      wireplumber.extraConfig = {
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
