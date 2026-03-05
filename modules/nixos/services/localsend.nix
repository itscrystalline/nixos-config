{
  lib,
  config,
  pkgs,
  ...
}: let
  enabled = config.crystals-services.localsend.enable;
in {
  options.crystals-services.localsend.enable = lib.mkEnableOption "localsend";
  config = lib.mkIf enabled {
    environment.systemPackages = [pkgs.jocalsend];
    programs.localsend = lib.mkIf config.gui.enable {
      enable = true;
      openFirewall = true;
    };
  };
}
