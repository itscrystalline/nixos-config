{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config) core;
in {
  imports = [
    ./compatibility
    ./bluetooth
    ./hardware
    ./network
    ./programs
    ./security
    ./services
    ./theming
    ./kernel
    ./nix
    ./gui
  ];

  options.core = {
    name = lib.mkOption {
      type = lib.types.str;
      description = "System name.";
      default = "localhost";
    };

    fileSystems = lib.mkOption {
      type = lib.types.attrs;
      description = "Filesystems to configure in /etc/fstab. Mirrors that of NixOS's ow.";
    };

    arch = lib.mkOption {
      type = lib.types.str;
      description = "Architecture/Platform of the machine.";
      default = "x86_64-linux";
    };

    primaryUser = lib.mkOption {
      type = lib.types.str;
      description = "Main user's username.";
      default = "itscrystalline";
    };

    localization = lib.mkOption {
      type = lib.types.submodule {
        options = {
          keymap = lib.mkOption {
            type = lib.types.str;
            description = "Console keymap.";
            default = "us";
          };
          timezone = lib.mkOption {
            type = lib.types.str;
            description = "Time zone.";
            default = "Asia/Bangkok";
          };
          locale = lib.mkOption {
            type = lib.types.str;
            description = "System locale.";
            default = "ja_JP.UTF-8";
          };
        };
      };
      description = "The system's localization settings.";
      default = {};
    };
  };

  config = with core; {
    _module.check = false;

    inherit fileSystems;
    zramSwap.enable = true;
    hardware.enableRedistributableFirmware = true;
    nixpkgs.hostPlatform = arch;

    time.timeZone = localization.timezone;
    i18n = {
      defaultLocale = localization.locale;
      extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "th_TH.UTF-8";
        LC_MEASUREMENT = "th_TH.UTF-8";
        LC_MONETARY = "th_TH.UTF-8";
        LC_NAME = "th_TH.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "th_TH.UTF-8";
        LC_TELEPHONE = "th_TH.UTF-8";
        LC_TIME = "ja_JP.UTF-8";
      };
    };
    console.keyMap = localization.keymap;

    users.users.${core.primaryUser} = {
      isNormalUser = true;
      home = lib.mkDefault "/home/${core.primaryUser}";
      description = "itscrystalline";
      shell = pkgs.zsh;

      hashedPassword = config.secrets.crystal_password;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPS4b7HxJiG6gAOvqw/fD5CKWP3HqOFdfi2zpwmPi4wu ${core.primaryUser}@rhys"
      ];
    };
  };
}
