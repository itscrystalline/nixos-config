{ config, pkgs, ... }@inputs:
{
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # VA-API
  hardware.graphics.extraPackages = with pkgs; [ intel-media-driver libvdpau-va-gl libva-utils ];
  hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [ intel-media-driver ];
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  # NVIDIA Optimus
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = false; # Set to false for proprietary drivers

    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
