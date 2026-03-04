{
  lib,
  config,
  passthrough ? null,
  pkgs,
  ...
}: let
  inherit (lib) types mkOption;
  inherit (config.hm) core;

  secretsResult = builtins.tryEval (import ../../secrets/secrets.nix);
  fileSecrets =
    if secretsResult.success
    then secretsResult.value
    else builtins.trace "WARNING: secrets.nix is encrypted, using dummy secrets." (import ../../secrets/dummy.nix);
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

      doas.enable = mkOption {
        type = types.bool;
        description = "Whether doas-sudo-shim is installed (doas mode).";
        default = false;
      };
    };

    secrets = mkOption {
      type = types.attrs;
      description = "Secrets available to this home configuration.";
      readOnly = true;
    };
  };

  config = lib.mkMerge [
    {
      secrets = lib.mkDefault (
        if passthrough != null
        then passthrough.secrets
        else fileSecrets
      );
    }

    (lib.mkIf (passthrough != null) {
      hm.gui.enable = lib.mkForce passthrough.gui.enable;
      hm.bluetooth.enable = lib.mkForce passthrough.bluetooth.enable;
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
