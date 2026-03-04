{
  config,
  lib,
  ...
}: let
  enabled = config.programs.enable && config.gui.enable;
in {
  config = lib.mkIf enabled {
    programs.wireshark = {
      enable = true;
      dumpcap.enable = true;
      usbmon.enable = true;
    };
    users.users.${config.core.primaryUser}.extraGroups = ["wireshark"];
  };
}
