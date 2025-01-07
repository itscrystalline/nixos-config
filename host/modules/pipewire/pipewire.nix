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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
}
