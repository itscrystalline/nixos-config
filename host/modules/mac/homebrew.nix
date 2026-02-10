{
  config,
  lib,
  ...
}: let
  cfg = config.crystal.mac.homebrew;
in {
  options.crystal.mac.homebrew.enable = lib.mkEnableOption "mac homebrew configuration";

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;
      onActivation = {
        cleanup = "zap";
      };
      brews = [];
      casks = [
        {name = "zen";}
      ];
      masApps = {
        "LINE" = 539883307;
      };
    };
  };
}
