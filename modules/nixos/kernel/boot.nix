{
  lib,
  config,
  pkgs,
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
      type = types.enum ["systemd-boot" "generic" "grub" "limine"];
      description = "Boot loader. 'limine', 'systemd-boot', 'grub' or 'generic'.";
    };
    extraBootEntries = lib.mkOption {
      type = types.nullOr (types.oneOf [types.lines types.attrs]);
      description = "Additional boot entries for systemd-boot/limine/grub. Does nothing on 'generic'.";
      default = null;
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

      loader = let
        isx86_64 = config.core.arch == "x86_64-linux";
      in {
        efi.efiSysMountPoint = boot.mountPoint;

        generic-extlinux-compatible.enable = boot.bootloader == "generic";

        grub = lib.mkIf (boot.bootloader == "grub") {
          enable = true;
          memtest86.enable = isx86_64;
          extraEntries =
            if (builtins.isString boot.extraBootEntries)
            then boot.extraBootEntries
            else if (builtins.isNull boot.extraBootEntries)
            then ""
            else builtins.throw "`boot.extraBootEntries` must be a string for the GRUB bootloader.";
        };

        efi.canTouchEfiVariables = boot.bootloader == "systemd-boot";
        systemd-boot = lib.mkIf (boot.bootloader == "systemd-boot") {
          enable = true;
          configurationLimit = config.nix.keepGenerations;
          memtest86.enable = isx86_64;
          extraBootEntries =
            if (builtins.isAttrs boot.extraBootEntries)
            then boot.extraBootEntries
            else if (builtins.isNull boot.extraBootEntries)
            then {}
            else builtins.throw "`boot.extraBootEntries` must be an attrset for the systemd-boot bootloader.";
        };

        limine = lib.mkIf (boot.bootloader == "limine") {
          enable = true;
          resolution = "1920x1080";
          extraEntries = ''
            ${
              if (builtins.isString boot.extraBootEntries)
              then boot.extraBootEntries
              else if (builtins.isNull boot.extraBootEntries)
              then ""
              else builtins.throw "`boot.extraBootEntries` must be a string for the limine bootloader."
            }
            ${
              lib.optionalString isx86_64 ''
                /memtest86
                protocol: chainload
                path: boot():///efi/memtest86/memtest86.efi
              ''
            }
          '';
          additionalFiles = lib.optionalAttrs isx86_64 {"efi/memtest86/memtest86.efi" = "${pkgs.memtest86-efi}/BOOTX64.efi";};
          maxGenerations = config.nix.keepGenerations;
          style.interface.branding = config.core.name;
        };
      };
    };
    kernel.cmdline =
      (lib.optional (boot.verbosity != "verbose") "quiet")
      ++ (lib.optional (builtins.isAttrs boot.verbosity) "splash");
  };
}
