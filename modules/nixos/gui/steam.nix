{
  config,
  pkgs,
  lib,
  ...
}: let
  enabled = config.gui.steam.enable && config.gui.enable;
in {
  options.gui.steam.enable = lib.mkEnableOption "steam";
  config = lib.mkIf enabled {
    environment.systemPackages = with pkgs; [
      gamemode
      # Proton
      protonup-qt
    ];

    programs.steam = {
      enable = true;
      package = pkgs.steam.override {extraArgs = "-system-composer";}; # for HW accel to work
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      extest.enable = true;
    };
  };
}
