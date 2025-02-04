{ config, pkgs, ... }:
{
  options.gui = pkgs.lib.mkOption {
    type = pkgs.lib.types.bool;
    default = true;
  };
}
