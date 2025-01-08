{ config, pkgs, ... }@inputs:
{
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    configPackages = [
      (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/10-virtual-surround-sink.conf" ( builtins.readFile ./pipewire.conf.d/10-virtual-surround-sink.conf ) )
      (pkgs.runCommand "copy-atmos" {
      buildInputs = [ pkgs.coreutils ]; # This ensures coreutils are available for mv or cp commands
      } ''
        mkdir -p $out/share/pipewire/pipewire.conf.d
        cp ${./pipewire.conf.d/atmos.wav} $out/share/pipewire/pipewire.conf.d/atmos.wav
      '')
    ];

    extraConfig = {
      pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 32;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 32;
        };
      };
      pipewire-pulse."92-low-latency" = {
        context.modules = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              pulse.min.req = "32/48000";
              pulse.default.req = "32/48000";
              pulse.max.req = "32/48000";
              pulse.min.quantum = "32/48000";
              pulse.max.quantum = "32/48000";
            };
          }
        ];
        stream.properties = {
          node.latency = "32/48000";
          resample.quality = 1;
        };
      };
    };

    # Wireplumber BT
    wireplumber.extraConfig.bluetoothEnhancements = {
      "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" "a2dp_sink" ];
      };
    };


    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
}
