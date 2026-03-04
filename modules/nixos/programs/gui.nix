{
  config,
  lib,
  ...
}: let
  enabled = config.programs.enable && config.gui.enable;
in {
  options.programs.gui.wireshark.enable = lib.mkEnableOption "Wireshark";
  config = lib.mkMerge [
    (lib.mkIf enabled {})
    (lib.mkIf config.programs.gui.wireshark.enable {
      programs.wireshark.enable = true;
      users.users.${config.core.primaryUser}.extraGroups = ["wireshark" "dumpcap"];
    })
  ];
}
