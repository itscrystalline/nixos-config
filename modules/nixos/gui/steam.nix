{
  config,
  pkgs,
  lib,
  ...
}: let
  enabled = config.gui.steam.enable && config.gui.enable && config.programs.enable;
in {
  options.gui.steam.enable = lib.mkEnableOption "steam";
  config = lib.mkIf enabled {
    environment.systemPackages = with pkgs; [
      protonup-qt
    ];
    programs = {
      gamemode.enable = true;
      gamescope.enable = true;
      steam = {
        enable = true;
        package = pkgs.steam.override {extraArgs = "-system-composer";}; # for HW accel to work
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        extest.enable = true;
      };
    };
  };
}
