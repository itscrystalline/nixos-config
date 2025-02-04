{ config, pkgs, ... }:
let
  lib = pkgs.lib;
in {
  options.gui = lib.mkOption {
    type = lib.types.bool;
    default = true;
  };
}
