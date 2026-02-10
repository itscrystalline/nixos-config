{
  config,
  pkgs,
  lib,
  ...
} @ inputs: let
  cfg = config.crystal.graphics;
in {
  options.crystal.graphics.enable = lib.mkEnableOption "graphics";
  config = lib.mkIf cfg.enable {
    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;

    # VA-API
    hardware.graphics.extraPackages = with pkgs; [intel-media-driver libvdpau-va-gl libva-utils];
    hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [intel-media-driver];
    environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";};

    # NVIDIA Optimus
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia = {
      open = pkgs.lib.mkForce false; # Set to false for proprietary drivers

      # package = let
      #   gpl_symbols_linux_615_patch = pkgs.fetchpatch {
      #     url = "https://github.com/CachyOS/kernel-patches/raw/914aea4298e3744beddad09f3d2773d71839b182/6.15/misc/nvidia/0003-Workaround-nv_vm_flags_-calling-GPL-only-code.patch";
      #     hash = "sha256-YOTAvONchPPSVDP9eJ9236pAPtxYK5nAePNtm2dlvb4=";
      #     stripLen = 1;
      #     extraPrefix = "kernel/";
      #   };
      # in
      #   config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #     version = "575.57.08";
      #     sha256_64bit = "sha256-KqcB2sGAp7IKbleMzNkB3tjUTlfWBYDwj50o3R//xvI=";
      #     sha256_aarch64 = "sha256-VJ5z5PdAL2YnXuZltuOirl179XKWt0O4JNcT8gUgO98=";
      #     openSha256 = "sha256-DOJw73sjhQoy+5R0GHGnUddE6xaXb/z/Ihq3BKBf+lg=";
      #     settingsSha256 = "sha256-AIeeDXFEo9VEKCgXnY3QvrW5iWZeIVg4LBCeRtMs5Io=";
      #     persistencedSha256 = "sha256-Len7Va4HYp5r3wMpAhL4VsPu5S0JOshPFywbO7vYnGo=";
      #
      #     patches = [gpl_symbols_linux_615_patch];
      #   };

      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true;

      prime = {
        offload.enable = true;
        offload.enableOffloadCmd = true;

        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    # specialization: disable the NVIDIA driver for the host
    specialisation.noDGPU.configuration = {
      boot.extraModprobeConfig = ''
        blacklist nouveau
        options nouveau modeset=0
      '';

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
      boot.blacklistedKernelModules = ["nouveau" "nvidia" "nvidia_drm" "nvidia_modeset"];
    };

    # CUDA & utilities
    # NOTE: cudaSupport + cudatoolkit add ~400-600 packages to the closure.
    # Also causes other packages (e.g. Blender) to rebuild with CUDA.
    # Consider moving to a devenv/nix-shell if only needed occasionally.
    nixpkgs.config.cudaSupport = true;
    environment.systemPackages = with pkgs; [
      cudatoolkit
      libva-utils
      nvtopPackages.nvidia
      nvtopPackages.intel
      intel-gpu-tools
    ];
  };
}
