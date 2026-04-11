{
  lib,
  config,
  ...
}: let
  inherit (config) nix;
in {
  imports = [./settings.nix ./remote-building.nix ./auto-update.nix];

  options.nix = {
    nh = {
      enable = lib.mkEnableOption "nix-helper";
      keepSince = lib.mkOption {
        type = lib.types.str;
        description = "NH option --keep-since, how long to keep lingering store paths for.";
        example = "1w";
        default = "1w";
      };
      dates = lib.mkOption {
        type = lib.types.str;
        description = "How often to run `nh clean`. systemd timer format.";
        example = "weekly";
        default = "weekly";
      };
    };
    keepGenerations = lib.mkOption {
      type = lib.types.number;
      default = 3;
      description = "How many NixOS generations to keep.";
    };
  };

  config = {
    programs.nh = {
      inherit (nix.nh) enable;
      clean = {
        inherit (nix.nh) dates;
        enable = true;
        extraArgs = "--keep-since ${builtins.toString nix.nh.keepSince} --keep ${builtins.toString nix.keepGenerations} --optimise";
      };
    };
  };
}
