{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.gui) graphics;
  enabled = graphics.enable;
in {
  options.gui.graphics = {
    enable = lib.mkEnableOption "graphics" // {default = config.gui.enable;};
    enableSpecialisation = lib.mkEnableOption "noDGPU specialisation" // {default = true;};

    prime = {
      enable = lib.mkEnableOption "NVIDIA PRIME" // {default = true;};
      intelBusID = lib.mkOption {
        type = lib.types.str;
        description = "The Intel GPU's bus ID.";
        default = "";
      };
      nvidiaBusID = lib.mkOption {
        type = lib.types.str;
        description = "The NVIDIA GPU's bus ID.";
        default = "";
      };
    };
  };

  config = lib.mkIf enabled {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;

        extraPackages = with pkgs; [intel-media-driver libvdpau-va-gl libva-utils];
        extraPackages32 = with pkgs.pkgsi686Linux; [intel-media-driver];
      };

      nvidia = {
        open = pkgs.lib.mkForce false; # Set to false for proprietary drivers

        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = true;
        dynamicBoost.enable = true; # nvidia-powerd

        prime = lib.mkIf graphics.prime.enable ({
            offload.enable = true;
            offload.enableOffloadCmd = true;
          }
          // lib.optionalAttrs (graphics.prime.intelBusID != "") {
            intelBusId = graphics.prime.intelBusID;
          }
          // lib.optionalAttrs (graphics.prime.nvidiaBusID != "") {
            nvidiaBusId = graphics.prime.nvidiaBusID;
          });
      };
    };
    environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

    services.xserver.videoDrivers = ["nvidia"];

    specialisation.noDGPU.configuration = lib.mkIf graphics.enableSpecialisation {
      services.udev.extraRules = ''
        # Remove NVIDIA USB xHCI Host Controller devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA USB Type-C UCSI devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA Audio devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA VGA/3D controller devices
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
      '';
      kernel = {
        modprobeConfig = [
          ''
            blacklist nouveau
            options nouveau modeset=0
          ''
        ];
        moduleBlacklist = ["nouveau" "nvidia" "nvidia_drm" "nvidia_modeset"];
      };
    };

    environment.systemPackages = with pkgs; [
      libva-utils
      nvtopPackages.nvidia
      nvtopPackages.intel
      intel-gpu-tools
    ];
  };
}
