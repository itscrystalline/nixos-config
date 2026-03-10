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
      clean.enable = true;
      clean.extraArgs = "--keep-since ${builtins.toString nix.nh.keepSince} --keep ${builtins.toString nix.keepGenerations}";
    };
  };
}
