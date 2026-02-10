{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crystal.hm.virtualisation;
in {
  options.crystal.hm.virtualisation.enable = lib.mkEnableOption "virtualisation" // {default = true;};
  config = lib.mkIf cfg.enable (lib.mkIf config.gui {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };

    home.packages = with pkgs; [
      qemu-user
    ];
  });
}
