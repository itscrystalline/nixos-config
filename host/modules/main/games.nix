{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crystal.games;
in {
  options.crystal.games.enable = lib.mkEnableOption "games";
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gamemode
      # Proton
      protonup-qt
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    };
  };
}
