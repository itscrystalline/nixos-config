{
  lib,
  config,
  ...
}: let
  inherit (config) kernel;
  inherit (lib) types;
  attrNamesToTrue = types.coercedTo (types.listOf types.str) (
    enabledList: lib.genAttrs enabledList (_attrName: true)
  ) (types.attrsOf types.bool);
in {
  options.kernel = {
    package = lib.mkOption {
      type = types.package;
      description = "Linux kernel package.";
    };
    cmdline = lib.mkOption {
      type = types.listOf types.str;
      description = "Linux kernel cmdline arguments.";
    };
    sysctl = lib.mkOption {
      type = types.attrs;
      description = "Linux kernel sysctl options. Passed through to `boot.kernel.sysctl`.";
    };
    hibernate = {
      enable = lib.mkEnableOption "hibernation";
      device = lib.mkOption {
        type = types.nullOr types.str;
        description = "Device to hibernate to.";
      };
    };
    supportedFilesystems = lib.mkOption {
      type = types.listOf types.str;
      description = "Supported Filesystems.";
    };
    emulatedArchitectures = lib.mkOption {
      type = types.listOf types.str;
      description = "Binfmt emulated architectures.";
    };

    stage2Modules = lib.mkOption {
      type = attrNamesToTrue;
      description = "Kernel modules available during stage 2.";
    };
    stage2ModulePackages = lib.mkOption {
      type = types.listOf types.package;
      description = "Kernel modules available during stage 2.";
    };
  };

  config.boot = {
    kernelPackages = kernel.package;
    kernel.sysctl = kernel.sysctl;
    resumeDevice = lib.optionalString kernel.hibernate.enable kernel.hibernate.device;
    inherit (kernel) supportedFilesystems;
    binfmt.emulatedSystems = kernel.emulatedArchitectures;
    kernelModules = kernel.stage2Modules;
    extraModulePackages = kernel.stage2ModulePackages;
  };
}
