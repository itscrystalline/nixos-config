{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.hm) virtualisation;
  enabled = virtualisation.enable;
in {
  options.hm.virtualisation.enable = lib.mkEnableOption "virtualisation";

  config = lib.mkIf (enabled && config.hm.gui.enable) {
    dconf.settings."org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };

    home.packages = with pkgs; [
      qemu-user
      winboat
    ];
  };
}
