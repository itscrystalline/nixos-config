{
  lib,
  config,
  pkgs,
  ...
}: let
  enabled = config.crystals-services.boinc.enable;
  guiEnabled = config.gui.enable;
in {
  options.crystals-services.boinc = {
    enable = lib.mkEnableOption "BOINC project computing";
    # creds = {
    #   url = lib.mkOption {
    #     type = lib.types.str;
    #     description = "The project's URL.";
    #     default = "";
    #   };
    #   key = lib.mkOption {
    #     type = lib.types.str;
    #     description = "The project's key.";
    #     default = "";
    #   };
    #   password = lib.mkOption {
    #     type = lib.types.path;
    #     description = "The secret containing the project accounts' password.";
    #     default = "";
    #   };
    # };
  };
  config = lib.mkIf enabled {
    services.boinc = {
      enable = true;
      package =
        if guiEnabled
        then pkgs.boinc
        else pkgs.boinc-headless;
    };
    users.users.${config.core.primaryUser}.extraGroups = ["boinc"];
  };
}
