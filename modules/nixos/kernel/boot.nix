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
    network = lib.mkEnableOption "network in the initrd";
    stage1AvailableModules = lib.mkOption {
      type = attrNamesToTrue;
      description = "Kernel modules available during stage 1.";
      default = [];
    };
    stage1LoadedModules = lib.mkOption {
      type = attrNamesToTrue;
      description = "Kernel modules loaded during stage 1.";
      default = [];
    };
    mountPoint = lib.mkOption {
      type = types.str;
      description = "EFI mount point.";
      default = "/boot";
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
            default = null;
          };
        };
      });
      description = "Boot logging verbosity. Can be 'silent', 'verbose' or a plymouth package.";
      default = "verbose";
    };

    bootloader = lib.mkOption {
      type = types.enum ["systemd-boot" "generic" "grub"];
      description = "Boot loader. 'systemd-boot', 'grub' or 'generic'.";
    };
    extraBootEntries = lib.mkOption {
      type = types.attrs;
      description = "Additional boot entries for systemd-boot. Does nothing on 'generic'.";
      default = {};
    };
  };
  config = {
    boot = {
      initrd = {
        availableKernelModules = boot.stage1AvailableModules;
        kernelModules = boot.stage1LoadedModules;
        verbose = boot.verbosity != "silent";
        network.enable = boot.network;
      };
      consoleLogLevel =
        if boot.verbosity == "verbose"
        then 3
        else 0;

      plymouth = lib.mkIf (builtins.isAttrs boot.verbosity) {
        enable = true;
        inherit (boot.verbosity.plymouth) theme;
        themePackages = lib.optional (boot.verbosity.plymouth.package != null) boot.verbosity.plymouth.package;
      };

      loader = {
        efi.canTouchEfiVariables = true;
        efi.efiSysMountPoint = boot.mountPoint;
        grub.enable = boot.bootloader == "grub";
        generic-extlinux-compatible.enable = boot.bootloader == "generic";
        systemd-boot = lib.mkIf (boot.bootloader == "systemd-boot") {
          enable = true;
          configurationLimit = config.nix.keepGenerations;
          memtest86.enable = config.core.arch == "x86_64-linux";
          inherit (boot) extraBootEntries;
        };
      };
    };
    kernel.cmdline =
      (lib.optional (boot.verbosity != "verbose") "quiet")
      ++ (lib.optional (builtins.isAttrs boot.verbosity) "splash");
  };
}
