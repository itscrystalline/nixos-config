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

  options = {
    hm = {
      core.username = mkOption {
        type = types.str;
        description = "Username of this user.";
        default = "";
      };

      bluetooth.enable = lib.mkEnableOption "Bluetooth";

      gui.enable = lib.mkEnableOption "GUI configuration";

      obs.enable = lib.mkEnableOption "OBS Studio";
    };

    secrets = mkOption {
      type = types.attrs;
      description = "Secrets available to this home configuration.";
      readOnly = true;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (passthrough != null) {
      hm.programs.gui.enable = lib.mkForce (passthrough.gui.enable && passthrough.programs.enable);
      hm.gui.enable = lib.mkForce passthrough.gui.enable;
      hm.bluetooth.enable = lib.mkForce passthrough.bluetooth.enable;
      hm.gui.niri.enable = lib.mkForce passthrough.niri.enable;
      hm.obs.enable = lib.mkForce passthrough.obs.enable;
      hm.flatpak.enable = lib.mkForce passthrough.flatpak.enable;
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
