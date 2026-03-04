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
  imports = [];

  options.hm.core = {
    username = mkOption {
      type = types.str;
      description = "Username of this user.";
      default = "";
    };
  };

  config = {
    home = {
      inherit (core) username;
      homeDirectory =
        if pkgs.stdenv.isDarwin
        then "/Users/${core.username}"
        else "/home/${core.username}";
      stateVersion = "24.11";
    };
    programs.home-manager.enable = true;
  };
}
