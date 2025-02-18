{ config, pkgs, lib, ... }:
lib.mkIf config.gui {  
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  home.packages = with pkgs; [
    qemu-user
  ];
}
