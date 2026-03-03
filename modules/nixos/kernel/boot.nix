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
      type = types.either (types.enum ["silent" "verbose"]) (types.submodule {
        options.plymouth = {
          theme = lib.mkOption {
            type = types.str;
            description = "Plymouth theme name.";
          };
          package = lib.mkOption {
            type = types.nullOr types.package;
            description = "Additional Plymouth package.";
          };
        };
      });
      description = "Boot logging verbosity. Can be 'silent', 'verbose' or a plymouth package.";
      default = "verbose";
    };

    bootloader = lib.mkOption {
      type = types.enum ["systemd-boot" "generic"];
      description = "Boot loader. 'systemd-boot' or 'generic'.";
    };
    extraBootEntries = lib.mkOption {
      type = types.attrs;
      description = "Additional boot entries for systemd-boot. Does nothing on 'generic'.";
      default = {};
    };
  };
  config.boot = {
    initrd = {
      availableKernelModules = boot.stage1AvailableModules;
      kernelModules = boot.stage1LoadedModules;
      verbose = boot.verbosity != "silent";
    };
    consoleLogLevel =
      if boot.verbosity == "verbose"
      then 3
      else 0;

    plymouth = lib.mkIf (builtins.isAttrs boot.verbosity) {
      enable = true;
      inherit (boot.verbosity) theme;
      themePackages = lib.optional (boot.verbosity.package != null) boot.verbosity.package;
    };

    loader = {
      efi.canTouchEfiVariables = true;
      grub.enable = false;
      generic-extlinux-compatible.enable = boot.bootloader == "generic";
      systemd-boot = lib.mkIf (boot.bootloader == "systemd-boot") {
        enable = true;
        configurationLimit = config.nix.keepGenerations;
        memtest86.enable = true;
        inherit (boot) extraBootEntries;
      };
    };
  };
}
