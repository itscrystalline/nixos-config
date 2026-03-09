{
  lib,
  config,
  passthrough ? null,
  pkgs,
  ...
}: let
  inherit (lib) types mkOption;
  inherit (config.hm) core;
in {
  imports = [
    ./nix
    ./programs
    ./gui
    ./services
    ./theming
  ];

  options.hm = {
    core = {
      username = mkOption {
        type = types.str;
        description = "Username of this user.";
        default = "";
      };
      stateVersion = mkOption {
        type = types.str;
        description = "HM State version.";
        default = "24.11";
      };
    };
    bluetooth.enable = lib.mkEnableOption "Bluetooth";
  };

  config = lib.mkMerge [
    (lib.mkIf (passthrough != null) {
      hm = {
        programs = {
          gui = {
            enable = lib.mkForce (passthrough.gui.enable && passthrough.programs.enable);
            obs.enable = lib.mkForce passthrough.obs.enable;
          };
        };
        gui = {
          enable = lib.mkForce passthrough.gui.enable;
          niri.enable = lib.mkForce passthrough.niri.enable;
        };
        bluetooth.enable = lib.mkForce passthrough.bluetooth.enable;
        flatpak.enable = lib.mkForce passthrough.flatpak.enable;
      };
    })

    {
      home = {
        inherit (core) username;
        homeDirectory =
          if pkgs.stdenv.isDarwin
          then "/Users/${core.username}"
          else "/home/${core.username}";
        stateVersion = "24.11";
      };
      programs.home-manager.enable = true;
    }
  ];
}
