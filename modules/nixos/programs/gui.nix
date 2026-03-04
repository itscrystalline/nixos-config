{
  config,
  lib,
  ...
}: let
  wireshark = config.programs.gui.wireshark.enable;
in {
  options.programs.gui.wireshark.enable = lib.mkEnableOption "Wireshark";
  config = lib.mkIf wireshark {
    programs.wireshark = {
      enable = true;
      dumpcap.enable = true;
      usbmon.enable = true;
    };
    users.users.${config.core.primaryUser}.extraGroups = ["wireshark"];
  };
}
