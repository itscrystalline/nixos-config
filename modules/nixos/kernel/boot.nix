{
  lib,
  config,
  ...
}: let
  inherit (config) boot;
  inherit (lib) types;
  attrNamesToTrue = types.coercedTo (types.listOf types.str) (
    enabledList: lib.genAttrs enabledList (_attrName: true)
  ) (types.attrsOf types.bool);
in {
  options.boot = {
    stage1AvailableModules = lib.mkOption {
      type = attrNamesToTrue;
      description = "Kernel modules available during stage 1.";
    };
    stage1LoadedModules = lib.mkOption {
      type = attrNamesToTrue;
      description = "Kernel modules loaded during stage 1.";
    };

    verbosity = lib.mkOption {
      type = types.enum ["silent" "verbose" "plymouth"];
      description = "Boot logging verbosity.";
      default = "verbose";
    };
  };

  config.boot.initrd = {
    availableKernelModules = boot.stage1AvailableModules;
    kernelModules = boot.stage1LoadedModules;
  };
}
