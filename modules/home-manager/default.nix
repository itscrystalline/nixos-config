{
  lib,
  config,
  passthrough ? null,
  pkgs,
  ...
}: let
  inherit (lib) types mkOption;
  inherit (config.hm) core;

  unlocked = builtins.pathExists ../../secrets/unlocked;
  fileSecrets =
    if unlocked
    then import ../../secrets/secrets.nix
    else builtins.trace "WARNING: secrets.nix is locked (no secrets/unlocked sentinel), using dummy secrets." (import ../../secrets/dummy.nix);
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

      gui.enable = lib.mkEnableOption "GUI configuration";

      bluetooth.enable = lib.mkEnableOption "Bluetooth";

      obs.enable = lib.mkEnableOption "OBS Studio";
    };

    secrets = mkOption {
      type = types.attrs;
      description = "Secrets available to this home configuration.";
      readOnly = true;
    };
  };

  config = lib.mkMerge [
    {
      secrets = fileSecrets;
    }

    (lib.mkIf (passthrough != null) {
      hm.gui.enable = lib.mkForce passthrough.gui.enable;
      hm.bluetooth.enable = lib.mkForce passthrough.bluetooth.enable;
      hm.niri.enable = lib.mkForce passthrough.niri.enable;
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
